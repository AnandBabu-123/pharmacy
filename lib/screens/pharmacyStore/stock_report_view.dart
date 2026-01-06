import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/sales_invoice_controller.dart';
import '../../model/user_pharmacy_model.dart';

class StockReportView extends StatelessWidget {
   StockReportView({super.key});
   final SalesInVoiceController controller = Get.put(SalesInVoiceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock Report"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF90EE90), Color(0xFF87CEFA)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Vendor Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Product Type",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownOnly(
                    label: "Stores",
                    controller: controller,
                  ),
                ),
                const SizedBox(width: 8),

                /// Search Button
                SizedBox(
                  height: 48,
                  child:
                  ElevatedButton.icon(
                    onPressed: () {
                      if (controller.selectedStore.value == null) {
                        Get.snackbar("Error", "Please select a store");
                        return;
                      }
                      controller.getPriceMange();
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
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.priceList.isEmpty) {
                  return const Center(child: Text("No data found"));
                }

                return ListView.builder(
                  itemCount: controller.priceList.length,
                  itemBuilder: (context, index) {
                    final item = controller.priceList[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [



                            SizedBox(height: 10,),
                            // Bal Pack Quantity	Bal Loose Quantity	MRP Pack	MRP Value
                            Column(
                              children: [

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.data.itemName ?? "-",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child:
                                      Text("Batch: ${item.data.batch ?? "-"}",style: TextStyle(
                                        fontSize: 11.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),


                                SizedBox(height: 4,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Store ID: ${item.data.storeId ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                    Expanded(
                                      child: Text("Manufacturer: ${item.data.manufacturer ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Item Code: ${item.data.itemCode ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                    Expanded(
                                      child: Text("Item Name: ${item.data.itemName ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Expiry Date: ${formatDate(item.data.expiryDate)}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                    Expanded(
                                      child: Text("Balance Qty: ${item.data.balQuantity ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Bal Pack Quantity: ${item.data.balPackQuantity ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                    Expanded(
                                      child: Text("Bal Loose Quantity: ${item.data.balLooseQuantity ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("MRP Pack: ${item.data.mrpPack ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                    Expanded(
                                      child: Text("MRP Value: ${item.data.mrpValue ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Rack: ${item.data.rack ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                    Expanded(
                                      child: Text("Online (Y/N): ${item.data.onlineYesNo ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Updated At: ${formatDate(item.data.updatedAt)}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                    Expanded(
                                      child: Text("Updated By: ${item.data.updatedBy ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Discount: ${item.data.discount ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                    Expanded(
                                      child: Text("Offer Qty: ${item.data.offerQty ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Min Order Qty: ${item.data.minOrderQty ?? "-"}",style: TextStyle(
                                        fontSize: 12.0, // specify the font size in double
                                        color: Colors.black, // optional: text color
                                      ),),
                                    ),
                                  ],
                                ),
                              ],
                            ),

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

   Widget _editableField({
     required String label,
     required TextEditingController controller,
     required bool enabled,
   }) {
     return Expanded(
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 4),
         child: TextFormField(
           controller: controller,
           readOnly: !enabled, // ✅ FIX
           keyboardType: TextInputType.number,
           decoration: InputDecoration(
             labelText: label,
             border: const OutlineInputBorder(),
             isDense: true,
             filled: !enabled,
             fillColor: !enabled ? Colors.grey.shade200 : null,
           ),
         ),
       ),
     );
   }
   String formatDate(DateTime? date) {
     if (date == null) return "-";
     return "${date.day.toString().padLeft(2, '0')}-"
         "${date.month.toString().padLeft(2, '0')}-"
         "${date.year}";
   }


   Widget _buildDropdownOnly({
     required String label,
     required SalesInVoiceController controller,
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
