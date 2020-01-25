import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ui_challenge/model/user.dart';

class AuthRespository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userReference =
      Firestore.instance.collection("flutter_ui_challenge");

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

  Future<dynamic> registerUser(
      String email, String fname, String lname, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user == null) {
        return null;
      } else {
        print("You have been registered successfully...");
        var savedUser = _saveUserToDatabase(User(
            id: user.uid,
            email: email,
            firstname: fname,
            lastname: lname,
            avatarUrl: user.photoUrl != null ? user.photoUrl : ""));

            if(savedUser==null){
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

  Future<dynamic> _saveUserToDatabase(User user) async{

    return await userReference.document("data").collection("users").add({
      "id": user.id,
      "email": user.email,
      "firstname": user.firstname,
      "lastname": user.lastname,
      "avatarUrl": user.avatarUrl
    });
    // .whenComplete(()=>"").catchError((doc)=>doc.message);
  }
}
