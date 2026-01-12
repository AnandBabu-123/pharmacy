
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/sales_invoice_controller.dart';
import '../../model/user_pharmacy_model.dart';

class CustomerOrderView extends StatelessWidget {
  CustomerOrderView({super.key});

  final SalesInVoiceController controller =
  Get.put(SalesInVoiceController());

  final TextEditingController orderIdCtrl = TextEditingController();
  final TextEditingController customerNoCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController statusCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController fromDateCtrl = TextEditingController();
  final TextEditingController toDateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(title: const Text("Customer Order"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
              ),
            ),
          ),),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              _buildDropdownOnly(
                label: "Stores",
                controller: controller,
              ),

              const SizedBox(height: 16),
              _buildOrderIdSearchField("Order ID", orderIdCtrl),
              const SizedBox(height: 16),

              _twoFieldRow(
                _buildTextField("Location", locationCtrl),
                _buildTextField("Customer Number", customerNoCtrl),
              ),

              const SizedBox(height: 12),

              _twoFieldRow(
                _buildTextField("Customer Email", emailCtrl),
                _buildTextField("Order Status", statusCtrl),
              ),

              const SizedBox(height: 12),

              _twoFieldRow(
                _buildDateField("From Date", fromDateCtrl, context),
                _buildDateField("To Date", toDateCtrl, context),
              ),

              const Spacer(),

              /// 🔹 SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildOrderIdSearchField(
      String label,
      TextEditingController controller,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Search Order ID",
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            this.controller.searchCustomerOrder(value);
          },
        ),

        Obx(() {
          if (this.controller.isSearchingOrder.value) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: LinearProgressIndicator(),
            );
          }

          if (this.controller.orderSearchResults.isEmpty) {
            return const SizedBox();
          }

          return Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: this.controller.orderSearchResults.length,
              itemBuilder: (context, index) {
                final item =
                this.controller.orderSearchResults[index];
                return ListTile(
                  dense: true,
                  title: Text(item.orderId ?? "-"),
                  subtitle: Text(
                      "Customer: ${item.customerId ?? "-"}"),
                  onTap: () {
                    controller.text = item.orderId ?? "";
                    this.controller.orderSearchResults.clear();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }


  Widget _buildDropdownOnly({
    required String label,
    required SalesInVoiceController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
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

  Widget _twoFieldRow(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label,
      TextEditingController controller,
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          readOnly: true,          // 🔒 prevents keyboard
          enableInteractiveSelection: false, // 🔒 no copy/paste
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Select date",
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            FocusScope.of(context).unfocus(); // 🔒 ensure keyboard never opens

            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              controller.text =
              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
            }
          },
        ),
      ],
    );
  }

}

