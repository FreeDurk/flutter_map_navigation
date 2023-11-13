import 'package:flutter/material.dart';
import 'package:ryde_navi_app/constants/theme_data.dart';
import 'package:ryde_navi_app/screens/auth/utils/header.dart';
import 'package:ryde_navi_app/screens/auth/utils/input_fields.dart';
import 'package:ryde_navi_app/screens/auth/utils/login_icons.dart';
import 'package:ryde_navi_app/utils/app_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(title: "Log In"),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: InputFields(
            controller: emailController,
            title: "Email",
            placeholder: "Enter your emaill address.",
            isPassword: false,
            onChanged: (val) {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: InputFields(
            controller: passwordController,
            title: "Password",
            placeholder: "Enter your password.",
            isPassword: true,
            onChanged: (val) {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Forgot Password?",
                style: TextStyle(
                  color: blkOpacity,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            AppButton(
              text: "Sign in",
              onTap: () async {},
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: blkOpacity),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Sign up via",
              style: TextStyle(color: blkOpacity, fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginIcons(image: "assets/images/facebook.png"),
                SizedBox(
                  width: 7,
                ),
                LoginIcons(image: "assets/images/google.png")
              ],
            )
          ],
        )
      ],
    );
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
