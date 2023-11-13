import 'package:flutter/material.dart';

import 'package:ryde_navi_app/constants/theme_data.dart';

class TransactionButton extends StatelessWidget {
  const TransactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text("Add Transaction"),
    );
  }
}
