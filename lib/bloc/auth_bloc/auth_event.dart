import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
 
  @override
  List<Object> get props => [];
}

class GoogleLoginEvent extends AuthEvent {
 
  @override
  List<Object> get props => [];
}

class FacebookLoginEvent extends AuthEvent {

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

class ListenToLoginEvent extends AuthEvent{

  @override
  List<Object> get props => [];
  
}


class AuthStateChangedEvent extends AuthEvent {

  final User user;
  AuthStateChangedEvent({
    this.user,
  });

  @override
  List<Object> get props => [user];
  
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

class OnRegDetailsChangedEvent extends AuthEvent {
  final String firstname, lastname, email, password, confirmPassword;
  OnRegDetailsChangedEvent({
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.confirmPassword,
  });

  @override
  List<Object> get props => [firstname,lastname,email,password,confirmPassword];
}

class LogoutEvent extends AuthEvent{
  @override
  List<Object> get props => [];
  
}
