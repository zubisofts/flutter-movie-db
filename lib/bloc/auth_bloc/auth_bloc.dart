import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:MovieDB/model/user.dart';
import 'package:MovieDB/repository/auth_repository.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository respository = AuthRepository();
  String email = "";
  String password = "";
  String cpassword = "";
  String fname = "";
  String lname = "";

  StreamSubscription _authSubscription;

  AuthBloc() : super(InitialAuthState());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is LoginEvent) {
      yield* processLoginState();
    }

    if (event is GoogleLoginEvent) {
      yield* _mapGoogleLoggedState();
    }

    if (event is FacebookLoginEvent) {
      yield* _mapFacebookLoggedState();
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
        yield AuthErrorState(error: "Email address should not be empty");
      } else if (fname.length < 1) {
        yield AuthErrorState(error: "Firstname should not be empty");
      } else if (lname.length < 1) {
        yield AuthErrorState(error: "Lastname must not be empty");
      } else if (password != cpassword) {
        yield AuthErrorState(error: "Password do not match.");
      } else {
        // yield LoadingState();
        yield* registerUser();
      }
    }
    if (event is AuthStateChangedEvent) {
      yield* _mapAuthStateChangedState(event.user);
    }
    if (event is ListenToLoginEvent) {
      yield* _mapLoggedState();
    }

    if (event is LogoutEvent) {
      yield* _mapLogoutState();
    }
  }

  Stream<AuthState> processLoginState() async* {
    yield AuthLoadingState();

    dynamic user = await respository.loginUser(email, password);

    if (user is String) {
      yield AuthErrorState(error: user);
    } else {
      yield LoggedInState(user: user);
      add(AuthStateChangedEvent(user: user));
    }
  }

  Stream<AuthState> registerUser() async* {
    yield AuthLoadingState();

    dynamic data =
        await respository.registerUser(email, fname, lname, password);

    if (data is User) {
      yield RegisteredState(user: data);
    } else {
      yield AuthErrorState(error: data);
    }
  }

  Stream<AuthState> _mapLoggedState() async* {
    _authSubscription?.cancel();
    _authSubscription = respository.listenToSignIn().listen((user) {
      // if(user!=null)
      add(AuthStateChangedEvent(
          user: user != null ? user : null));
    });
  }

  Stream<AuthState> _mapAuthStateChangedState(user) async* {
    yield AuthLoginState(user: user);
  }

  Stream<AuthState> _mapLogoutState() async* {
    await respository.logout();
  }

 Stream<AuthState> _mapGoogleLoggedState() async*{
    yield AuthLoadingState();

    dynamic user = await respository.loginUserWithCredentials();

    if (user is String) {
      yield AuthErrorState(error: user);
    } else {
      yield LoggedInState(user: user);
      add(AuthStateChangedEvent(user: user));
    }
 }

 Stream<AuthState> _mapFacebookLoggedState() async*{
    yield AuthLoadingState();

    dynamic user = await respository.loginUserWithFBCredentials();

    if (user is String) {
      yield AuthErrorState(error: user);
    } else {
      yield LoggedInState(user: user);
      add(AuthStateChangedEvent(user: user));
    }
 }
}
