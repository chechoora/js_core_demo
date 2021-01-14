import 'dart:ffi';

import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:flutter_jscore/jscore/js_context.dart';
import 'package:flutter_jscore/jscore/js_object.dart';
import 'package:js_core_demo/model.dart';

class JsObjectFactory {
  void setupCake(JSContext context, Cake cake) {
    final cakeClass = JSClass.create(JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'Cake',
    ));
    final cakeObject = JSObject.make(context, cakeClass);
    cakeObject.setProperty(
      'pieces',
      JSValue.makeNumber(context, cake.pieces.toDouble()),
      JSPropertyAttributes.kJSPropertyAttributeNone,
    );
    cakeObject.setProperty(
      'hasGluten',
      JSValue.makeBoolean(context, cake.hasGluten),
      JSPropertyAttributes.kJSPropertyAttributeNone,
    );
    cakeObject.setProperty(
      'topping',
      JSValue.makeString(context, cake.topping),
      JSPropertyAttributes.kJSPropertyAttributeNone,
    );
    context.globalObject.setProperty(
      'cake',
      cakeObject.toValue(),
      JSPropertyAttributes.kJSPropertyAttributeDontDelete,
    );
  }

  void setupGuests(JSContext context, List<Guest> guests) {
    final guestClass = JSClass.create(JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'Guest',
    ));
    List<JSValue> jsGuests = [];
    for (var value in guests) {
      final guestObject = JSObject.make(context, guestClass);
      guestObject.setProperty(
        'name',
        JSValue.makeString(context, value.name),
        JSPropertyAttributes.kJSPropertyAttributeNone,
      );
      guestObject.setProperty(
        'favoriteToppings',
        JSObject.makeArray(
          context,
          JSValuePointer.array(
            value.favoriteToppings
                .map(
                  (topping) => JSValue.makeString(
                    context,
                    topping,
                  ),
                )
                .toList(),
          ),
        ).toValue(),
        JSPropertyAttributes.kJSPropertyAttributeNone,
      );
      guestObject.setProperty(
        'glutenAllergic',
        JSValue.makeBoolean(context, value.glutenAllergic),
        JSPropertyAttributes.kJSPropertyAttributeNone,
      );
      jsGuests.add(guestObject.toValue());
    }
    context.globalObject.setProperty(
      'guests',
      JSObject.makeArray(context, JSValuePointer.array(jsGuests)).toValue(),
      JSPropertyAttributes.kJSPropertyAttributeDontDelete,
    );
  }

  void setupUtil(JSContext context) {
    context.globalObject.setProperty(
      'flutterPrint',
      JSObject.makeFunctionWithCallback(
        context,
        'flutterPrint',
        Pointer.fromFunction(_flutterPrint),
      ).toValue(),
      JSPropertyAttributes.kJSPropertyAttributeNone,
    );
  }

  static Pointer _flutterPrint(
    Pointer ctx,
    Pointer function,
    Pointer thisObject,
    int argumentCount,
    Pointer<Pointer> arguments,
    Pointer<Pointer> exception,
  ) {
    final context = JSContext(ctx);
    if (argumentCount > 0) {
      final alertMessage = JSValue(context, arguments[0]).string;
      print('Print from JS: $alertMessage');
    }
    return nullptr;
  }
}
