// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:join_create_group_functionality/models/users.dart';
import 'package:join_create_group_functionality/services/database.dart';

class CurrentUser extends ChangeNotifier {
  OurUser currentUser = OurUser();

  OurUser get getCurrentUser => currentUser;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> onStartUp() async {
    String retVal = 'error';

    try {
      //try to find better code for this if the error persits!!!!!!!!!!!!!!
      User user = await auth.currentUser!;
      if (user != null) {
        currentUser = await OurDatabse().getUserInfo(user.uid);
      }
      if (currentUser != null) {
        retVal = 'success';
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> signOut() async {
    String retVal = 'error';

    try {
      await auth.signOut();
      currentUser = OurUser();
      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> sigUpUser(
      String email, String password, String fullName) async {
    String retVal = 'error';
    OurUser user = OurUser();

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user.uid = userCredential.user!.uid;
      user.email = userCredential.user!.email;
      user.fullName = fullName;
      String retunString = await OurDatabse().createUser(user);
      if (retunString == 'success') {
        retVal = 'success';
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message.toString();
    }
    return retVal;
  }

  Future<String> logInUserWithEmail(String email, String password) async {
    String retVal = 'error';

    try {
      UserCredential _authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      currentUser = await OurDatabse().getUserInfo(_authResult.user!.uid);
      if (currentUser != null) {
        retVal = 'success';
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message.toString();
    }
    return retVal;
  }

  Future<String> logInUserWithGoogle() async {
    String retVal = 'error';

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      UserCredential _authResult = await auth.signInWithCredential(credential);

      if (_authResult.user != null) {
        currentUser.uid = _authResult.user!.uid;
        currentUser.email = _authResult.user!.email!;
        retVal = 'success';
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message.toString();
    }
    return retVal;
  }
}
