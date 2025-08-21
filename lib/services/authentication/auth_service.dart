import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  final FirebaseAuth _firebaseAuth;
  FirebaseAuth get firebaseAuth => _firebaseAuth;
  AuthService(this._firebaseAuth);
  Future<(User?, String)> signInWithGoogle();
  Future<void> signOut();
  bool get isUserLoggedin => firebaseAuth.currentUser != null;
}

class AuthServiceImpl extends AuthService {
  AuthServiceImpl(super.firebaseAuth);

  @override
  Future<(User?, String)> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return (null, 'Sign in aborted by user');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await firebaseAuth
          .signInWithCredential(credential);
      return (userCredential.user, '');
    } catch (e) {
      // TODO: sha-256 for android
      debugPrint('Error signing in with Google: $e');
      return (null, e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
