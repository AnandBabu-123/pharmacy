import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controllers/update_details_controller.dart';
import '../model/storelist_response.dart';
import 'package:file_picker/file_picker.dart';

class UpdateStoreDocumentsView extends StatelessWidget {
  UpdateStoreDocumentsView({super.key});

  final UpdateDetailsController controller =
  Get.put(UpdateDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Store Documents"),
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 SELECT STORE
            const Text(
              "Select Store",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            Obx(() {
              final inactiveStores = controller.stores
                  .where((store) => store.status == "INACTIVE")
                  .toList();

              return DropdownButtonFormField<StoreItem>(
                value: controller.selectedStore.value,
                items: inactiveStores.map((store) {
                  return DropdownMenuItem<StoreItem>(
                    value: store,
                    child: Text("${store.id} - ${store.name}"),
                  );
                }).toList(),
                onChanged: (store) =>
                controller.selectedStore.value = store,
                decoration: _inputDecoration("Select Store"),
              );
            }),

            const SizedBox(height: 20),

            /// 🔹 STORE FRONT IMAGE
            _buildFileUploadField(
              label: "Store Front Image *",
              selectedFile: controller.storeFrontImage,
              onFileSelected: (file) =>
              controller.storeFrontImage.value = file,
            ),

            const SizedBox(height: 12),

            /// 🔹 TRADE LICENSE
            _buildFileUploadField(
              label: "Trade License *",
              selectedFile: controller.tradeLicense,
              onFileSelected: (file) =>
              controller.tradeLicense.value = file,
            ),

            const SizedBox(height: 12),

            /// 🔹 DRUG LICENSE
            _buildFileUploadField(
              label: "Drug License *",
              selectedFile: controller.drugLicense,
              onFileSelected: (file) =>
              controller.drugLicense.value = file,
            ),

            const SizedBox(height: 20),

            /// 🔹 UPLOAD BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.uploadDocuments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF90EE90),
                ),
                child: const Text(
                  "Upload Documents",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 COMMON INPUT DECORATION
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  /// 🔹 FILE UPLOAD FIELD
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
