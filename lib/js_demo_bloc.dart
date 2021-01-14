import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:js_core_demo/guest_reposittory.dart';
import 'package:js_core_demo/js/js_validator.dart';
import 'package:js_core_demo/model.dart';

class JsDemoBloc extends Cubit<JsDemoState> {
  JsDemoBloc(
    this.assetBundle,
    this.guestRepository,
  ) : super(IdleState()) {
    _loadData();
  }

  JsValidator _jsValidator;
  final AssetBundle assetBundle;
  final GuestRepository guestRepository;

  void validateCake(Cake cake, List<Guest> guests) {
    print('validateCake: $cake, ${guests.length}');
    final result = _jsValidator.validateScript(cake, guests);
    if (result.result) {
      emit(ValidatedState(result.message));
    } else {
      emit(ErrorState(result.message));
    }
  }

  Future<void> _loadData() async {
    print('_loadData');
    _jsValidator = JsValidator(await assetBundle.loadString('assets/js_evaluation.js'));
    emit(DataState(guestRepository.fetchGuests()));
  }
}

abstract class JsDemoState extends Equatable {}

class IdleState extends JsDemoState {
  IdleState();

  @override
  List<Object> get props => [];
}

class DataState extends JsDemoState {
  DataState(this.guests);

  final List<Guest> guests;

  @override
  List<Object> get props => [double.nan];
}

class ValidatedState extends JsDemoState {
  ValidatedState(this.message);

  final String message;

  @override
  List<Object> get props => [double.nan];
}

class ErrorState extends JsDemoState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object> get props => [double.nan];
}
