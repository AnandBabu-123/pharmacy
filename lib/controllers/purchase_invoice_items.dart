import 'package:flutter/cupertino.dart';

class PurchaseInvoiceItems {
  final itemName = TextEditingController();
  final itemCode = TextEditingController();
  final manufacturer = TextEditingController();
  final brand = TextEditingController();
  final batchNo = TextEditingController();
  final rack = TextEditingController();
  final batch = TextEditingController();
  final expiryDate = TextEditingController();
  final mrpPurchase = TextEditingController();
  final rateDiscount = TextEditingController();
  final afterDiscount = TextEditingController();
  final hSNCode = TextEditingController();
  final gSTCode = TextEditingController();
  final igstCode = TextEditingController();
  final sGSTCode = TextEditingController();
  final cgstCode = TextEditingController();
  final IGSTAmount = TextEditingController();
  final SGSTAmount = TextEditingController();
  final CGSTAmount = TextEditingController();
  final looseQty = TextEditingController();
  final boxQty = TextEditingController();
  final packQty = TextEditingController();

  late final Map<String, TextEditingController> fields = {
    "Item Name": itemName,
    "Item Code": itemCode,
    "Manufacturer": manufacturer,
    "Brand": brand,
    "Batch No": batchNo,
    "Rack": rack,
    "Batch": batch,
    "Expiry Date": expiryDate,
    "MRP Purchase": mrpPurchase,
    "Rate	Discount": rateDiscount,
    "After Discount": afterDiscount,
    "HSN Code": hSNCode,
    "GST Code": gSTCode,
    "IGST %": igstCode,
    "SGST %": sGSTCode,
    "CGST %": cgstCode,
    "IGST Amount": IGSTAmount,
    "SGST Amount": SGSTAmount,
    "CGST Amount": CGSTAmount,
    "Loose Qty": looseQty,
    "Box Qty": boxQty,
    "Pack Qty": packQty,

  };


  void clear() {
    for (final c in fields.values) {
      c.clear();
    }
  }
}
