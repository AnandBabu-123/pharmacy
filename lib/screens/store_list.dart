
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashbaoard_controller.dart';
import 'bottom_navigation_screens/app_drawer.dart';

class StoreList extends StatelessWidget {
  StoreList({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),

      /// 🌈 GRADIENT APPBAR
      appBar: AppBar(
        title: const Text(
          "StoreList",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF90EE90), // Green
                Color(0xFF87cefa), // Teal
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundImage: AssetImage("assets/userLogo.png"),
            backgroundColor: Colors.white,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),

      /// 🌿 BODY BACKGROUND COLOR
      body: Container(
        color: const Color(0xFFF1F8E9),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.storeList.isEmpty) {
            return const Center(
              child: Text(
                "No Stores Found",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.storeList.length,
            itemBuilder: (context, index) {
              final store = controller.storeList[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// STORE NAME
                      Text(
                        "Name : ${store.name ?? ""}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildRow("Store ID", store.id),
                      _buildRow("Store Category", store.type),
                      _buildRow("Location", store.location),
                      _buildRow("Owner", store.owner),
                      _buildRow("Current Membership", store.currentPlan),
                      _buildRow("GST Number", store.gstNumber),
                      _buildRow("Status", store.status),
                      _buildRow("Store Business Type", store.storeBusinessType),
                      _buildRow(
                        "Store Verified Status",
                        store.storeVerifiedStatus.toString(),
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 UPDATE BUTTON
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text("Update"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            /// call update / open bottom sheet / dialog
                          //  controller.openUpdateStoreBottomSheet(store);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

        }),
      ),


    );
  }




  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT LABEL
          SizedBox(
            width: 200, // controls left alignment
            child: Text(
              "$label :",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          /// RIGHT VALUE
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

}
