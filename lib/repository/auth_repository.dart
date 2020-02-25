import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_challenge/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userReference =
      Firestore.instance.collection("flutter_ui_challenge");

     GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // 'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

  User userFromFirebaseUser(FirebaseUser firebaseUser) {
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
      if(googleSignInAccount!=null){
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

       AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
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

  Future<dynamic> registerUser(
      String email, String fname, String lname, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user == null) {
        return null;
      } else {
        // print("You have been registered successfully...");
        var savedUser = _saveUserToDatabase(User(
            id: user.uid,
            email: email,
            firstname: fname,
            lastname: lname,
            avatarUrl: user.photoUrl != null ? user.photoUrl : ""));

        if (savedUser == null) {
          return null;
        }

        return User(
            id: user.uid,
            email: email,
            firstname: fname,
            lastname: lname,
            avatarUrl: user.photoUrl != null ? user.photoUrl : "");
      }
    } catch (ex) {
      return ex.message;
      // print(ex.message);
    }
  }

  Future<dynamic> _saveUserToDatabase(User user) async {
    return await userReference.document("data").collection("users").add({
      "id": user.id,
      "email": user.email,
      "firstname": user.firstname,
      "lastname": user.lastname,
      "avatarUrl": user.avatarUrl
    });
    // .whenComplete(()=>"").catchError((doc)=>doc.message);
  }

  Stream<FirebaseUser> listenToSignIn() {
    return _auth.onAuthStateChanged;
  }

  Future<void> logout() async {
    try {
      if(_googleSignIn!=null){
        _googleSignIn.disconnect();
      }
      return _auth.signOut();
    } catch (ex) {
      print(ex);
    }
  }
}
