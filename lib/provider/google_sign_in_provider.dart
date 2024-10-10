import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;
  late GoogleSignInAuthentication auth;

  login() async {
    try {
      // googleAccount = await _googleSignIn.signIn();
      googleAccount = await _googleSignIn.signIn();
      auth = await googleAccount!.authentication;
      print(auth);
      final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      notifyListeners();

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Exception is" + e.toString());
    }
  }
}
