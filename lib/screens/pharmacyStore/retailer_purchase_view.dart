import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/retailer_controller.dart';
import '../../model/retailers_dropdown_model.dart';

class RetailerPurchaseView extends StatelessWidget {
  RetailerPurchaseView({super.key});

  final controller = Get.put(RetailerPurchaseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retailer PurChase"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// 🔹 ROW 1
            Row(
              children: [

                /// 📍 Location
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return controller.locationList;
                        }
                        return controller.locationList.where(
                              (option) => option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()),
                        );
                      },
                      onSelected: (selection) {
                        controller.locationCtrl.text = selection;
                      },
                      fieldViewBuilder:
                          (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onTap: () async {
                            // fetch once
                            if (controller.locationList.isEmpty) {
                              await controller.fetchLocations();
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: "Location",
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),


                const SizedBox(width: 8),

                /// 🏢 Business Type Dropdown
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: Obx(() {
                      return DropdownButtonFormField<String>(
                        value: controller.selectedBusinessType.value,
                        items: controller.businessTypes.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              controller.businessTypeLabel(e),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          controller.selectedBusinessType.value = val;
                          controller.selectedStore.value = null;
                          controller.storeList.clear();
                          controller.loadStores();
                        },
                        decoration: const InputDecoration(
                          labelText: "Business Type",
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        isExpanded: true,
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 8),

                /// 🏪 Store Dropdown
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: Obx(() {
                      final enabled =
                          controller.selectedBusinessType.value != null &&
                              controller.locationCtrl.text.isNotEmpty;

                      return DropdownButtonFormField<RetailerStoreDropdown>(
                        value: controller.selectedStore.value,
                        items: controller.storeList.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.displayName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: enabled
                            ? (val) => controller.selectedStore.value = val
                            : null,
                        decoration: const InputDecoration(
                          labelText: "Store Name",
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        isExpanded: true,
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// 🔹 ROW 2 – Medicine Search
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: controller.medicineCtrl,
                      decoration: const InputDecoration(
                        labelText: "Medicine Name",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: controller.manufacturerCtrl,
                      decoration: const InputDecoration(
                        labelText: "Manufacturer",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.searchMedicine();
                    },
                    icon: const Icon(Icons.search),
                    label: const Text("Search"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.stockResults.isEmpty) {
                  return const Center(child: Text("No Stock Found"));
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.stockResults.length +
                      (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= controller.stockResults.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = controller.stockResults[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.medicineName ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _row("Manufacturer", item.mfName),
                            _row("MRP", item.mrp?.toString()),
                            _row("Batch", item.batch),
                            _row("Expiry", item.expiryDate?.split('T').first),
                            _row("Discount", item.discount?.toString()),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

          ],
        ),
      ),
    );
  }
  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : "-",
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }


}
