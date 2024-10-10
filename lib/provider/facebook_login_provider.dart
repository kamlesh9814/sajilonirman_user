import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginProvider with ChangeNotifier {
  Map? userData;
  late LoginResult result;
  ////
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///

  login() async {
    result = await FacebookAuth.instance.login();
    print("facebook hello");
    print("Result status is" + result.status.toString());
    if (result.status == LoginStatus.success) {
      ///
      final AccessToken accessToken = result.accessToken!;
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      /////
      notifyListeners();
      return userCredential.user;
      // userData = await FacebookAuth.instance.getUserData();
    } else {
      print("Didnt worked the login with facebook activity");
    }
    // notifyListeners();
  }
}
