import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:MovieDB/model/user.dart' as NUser;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection("flutter_ui_challenge");

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final facebookLogin = FacebookLogin();

  NUser.User userFromFirebaseUser(User firebaseUser) {
    return NUser.User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        avatarUrl: firebaseUser.photoURL);
  }

  Future<dynamic> loginUser(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (user == null) {
        return null;
      } else {
        // print("You are looged in successfully...");
        return userFromFirebaseUser(user);
      }
    } catch (ex) {
      return ex.message;
      // print(ex.message);
    }
  }

  Future<dynamic> loginUserWithCredentials({BuildContext context}) async {
    try {
      var googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        var result = await _auth.signInWithCredential(credential);
        User user = result.user;
        if (user == null) {
          return null;
        } else {
          // print("You are looged in successfully...");
          return user;
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> loginUserWithFBCredentials({BuildContext context}) async {
    try {
      final result = await facebookLogin.logIn(["email"]);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          var credential =
              FacebookAuthProvider.credential(result.accessToken.token);
          var authResult = await _auth.signInWithCredential(credential);
          User user = authResult.user;
          if (user == null) {
            return null;
          } else {
            // print("You are looged in successfully...");
            return user;
          }
//        _sendTokenToServer(result.accessToken.token);
//        _showLoggedInUI();
          break;
        case FacebookLoginStatus.cancelledByUser:
//        _showCancelledMessage();
          break;
        case FacebookLoginStatus.error:
//        _showErrorOnUI(result.errorMessage);
          break;
      }
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> registerUser(
      String email, String fname, String lname, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      if (user == null) {
        return null;
      } else {
        // print("You have been registered successfully...");
        var savedUser = _saveUserToDatabase(NUser.User(
            id: user.uid,
            email: email,
            firstname: fname,
            lastname: lname,
            avatarUrl: user.photoURL != null ? user.photoURL : ""));

        if (savedUser == null) {
          return null;
        }

        return NUser.User(
            id: user.uid,
            email: email,
            firstname: fname,
            lastname: lname,
            avatarUrl: user.photoURL != null ? user.photoURL : "");
      }
    } catch (ex) {
      return ex.message;
      // print(ex.message);
    }
  }

  Future<dynamic> _saveUserToDatabase(NUser.User user) async {
    return await userReference.doc("data").collection("users").add({
      "id": user.id,
      "email": user.email,
      "firstname": user.firstname,
      "lastname": user.lastname,
      "avatarUrl": user.avatarUrl
    });
    // .whenComplete(()=>"").catchError((doc)=>doc.message);
  }

  Stream<User> listenToSignIn() {
    return _auth.authStateChanges();
  }

  Future<void> logout() async {
    try {
      // if(_googleSignIn!=null){
      _googleSignIn?.signOut();
      facebookLogin?.logOut();
      // }
      return _auth.signOut();
    } catch (ex) {
      print(ex);
    }
  }
}
