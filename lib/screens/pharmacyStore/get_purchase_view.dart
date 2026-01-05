import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/add_pharmacy_controller.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../model/user_pharmacy_model.dart';



class PurchaseReport extends StatelessWidget {
  PurchaseReport({super.key});

  final AddPharmacyController pharmacyController =
  Get.put(AddPharmacyController());

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController invoiceController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text =
      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchase Report"),
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
                Expanded(
                  child: _dateField(
                    context,
                    label: "Date From",
                    controller: fromDateController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _dateField(
                    context,
                    label: "Date To",
                    controller: toDateController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: invoiceController,
                    decoration: const InputDecoration(
                      labelText: "Invoice Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),


            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: supplierController,
                        decoration: const InputDecoration(
                          labelText: "Supplier Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                /// Store Dropdown
                Expanded(
                  child: _buildDropdownOnly(
                    label: "Stores",
                    controller: pharmacyController,
                  ),
                ),
                const SizedBox(width: 8),

                /// Search Button
                SizedBox(
                  height: 48,
                  child:
                  ElevatedButton.icon(
                    onPressed: () {
                      final selectedStore =
                          pharmacyController.selectedStore.value;

                      if (selectedStore?.userIdStoreId == null) {
                        Get.snackbar("Error", "Please select a store");
                        return;
                      }

                      pharmacyController.getPurChaseReport(
                        selectedStore!.userIdStoreId!,
                      );
                    },
                    icon: const Icon(Icons.search),
                    label: const Text("Search"),
                  ),

                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (pharmacyController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pharmacyController.purchaseList.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }

                return ListView.builder(
                  itemCount: pharmacyController.purchaseList.length,
                  itemBuilder: (context, index) {
                    final item = pharmacyController.purchaseList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _row("Invoice No", item.invoiceNo ?? "-"),
                          _row("Date",
                              item.date?.toString().split(' ').first ?? "-"),
                          _row("Supplier", item.suppName ?? "-"),
                          _row("Store ID", item.storeId ?? "-"),
                        ],
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

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$title :",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// 🔹 Date Field Widget
  Widget _dateField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
      }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context, controller),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// 🔹 Store Dropdown
  Widget _buildDropdownOnly({
    required String label,
    required AddPharmacyController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Obx(() {
          return DropdownButtonFormField<Stores>(
            value: controller.selectedStore.value,
            hint: const Text("Select Store"),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: controller.storesList
                .map(
                  (store) => DropdownMenuItem<Stores>(
                value: store,
                child: Text(
                  "${store.id ?? ""} - ${store.name ?? ""}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .toList(),
            onChanged: (value) =>
            controller.selectedStore.value = value,
          );
        }),
      ],
    );
  }
}

