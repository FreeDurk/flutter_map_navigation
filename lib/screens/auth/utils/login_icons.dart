import 'package:flutter/material.dart';

class LoginIcons extends StatelessWidget {
  final String image;
  const LoginIcons({required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20)),
      height: 30,
      width: 30,
      child: Image.asset(
        image,
        color: Colors.white,
      ),
    );
  }
}
