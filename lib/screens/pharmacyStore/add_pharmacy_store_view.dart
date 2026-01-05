import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../controllers/add_pharmacy_controller.dart';

class AddPharmacyStoreView extends StatelessWidget {
   AddPharmacyStoreView({super.key});
   final pharmacyController = Get.put(AddPharmacyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rack Management"),
      ),
      body: Column(

      ),
    );
  }
}
