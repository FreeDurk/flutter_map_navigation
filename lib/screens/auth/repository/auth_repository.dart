// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get userChanges => _auth.userChanges();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Future<User?> authenticate() async {
  //   try {
  //     final result = await _auth.signInWithEmailAndPassword(
  //       email: auth.email,
  //       password: auth.password,
  //     );
  //     return result.user;
  //   } on FirebaseException catch (e) {
  //     print(e.message.toString());
  //   }
  //   return null;
  // }

  // Future<void> registration(RegistrationModel registrationModel) async {
  //   try {
  //     final response = await _auth.createUserWithEmailAndPassword(
  //       email: registrationModel.email,
  //       password: registrationModel.password,
  //     );

  //     if (response.user != null) {
  //       // User user = response.user!;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     print(e.message);
  //   }
  // }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
