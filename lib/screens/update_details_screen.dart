import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/update_details_controller.dart';
import '../model/store_category.dart';
import '../model/storelist_response.dart';


class UpdateDetailsScreen extends StatelessWidget {
  const UpdateDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateDetailsController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Update Store Details"),
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
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Store", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Obx(() {
                    return DropdownButtonFormField<StoreItem>(
                      value: controller.selectedStore.value,
                      items: controller.stores.map((store) {
                        return DropdownMenuItem(
                          value: store,
                          child: Text("${store.id} - ${store.name}"),
                        );
                      }).toList(),
                      onChanged: controller.onStoreSelected,
                      decoration: _inputDecoration("Select Store"),
                    );
                  }),
                  const SizedBox(height: 12),

                  /// STATUS CHIP
                  Obx(() {
                    final status = controller.selectedStore.value?.status;
                    if (status == null) return const SizedBox.shrink();
                    return Row(
                      children: [
                        const Text("Status : "),
                        Chip(
                          label: Text(status),
                          backgroundColor: status == "ACTIVE"
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: status == "ACTIVE" ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 12),

                  /// STORE CATEGORY
                  const Text("Store Category", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Obx(() {
                    return DropdownButtonFormField<StoreCategory>(
                      value: controller.selectedStoreCategory.value,
                      items: controller.storeCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.storeCategoryName ?? ""),
                        );
                      }).toList(),
                      onChanged: controller.isEditable.value
                          ? (v) => controller.selectedStoreCategory.value = v
                          : null,
                      decoration: _inputDecoration("Select Store Category"),
                    );
                  }),
                  const SizedBox(height: 12),

                  /// STORE NAME & GST
                  Obx(() => _twoFieldRow(
                    "Store Name",
                    controller.storeName,
                    "GST",
                    controller.gstController,
                    readOnly: !controller.isEditable.value,
                  )),
                  const SizedBox(height: 12),

                  /// PINCODE & TOWN
                  Obx(() => _twoFieldRow(
                    "Pincode",
                    controller.pincodeController,
                    "Town",
                    controller.townController,
                    readOnly: !controller.isEditable.value,
                  )),
                  const SizedBox(height: 12),

                  /// STATE & DISTRICT (READONLY)
                  _twoFieldRow(
                    "State",
                    controller.stateController,
                    "District",
                    controller.districtController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),

                  /// OWNER & CONTACT (READONLY)
                  _twoFieldRow(
                    "Owner",
                    controller.userNameController,
                    "Owner Contact",
                    controller.mobileNumberController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 12),

                  const Text("Email"),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller.emailController,
                    readOnly: true,
                    decoration: _inputDecoration("Email"),
                  ),
                  const SizedBox(height: 20),

                  /// SAVE BUTTON
                  Obx(() => ElevatedButton(
                    onPressed: controller.isEditable.value
                        ? () => controller.updateStoreDetails()
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color(0xFF90EE90),
                    ),
                    child: const Text("Save"),
                  )),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  static Widget _twoFieldRow(
      String leftLabel,
      TextEditingController leftController,
      String rightLabel,
      TextEditingController rightController, {
        bool readOnly = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(leftLabel)),
              const SizedBox(width: 12),
              Expanded(child: Text(rightLabel)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: leftController,
                  readOnly: readOnly,
                  decoration: _inputDecoration(leftLabel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: rightController,
                  readOnly: readOnly,
                  decoration: _inputDecoration(rightLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildFileUploadField({
    required String label,
    required Rxn<File> selectedFile,
    required Function(File) onFileSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Obx(() {
          return GestureDetector(
            onTap: () async {
              // Open file picker for any document type
              final result = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.any, // allows any file type
              );

              if (result != null && result.files.isNotEmpty) {
                final filePath = result.files.first.path;
                if (filePath != null) {
                  final file = File(filePath);
                  onFileSelected(file); // update the Rxn<File>
                }
              }
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                selectedFile.value?.path.split("/").last ?? "Select file",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );
        }),
      ],
    );
  }

}


