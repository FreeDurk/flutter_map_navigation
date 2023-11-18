// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get userChanges => _auth.userChanges();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> authenticate({email, password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseException catch (e) {
      print(e.message.toString());
    }
    return null;
  }

  Future<void> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    final GoogleSignInAccount? account = await googleSignIn.signIn();

    final GoogleSignInAuthentication auth = await account!.authentication;
    final googleCredentials = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);
    _auth.signInWithCredential(googleCredentials);
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult facebookLoginResult = await FacebookAuth.instance.login(
        loginBehavior: LoginBehavior.dialogOnly,
      );

      if (facebookLoginResult.status == LoginStatus.success) {
        final String accessToken = facebookLoginResult.accessToken!.token;
        print(accessToken);
        final OAuthCredential facebookCredentials =
            FacebookAuthProvider.credential(accessToken);

        await _auth.signInWithCredential(facebookCredentials);
      }
    } catch (e) {
      print("======");
      print(e.toString());
    }
  }

  Future<void> registration({email, password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> logout() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;

    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
      return;
    }

    if (accessToken != null) {
      await FacebookAuth.instance.logOut();
      return;
    }

    await _auth.signOut();
  }
}
