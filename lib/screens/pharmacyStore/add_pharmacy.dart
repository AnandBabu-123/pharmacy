import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propertysearch/controllers/add_pharmacy_controller.dart';

import '../../controllers/dashbaoard_controller.dart';
import '../../model/store_business_type.dart';
import '../../model/store_category.dart';
import '../../model/user_pharmacy_model.dart' show Stores;
import '../bottom_navigation_screens/app_drawer.dart';



class AddPharmacy extends StatelessWidget {
  AddPharmacy({super.key});


  final pharmacyController = Get.put(AddPharmacyController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,



      appBar: AppBar(
        title: const Text(
          "Pharmacy Management",
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


      ),

      /// 🌿 BODY BACKGROUND COLOR
      body: Container(
        color: const Color(0xFFF1F8E9),
        child: Obx(() {
          if (pharmacyController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pharmacyController.pharmacyList.isEmpty) {
            return const Center(
              child: Text(
                "No Stores Found",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: pharmacyController.pharmacyList.length,
            itemBuilder: (context, index) {
              final store = pharmacyController.pharmacyList[index];

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
                        "Name : ${store.itemName ?? ""}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      _buildRow("Location", store.storeId),
                      _buildRow("Owner", store.brand),
                      _buildRow("Contact", store.itemCategory),
                      _buildRow("PinCode", store.itemCode),
                      _buildRow("District", store.itemSubCategory),
                      _buildRow("State", store.manufacturer),
                      _buildRow("Date", store.narcotic),
                      _buildRow("Role", store.itemCode ?? "-"),
                    ],
                  ),
                ),
              );

            },
          );
        }),
      ),

      /// ➕ FAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF90EE90),
        onPressed: () {
          _openAddStoreBottomSheet(context);
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Store"),
      ),
    );
  }

  void _openAddStoreBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for full height with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView( // ✅ Make it scrollable when keyboard opens
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Store & Item Code
                _buildDropdownWithTextField(
                  leftLabel: "Stores",
                  rightLabel: "Item Code",
                  controller: pharmacyController,
                  rightController: pharmacyController.itemCode,
                ),

                const SizedBox(height: 12),

                /// 🔹 Item Name & Category
                _buildTwoFieldRow(
                  leftLabel: "Item Name",
                  leftHint: "",
                  leftController: pharmacyController.itemName,
                  rightLabel: "Item Category",
                  rightHint: "",
                  rightController: pharmacyController.itemCategory,
                ),

                const SizedBox(height: 12),

                /// 🔹 Sub-Category & Manufacturer
                _buildTwoFieldRow(
                  leftLabel: "Item Sub-Category",
                  leftHint: "",
                  leftController: pharmacyController.itemSubCategory,
                  rightLabel: "Manufacturer",
                  rightHint: "",
                  rightController: pharmacyController.manufacturer,
                ),

                const SizedBox(height: 12),

                /// 🔹 Brand & GST
                _buildTwoFieldRow(
                  leftLabel: "Brand",
                  leftHint: "",
                  leftController: pharmacyController.brand,
                  rightLabel: "GST",
                  rightHint: "",
                  rightController: pharmacyController.gstNumber,
                ),

                const SizedBox(height: 12),

                /// 🔹 HSN Code & Is Scheduled
                _buildTextAndYesNoDropdown(
                  leftLabel: "HSN Code",
                  leftController: pharmacyController.hsnCode,
                  rightLabel: "Is Scheduled",
                  selectedValue: pharmacyController.isScheduled,
                ),

                const SizedBox(height: 12),

                /// 🔹 Scheduled Category & Is Narcotic
                _buildTextAndYesNoDropdown(
                  leftLabel: "Scheduled Category",
                  leftController: pharmacyController.scheduledCategory,
                  rightLabel: "Is Narcotic",
                  selectedValue: pharmacyController.isNarcotic,
                ),

                const SizedBox(height: 20),

                /// 🔹 Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => pharmacyController.addPharmacyUser(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF90EE90),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
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
            width: 90, // controls left alignment
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
  Widget _buildDropdownWithTextField({
    required String leftLabel,
    required String rightLabel,
    required AddPharmacyController controller,
    required TextEditingController rightController,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          /// 🔹 LEFT - DROPDOWN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leftLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),

                Obx(() {
                  return DropdownButtonFormField<Stores>(
                    value: controller.selectedStore.value,
                    isExpanded: true,
                    hint: const Text("Select Store"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: controller.storesList.map((store) {
                      return DropdownMenuItem<Stores>(
                        value: store,
                        child: Text(
                          "${store.id ?? ""} - ${store.name ?? ""}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedStore.value = value;
                    },
                  );
                }),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// 🔹 RIGHT - TEXTFIELD
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rightLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: rightController,
                  decoration: const InputDecoration(
                    hintText: "Enter item code",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextAndYesNoDropdown({
    required String leftLabel,
    required TextEditingController leftController,
    required String rightLabel,
    required RxnString selectedValue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          /// 🔹 LEFT - TEXTFIELD
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leftLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: leftController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// 🔹 RIGHT - YES / NO DROPDOWN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rightLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: selectedValue.value,
                    hint: const Text("Select"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: "Y", child: Text("Yes")),
                      DropdownMenuItem(value: "N", child: Text("No")),
                    ],
                    onChanged: (val) {
                      selectedValue.value = val;
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTwoFieldRow({
    required String leftLabel,
    required String leftHint,
    required TextEditingController leftController,
    required String rightLabel,
    required String rightHint,
    required TextEditingController rightController,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          /// LEFT FIELD
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leftLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: leftController,
                  decoration: InputDecoration(
                    hintText: leftHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// RIGHT FIELD
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rightLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: rightController,
                  decoration: InputDecoration(
                    hintText: rightHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}
