import 'package:flutter_js/javascriptcore/flutter_jscore.dart';
import 'package:flutter_js/javascriptcore/jscore/js_context.dart';
import 'package:js_core_demo/js/js_factory.dart';
import 'package:js_core_demo/model.dart';

class JsValidator {
  JsValidator(this.jsScript);

  final String jsScript;
  final JsObjectFactory _factory = JsObjectFactory();

  ValidationResult validateScript(Cake cake, List<Guest> guests) {
    final context = JSContext.createInGroup();
    _factory.setupCake(context, cake);
    _factory.setupGuests(context, guests);
    _factory.setupUtil(context);
    final resultJsValue = context.evaluate(jsScript);
    final exceptionMessage = _getContextException(context);
    ValidationResult result;
    if (exceptionMessage != null) {
      result = ValidationResult(exceptionMessage, false);
    } else if (resultJsValue.isArray) {
      result = _getValidationMessage(resultJsValue.toObject());
    } else {
      result = ValidationResult.evaluationError();
    }
    context.release();
    return result;
  }

  String? _getContextException(JSContext context) {
    final exceptionValue = context.exception.getValue(context);
    if (exceptionValue.isNull) {
      return null;
    } else {
      return exceptionValue.string;
    }
  }

  ValidationResult _getValidationMessage(JSObject jsObject) {
    final List<String> results = [];
    final count = jsObject.copyPropertyNames().count;
    if (count == 0) {
      return ValidationResult.evaluationError();
    }
    for (var i = 0; i < count; i++) {
      final propertyObject = jsObject.getPropertyAtIndex(i).toObject();
      final guestName = propertyObject.getProperty('name').string;
      results.add(guestName ?? '');
    }
    return ValidationResult('${results.join(', ')} may eat cake', true);
  }
}

class ValidationResult {
  factory ValidationResult.evaluationError() {
    return ValidationResult('Evaluation error', false);
  }

  const ValidationResult(this.message, this.result);

  final String message;
  final bool result;
}
