import 'dart:async';

import 'package:s11_login_validacion/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  /*  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast(); */

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

//Insertar los respectivo valores al Stream
  Function(String) get changeEmail => this._emailController.sink.add;
  Function(String) get changePassword => this._passwordController.sink.add;

//regrea el stream de la data
  Stream<String> get streamEmail =>
      this._emailController.stream.transform(validarEmail);
  Stream<String> get streamPassword =>
      this._passwordController.stream.transform(validarPassword);

//en el momento que se tiene la data se dispara el combine latest
  Stream<bool> get formValidStream =>
      Observable.combineLatest2(streamEmail, streamPassword, (e, p) => true);

  dispose() {
    _emailController.close();
    _passwordController.close();
  }

  get email => this._emailController.value;

  get password => this._passwordController.value;
}
