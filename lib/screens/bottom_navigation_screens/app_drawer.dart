import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propertysearch/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/userLogo.png"),
            ),
            accountName: const Text("Anand Babu"),
            accountEmail: const Text("anand@email.com"),
          ),

          /// STORE DETAILS (Expandable)
          ExpansionTile(
            leading: const Icon(Icons.store),
            title: const Text(
              "Store Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Update Store"),
                onTap: () {
                  Get.toNamed(AppRoutes.updateStoreDetails);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("User Store"),
                onTap: () {
                  Get.toNamed(AppRoutes.userStoreDetails);
                },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text("Store List"),
                onTap: () {
                  Get.toNamed(AppRoutes.storeList);
                },
              ),
            ],
          ),

          /// PHARMACY MANAGEMENT
          ExpansionTile(
            leading: const Icon(Icons.medical_services),
            title: const Text(
              "Pharmacy Management",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Add Item"),
                onTap: () {
                  Get.toNamed(AppRoutes.addPharmacy);
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text("Get Item"),
                onTap: () {
                  Get.toNamed(AppRoutes.searchPharmacyUser);
                },
              ),
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text("Add Rack Management"),
                onTap: () {
                  Get.toNamed(AppRoutes.addRackManagement);
                },
              ),
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text("Rack Management"),
                onTap: () {
                  Get.toNamed(AppRoutes.getRackManagement);
                },
              ),
            ],
          ),

          /// PURCHASE INVOICE
          ExpansionTile(
            leading: const Icon(Icons.receipt),
            title: const Text(
              "Purchase Invoice",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text("Invoice"),
                onTap: () {
                  Get.toNamed(AppRoutes.getInvoice);
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text("PurChase InVoice"),
                onTap: () {
                  Get.toNamed(AppRoutes.getPurchaseReport);
                },
              ),

              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text("Sales InVoice"),
                onTap: () {
                  Get.toNamed(AppRoutes.salesInVoice);
                },
              ),

              ListTile(
                leading: const Icon(Icons.file_copy),
                title: const Text("Price Manage"),
                onTap: () {
                  Get.toNamed(AppRoutes.priceManage);
                },
              ),
            ],
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Get.offAllNamed(AppRoutes.loginView);
            },
          ),
        ],
      ),
    );
  }
}
