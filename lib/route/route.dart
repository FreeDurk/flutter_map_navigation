import 'package:flutter/material.dart';
import 'package:ryde_navi_app/screens/auth/auth_screen.dart';
import 'package:ryde_navi_app/screens/auth/pages/register.dart';
import 'package:ryde_navi_app/screens/auth/repository/auth_repository.dart';
import 'package:ryde_navi_app/screens/dashboard/dashboard.dart';

AuthRepository authRepo = AuthRepository();

class AppPage {
  static Map<String, Widget> pages = {
    '/': const AuthScreen(),
    '/register': const Register(),
    '/dashboard': Dashboard(onSignOut: () async {
      await authRepo.logout();
    }),
  };
}
