
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:propertysearch/controllers/manual_stock_item_form.dart';
import 'package:propertysearch/controllers/sales_invoice_controller.dart';
import '../../model/user_pharmacy_model.dart';

class ManualStockView extends StatelessWidget {
  ManualStockView({super.key});

  final SalesInVoiceController controller = Get.put(SalesInVoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manual Stock"),
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
            /// STORE DROPDOWN
            _buildDropdownOnly(
              label: "Stores",
              controller: controller,
            ),

            const SizedBox(height: 8),

            /// 🔹 STORE DETAILS (EXPAND / COLLAPSE)
            Obx(() {
              final store = controller.selectedStore.value;

              if (store == null) return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔹 HEADER (CLICK TO TOGGLE)
                  GestureDetector(
                    onTap: () =>
                    controller.isStoreExpanded.value =
                    !controller.isStoreExpanded.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Store Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            controller.isStoreExpanded.value
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 🔹 DETAILS BODY
                  if (controller.isStoreExpanded.value)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _infoRow("Store ID", store.id),
                          _infoRow("Name", store.name),
                          _infoRow("Type", store.type),
                          _infoRow("Location", store.location),
                          _infoRow("District", store.district),
                          _infoRow("State", store.state),
                          _infoRow("PinCode", store.pincode),
                          _infoRow("Owner", store.owner),
                          _infoRow("Owner Contact", store.ownerContact),
                          _infoRow("GST Number", store.gstNumber),
                        ],
                      ),
                    ),
                ],
              );
            }),

            const SizedBox(height: 16),

            /// ITEMS LIST
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.manualItemForms.length,
                  itemBuilder: (context, index) {
                    return _itemContainer(
                      context,
                      controller,
                      controller.manualItemForms[index],
                      index,
                    );
                  },
                );
              }),
            ),

            /// ADD ITEM BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: controller.addItems,
                icon: const Icon(Icons.add),
                label: const Text("Add Item"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }

  /// 🔹 ITEM CARD
  Widget _itemContainer(
      BuildContext context,
      SalesInVoiceController controller,
      ManualStockItemForm form,
      int index,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          /// DELETE BUTTON (except first)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Item ${index + 1}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (index != 0)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeItems(index),
                ),
            ],
          ),

          const Divider(),

          /// FORM FIELDS
          ...form.fields.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: entry.key == "Item Name"
                        ? _itemAutoCompletes(controller, form, entry.value)
                        : TextFormField(
                      controller: entry.value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 12),

          /// 🔹 CANCEL & SAVE (PER CONTAINER)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  //   controller.clearItemForm(form);
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  //   controller.saveSingleItem(form, index);
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 AUTOCOMPLETE FIELD (FIXED)
  Widget _itemAutoCompletes(
      SalesInVoiceController controller,
      ManualStockItemForm form,
      TextEditingController textController,
      ) {
    return Autocomplete<String>(
      optionsBuilder: (value) {
        if (value.text.isEmpty) return const Iterable.empty();
        return controller.itemSearchLists.where(
              (e) => e.toLowerCase().contains(value.text.toLowerCase()),
        );
      },

      /// 🔹 when user selects from dropdown
      onSelected: (selection) {
        textController.text = selection;
        controller.searchItemByNames(selection, form);
      },

      fieldViewBuilder: (context, fieldController, focusNode, _) {
        fieldController.text = textController.text;

        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            hintText: "Search Item",
          ),

          /// 🔹 call API while typing
          onChanged: (v) {
            textController.text = v;
            controller.searchItemByNames(v, form);
          },
        );
      },
    );
  }



  /// 🔹 STORE DROPDOWN
  Widget _buildDropdownOnly({
    required String label,
    required SalesInVoiceController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Obx(() {
          return DropdownButtonFormField<Stores>(
            value: controller.selectedStore.value,
            hint: const Text("Select Store"),
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: controller.storesList
                .map(
                  (store) => DropdownMenuItem<Stores>(
                value: store,
                child: Text("${store.id} - ${store.name}"),
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

