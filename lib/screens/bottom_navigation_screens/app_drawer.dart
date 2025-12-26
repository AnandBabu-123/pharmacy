import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propertysearch/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/userLogo.png"),
            ),
            accountName: const Text("Anand Babu"),
            accountEmail: const Text("anand@email.com"),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Get.toNamed(AppRoutes.loginView);
            },
          ),
        ],
      ),
    );
  }
}
