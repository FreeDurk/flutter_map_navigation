import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ryde_navi_app/constants/theme_data.dart';
import 'package:ryde_navi_app/screens/auth/repository/auth_repository.dart';
import 'package:ryde_navi_app/screens/auth/utils/header.dart';
import 'package:ryde_navi_app/screens/auth/utils/input_fields.dart';
import 'package:ryde_navi_app/utils/app_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();
  final AuthRepository authRepo = AuthRepository();
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<User?>(
              stream: authRepo.authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                }

                return Form(
                  key: _registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(title: "Sign Up"),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        child: InputFields(
                          controller: nameController,
                          title: "Name",
                          placeholder: "Enter your name.",
                          isPassword: false,
                          onChanged: (val) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        child: InputFields(
                          controller: emailController,
                          title: "Email",
                          placeholder: "Enter your emaill address.",
                          isPassword: false,
                          onChanged: (val) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        child: InputFields(
                          controller: passwordController,
                          title: "Password",
                          placeholder: "Enter your password.",
                          isPassword: true,
                          onChanged: (val) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        child: InputFields(
                          controller: passwordController,
                          title: "Confirm Password",
                          placeholder: "Confirm your password",
                          isPassword: true,
                          onChanged: (val) {},
                        ),
                      ),
                      AppButton(
                        text: "Sign up",
                        onTap: () async {
                          if (_registerFormKey.currentState!.validate()) {
                            await authRepo.registration(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            _navigateToSignIn();
                          }
                        },
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Already have an account? Sign in.",
                            style: TextStyle(color: blkOpacity),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  _navigateToSignIn() {
    Navigator.pushNamed(context, '/');
  }
}
