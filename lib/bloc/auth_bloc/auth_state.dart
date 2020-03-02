import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MovieDB/bloc/movies_bloc/movies_state.dart';

import 'package:MovieDB/model/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class InitialAuthState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoggedInState extends AuthState {

final FirebaseUser user;
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

class AuthLoadingState extends AuthState {

  @override
  List<Object> get props => [];
}

class EmailChangeState extends MoviesState{

  final String email;
  EmailChangeState({
    this.email,
  });

  @override
  List<Object> get props => [email];
}

class PasswordChangeState extends AuthState {

  final String password;
  PasswordChangeState({
    this.password,
  });

  @override
  List<Object> get props => [password];
}

class AuthErrorState extends AuthState {

final String error;
  AuthErrorState({
    this.error,
  });

  @override
  List<Object> get props => [error];
  
}
class AuthLoginState extends AuthState {

final FirebaseUser user;
  AuthLoginState({
    this.user,
  });

  @override
  List<Object> get props => [user];
  
}
