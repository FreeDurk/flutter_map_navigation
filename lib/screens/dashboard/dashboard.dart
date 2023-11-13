import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Function onSignOut;
  const Dashboard({super.key, required this.onSignOut});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // final AuthRepository authRepo = AuthRepository();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            "TEST",
            style: TextStyle(color: Colors.red),
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed: () async {
              // await authRepo.logout();
            },
          ),
        ],
      ),
    );
  }
}
