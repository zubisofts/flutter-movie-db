import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ui_challenge/model/user.dart';

class AuthRespository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser firebaseUser) {
    return User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        avatarUrl: firebaseUser.photoUrl);
  }

  Future<dynamic> loginUser(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user == null) {
        return null;
      } else {
        print("You are looged in successfully...");
        return _userFromFirebaseUser(user);
      }
    } catch (ex) {
      return ex.message;
      // print(ex.message);
    }
  }
}
