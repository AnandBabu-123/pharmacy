import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propertysearch/routes/app_routes.dart';

import '../../controllers/drawerControllerX.dart';

class AppDrawer extends StatelessWidget {
   AppDrawer({super.key});
   final drawerController = Get.put(DrawerControllerX());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(() => UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent, // 🌤 Sky blue
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/userLogo.png"),
            ),
            accountName: Text(
              drawerController.name.value.isNotEmpty
                  ? drawerController.name.value
                  : "Guest User", style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              drawerController.email.value.isNotEmpty
                  ? drawerController.email.value
                  : "guest@email.com",style: TextStyle(color: Colors.black)
            ),


          )),

          //
          // Obx(() => ListTile(
          //   leading: const Icon(Icons.badge),
          //   title: Text("User ID: ${drawerController.userId.value}"),
          // )),


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
                leading: const Icon(Icons.edit),
                title: const Text("Update Store Documents"),
                onTap: () {
                  Get.toNamed(AppRoutes.updateStoreDocuments);
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
                leading: const Icon(Icons.person),
                title: const Text("Get User Store"),
                onTap: () {
                  Get.toNamed(AppRoutes.getStoreUser);
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
            leading: const Icon(Icons.local_pharmacy),
            title: const Text(
              "Pharmacy Management",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            children: [

              /// 🔹 Item Management
              ExpansionTile(
                leading: const Icon(Icons.inventory_2),
                title: const Text("Item Management"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_box),
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
                ],
              ),

              /// 🔹 Rack Management
              ExpansionTile(
                leading: const Icon(Icons.view_in_ar),
                title: const Text("Rack Management"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text("Add Rack"),
                    onTap: () {
                      Get.toNamed(AppRoutes.addRackManagement);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text("View Racks"),
                    onTap: () {
                      Get.toNamed(AppRoutes.getRackManagement);
                    },
                  ),
                ],
              ),

              /// 🔹 Purchase Invoice
              ExpansionTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text("Purchase Invoice"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: const Text("Purchase Invoice"),
                    onTap: () {
                      Get.toNamed(AppRoutes.getInvoice);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text("Purchase Report"),
                    onTap: () {
                      Get.toNamed(AppRoutes.getPurchaseReport);
                    },
                  ),
                ],
              ),

              /// 🔹 Sales Invoice
              ExpansionTile(
                leading: const Icon(Icons.point_of_sale),
                title: const Text("Sales Invoice"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.request_quote),
                    title: const Text("Sales Invoice"),
                    onTap: () {
                      Get.toNamed(AppRoutes.salesInVoice);
                    },
                  ),
                ],
              ),

              /// 🔹 Price Management
              ExpansionTile(
                leading: const Icon(Icons.price_change),
                title: const Text("Price Management"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: const Text("Price Manage"),
                    onTap: () {
                      Get.toNamed(AppRoutes.priceManage);
                    },
                  ),
                ],
              ),

              /// 🔹 Stock Management
              ExpansionTile(
                leading: const Icon(Icons.warehouse),
                title: const Text("Stock Management"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.assessment),
                    title: const Text("Stock Report"),
                    onTap: () {
                      Get.toNamed(AppRoutes.stockReport);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.playlist_add_check),
                    title: const Text("Manual Stock"),
                    onTap: () {
                      Get.toNamed(AppRoutes.manualStock);
                    },
                  ),
                ],
              ),

              /// 🔹 GST Report
              ExpansionTile(
                leading: const Icon(Icons.account_balance),
                title: const Text("GST Report"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.summarize),
                    title: const Text("GST Report"),
                    onTap: () {
                      Get.toNamed(AppRoutes.gstReport);
                    },
                  ),
                ],
              ),

              /// 🔹 Customer Management
              ExpansionTile(
                leading: const Icon(Icons.people_alt),
                title: const Text("Customer Management"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.manage_accounts),
                    title: const Text("Customer Management"),
                    onTap: () {
                      Get.toNamed(AppRoutes.customerManagement);
                    },
                  ),
                ],
              ),
            ],
          ),



          /// PURCHASE INVOICE
          // ExpansionTile(
          //   leading: const Icon(Icons.receipt),
          //   title: const Text(
          //     "Purchase Invoice",
          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //   ),
          //   children: [
          //     ListTile(
          //       leading: const Icon(Icons.file_copy),
          //       title: const Text("PurChase Invoice"),
          //       onTap: () {
          //         Get.toNamed(AppRoutes.getInvoice);
          //       },
          //     ),
          //     ListTile(
          //       leading: const Icon(Icons.file_copy),
          //       title: const Text("PurChase Report"),
          //       onTap: () {
          //         Get.toNamed(AppRoutes.getPurchaseReport);
          //       },
          //     ),
          //
          //     ListTile(
          //       leading: const Icon(Icons.file_copy),
          //       title: const Text("Sales InVoice"),
          //       onTap: () {
          //         Get.toNamed(AppRoutes.salesInVoice);
          //       },
          //     ),
          //
          //     ListTile(
          //       leading: const Icon(Icons.file_copy),
          //       title: const Text("Price Manage"),
          //       onTap: () {
          //         Get.toNamed(AppRoutes.priceManage);
          //       },
          //     ),
          //
          //     ListTile(
          //       leading: const Icon(Icons.list),
          //       title: const Text("Stock Report"),
          //       onTap: () {
          //         Get.toNamed(AppRoutes.stockReport);
          //       },
          //     ),
          //     ListTile(
          //       leading: const Icon(Icons.storage),
          //       title: const Text("Manual Stock"),
          //       onTap: () {
          //         Get.toNamed(AppRoutes.manualStock);
          //       },
          //     ),
          //     ListTile(
          //       leading: const Icon(Icons.storage),
          //       title: const Text("GST Report"),
          //       onTap: () {
          //         Get.toNamed(AppRoutes.gstReport);
          //       },
          //     ),
          //
          //     ListTile(
          //       leading: const Icon(Icons.storage),
          //       title: const Text("Customer Management"),
          //       onTap: () {
          //         Get.toNamed(AppRoutes.customerManagement);
          //       },
          //     ),
          //   ],
          // ),

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
