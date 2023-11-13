import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ryde_navi_app/constants/theme_data.dart';
import 'package:ryde_navi_app/firebase_options.dart';
import 'package:ryde_navi_app/screens/auth/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: const AuthScreen(),
    );
  }
}
