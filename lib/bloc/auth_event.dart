import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  @override
  List<Object> get props => [];
  
}

class Logout extends AuthEvent {

  @override
  List<Object> get props => [];
  
}

class RegisterEvent extends AuthEvent {

  @override
  List<Object> get props => [];
  
}

class OnEmailChangeEvent extends AuthEvent {

  final String email;
  OnEmailChangeEvent({
    this.email,
  });
  @override
  List<Object> get props => [email];
}

class OnPasswordChangeEvent extends AuthEvent {

final String password;
  OnPasswordChangeEvent({
    this.password,
  });

  @override
  List<Object> get props => [password];
}
