import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ryde_navi_app/screens/auth/pages/signin.dart';
import 'package:ryde_navi_app/screens/auth/repository/auth_repository.dart';
import 'package:ryde_navi_app/screens/dashboard/dashboard.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthRepository authRepo = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authRepo.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return _buildAuthScreen(snapshot.data);
      },
    );
  }

  Widget _buildAuthScreen(User? user) {
    if (user != null) {
      return Dashboard(onSignOut: () async {
        await authRepo.logout();
      });
    } else {
      return const SignIn();
    }
  }
}
