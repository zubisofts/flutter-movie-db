import 'package:equatable/equatable.dart';

import 'package:flutter_ui_challenge/model/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class InitialAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggedInState extends AuthState {

final User user;
  LoggedInState({
    this.user,
  });

  @override
  List<Object> get props => [user];
}

class RegisterState extends AuthState{

  @override
  List<Object> get props => [];

}

class RegisteredState extends AuthState {

final User user;
  RegisteredState({
    this.user,
  });

  @override
  List<Object> get props => [user];
}

class LoadingState extends AuthState {

  @override
  List<Object> get props => [];
}

class EmailChangeState{

  String email;
  EmailChangeState({
    this.email,
  });

  @override
  List<Object> get props => [email];
}

class PasswordChangeState extends AuthState {

  String password;
  PasswordChangeState({
    this.password,
  });

  @override
  List<Object> get props => [password];
}

class ErrorState extends AuthState {

final String error;
  ErrorState({
    this.error,
  });

  @override
  List<Object> get props => [error];
  
}
