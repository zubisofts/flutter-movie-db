import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_ui_challenge/model/user.dart';
import 'package:flutter_ui_challenge/respository/auth_respository.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRespository respository = AuthRespository();
  String email = "";
  String password = "";
  String cpassword = "";
  String fname = "";
  String lname = "";

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

    if (event is OnRegDetailsChangedEvent) {
      email = event.email;
      fname = event.firstname;
      lname = event.lastname;
      password = event.password;
      cpassword = event.confirmPassword;
    }

    if (event is RegisterEvent) {
      if (email.length < 1) {
        yield ErrorState(error: "Email address should not be empty");
      } else if (fname.length < 1) {
        yield ErrorState(error: "Firstname should not be empty");
      } else if (lname.length < 1) {
        yield ErrorState(error: "Lastname must not be empty");
      } else if (password != cpassword) {
        yield ErrorState(error: "Password do not match.");
      } else {
        // yield LoadingState();
        yield* registerUser();
      }
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

  Stream<AuthState> registerUser() async* {
    yield LoadingState();

    dynamic data =
        await respository.registerUser(email, fname, lname, password);

    if (data is User) {
      yield RegisteredState(user: data);
    } else {
      yield ErrorState(error: data);
    }
  }
}
