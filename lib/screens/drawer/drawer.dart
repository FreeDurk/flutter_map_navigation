import 'package:flutter/material.dart';
import 'package:ryde_navi_app/constants/theme_data.dart';
import 'package:ryde_navi_app/screens/auth/repository/auth_repository.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    AuthRepository authRepo = AuthRepository();
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.6,
      color: secondaryColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/drawer_image.png"),
          ),
          ListTile(
            onTap: () async {
              await authRepo.logout();
            },
            title: Text("Logout", style: Theme.of(context).textTheme.bodySmall),
            leading: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
