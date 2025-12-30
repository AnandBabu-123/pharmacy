import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:propertysearch/controllers/user_details_controller.dart';
import 'package:propertysearch/model/serach_user_response.dart';

import '../model/store_details.dart';

class UserStoreDetails extends StatelessWidget {
   UserStoreDetails({super.key});

  final controller = Get.put(UserDetailsController());
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        /// FULL SCREEN GRADIENT (APPBAR + BODY)
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF90EE90), // Green
                Color(0xFF87CEFA), // Teal / Light Blue
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [

                /// CUSTOM APPBAR WITH GRADIENT
                _buildAppBar(),

                /// ROUNDED TAB BAR
                _buildRoundedTabBar(),

                /// TAB CONTENT
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildAddUserTab(),
                      _buildGetUserTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // APP BAR
  // ===============================
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          Text(
            "User Store Details",
            textAlign: TextAlign.center,
            style: TextStyle(

              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================
  // ROUNDED TAB BAR
  // ===============================
  Widget _buildRoundedTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: "Add User"),
          Tab(text: "Get User"),
        ],
      ),
    );
  }

  // ===============================
  // ADD USER TAB
  // ===============================
  Widget _buildAddUserTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          children: [

            /// ROW 1
            Row(
              children: [
                Expanded(child: _inputField("Name", "")),
                const SizedBox(width: 12),
                Expanded(child: _inputField("Address", "")),
              ],
            ),

            const SizedBox(height: 16),

            /// ROW 2
            Row(
              children: [
                Expanded(
                  child: _inputField(
                    "Contact",
                    "",
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _inputField(
                    "Email",
                    "",
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Stores",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.storeList.isEmpty) {
                    return TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "No verified stores available",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                      ),
                    );
                  }

                  return DropdownButtonFormField<Stores>(
                    isExpanded: true,
                    value: controller.selectedStore.value,
                    items: controller.storeList.map((store) {
                      return DropdownMenuItem<Stores>(
                        value: store,
                        child: Text("${store.id} - ${store.name}"),
                      );
                    }).toList(),
                    onChanged: (store) {
                      controller.selectedStore.value = store;
                    },
                    decoration: InputDecoration(
                      hintText: "Select Store",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  );
                })

              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87CEFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


   Widget _buildGetUserTab() {
     return Padding(
       padding: const EdgeInsets.all(16),
       child: Column(
         children: [

           // Name | Email | Mobile input fields
           Row(
             children: [
               Expanded(child: _inputFields("Name", controller.nameController)),
               const SizedBox(width: 12),
               Expanded(
                 child: _inputFields(
                   "Email",
                   controller.emailController,
                   keyboardType: TextInputType.emailAddress,
                 ),
               ),
               const SizedBox(width: 12),
               Expanded(
                 child: _inputFields(
                   "Mobile",
                   controller.mobileController,
                   keyboardType: TextInputType.phone,
                 ),
               ),
             ],
           ),

           const SizedBox(height: 16),

           // Store Dropdown + Search Button
           Row(
             children: [
               Expanded(
                 flex: 2,
                 child: Obx(() {
                   if (controller.storeList.isEmpty) {
                     return TextFormField(
                       enabled: false,
                       decoration: InputDecoration(
                         hintText: "No verified stores available",
                         filled: true,
                         fillColor: Colors.grey.shade200,
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(10),
                         ),
                       ),
                     );
                   }

                   return DropdownButtonFormField<Stores>(
                     isExpanded: true,
                     value: controller.selectedStore.value,
                     items: controller.storeList.map((store) {
                       return DropdownMenuItem(
                         value: store,
                         child: Text("${store.id} - ${store.name}"),
                       );
                     }).toList(),
                     onChanged: (store) => controller.selectedStore.value = store,
                     decoration: InputDecoration(
                       hintText: "Select Store",
                       filled: true,
                       fillColor: Colors.white,
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                     ),
                   );
                 }),
               ),
               const SizedBox(width: 12),
               SizedBox(
                 height: 50,
                 child: ElevatedButton(
                   onPressed: () {
                     final store = controller.selectedStore.value;
                     if (store == null || store.id!.isEmpty) {
                       Get.snackbar("Error", "Please select a valid store");
                       return;
                     }
                     controller.searchUserId(store.id!);
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFF87CEFA),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(12),
                     ),
                   ),
                   child: const Icon(Icons.search),
                 ),
               ),
             ],
           ),

           const SizedBox(height: 16),

           // Searched Users List
           Expanded(
             child: Obx(() {
               if (controller.isLoading.value) {
                 return const Center(child: CircularProgressIndicator());
               }

               if (controller.searchedUsers.isEmpty) {
                 return const Center(child: Text("No users found"));
               }

               return ListView.builder(
                 itemCount: controller.searchedUsers.length,
                 itemBuilder: (context, index) {
                   final store = controller.searchedUsers[index];

                   // Find suUserId from storeAndStoreUser matching store id
                   final suUser = controller.storeAndStoreUsers.firstWhere(
                         (s) => s.storeId == store.id,
                     orElse: () => StoreAndStoreUser(
                       suUserId: '',
                       storeId: store.id,
                       updatedBy: '',
                       updatedDate: DateTime.now(), userIdStoreId: '',
                     ),
                   );

                   return Container(
                     margin: const EdgeInsets.symmetric(vertical: 8),
                     padding: const EdgeInsets.all(14),
                     decoration: _cardDecoration(),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           "Name: ${store.name}",
                           style: const TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 15,
                           ),
                         ),
                         Text("Email: ${store.ownerEmail}"),
                         Text("Mobile: ${store.ownerContact}"),
                         Text("Status: ${store.status}"),
                         Text("Registration Date: ${store.registrationDate}"),
                         const SizedBox(height: 12),
                         Row(
                           children: [
                             ElevatedButton(
                               onPressed: () {
                                 _openUpdateBottomSheet(
                                   storeInfo: store,
                                   suUserId: suUser.suUserId,
                                 );
                               },
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.blue,
                               ),
                               child: const Text("Update"),
                             ),
                             const SizedBox(width: 12),
                             ElevatedButton(
                               onPressed: () {
                                 // Activate logic here
                               },
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.red,
                               ),
                               child: const Text("Activate"),
                             ),
                           ],
                         ),
                       ],
                     ),
                   );
                 },
               );
             }),
           ),

         ],
       ),
     );
   }


   Widget _inputFields(
       String hint,
       TextEditingController controller, {
         TextInputType keyboardType = TextInputType.text,
       }) {
     return TextFormField(
       controller: controller,
       keyboardType: keyboardType,
       decoration: InputDecoration(
         hintText: hint,
         filled: true,
         fillColor: Colors.white,
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10),
         ),
       ),
     );
   }

// Helper Input Field
  Widget _inputField(String label, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 6),
        TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
          ),
        ),
      ],
    );
  }


  // ===============================
  // CARD DECORATION
  // ===============================
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  void _openUpdateBottomSheet({
    required StoreInfo storeInfo,
    required String suUserId,
  }) {
    final nameController = TextEditingController(text: storeInfo.name);

    Get.bottomSheet(
      SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Update User",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              _bottomSheetField(
                label: "Name",
                controller: nameController,
                enabled: true,
              ),
              const SizedBox(height: 12),
              _bottomSheetField(
                label: "Email",
                initialValue: storeInfo.ownerEmail,
                enabled: false,
              ),
              const SizedBox(height: 12),
              _bottomSheetField(
                label: "Mobile",
                initialValue: storeInfo.ownerContact,
                enabled: false,
              ),
              const SizedBox(height: 12),
              _bottomSheetField(
                label: "Status",
                initialValue: storeInfo.status,
                enabled: false,
              ),
              const SizedBox(height: 12),
              _bottomSheetField(
                label: "Registration Date",
                initialValue: storeInfo.registrationDate,
                enabled: false,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child:
                ElevatedButton(
                  onPressed: () {
                    final updatedName = nameController.text.trim();
                    if (updatedName.isEmpty) {
                      Get.snackbar("Error", "Name cannot be empty");
                      return;
                    }
                    controller.updateStoreUser(
                      suUserId: suUserId,
                      username: updatedName,
                    );
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }



  Widget _bottomSheetField({
    required String label,
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }


}
