import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_ui_challenge/model/user.dart';
import 'package:flutter_ui_challenge/respository/auth_respository.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRespository respository = AuthRespository();
  String email = "";
  String password = "";

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginEvent) {
      yield* processLoginState();
    }

    if (event is OnEmailChangeEvent) {
      email = event.email;
    }

    if (event is OnPasswordChangeEvent) {
      password = event.password;
    }
  }

  Stream<AuthState> processLoginState() async* {

    yield LoadingState();

    dynamic user = await respository.loginUser(email, password);

    if (user is String) {
      
      yield ErrorState(error: user);
    } else {
      yield LoggedInState(user: user);
    }
  }
}
