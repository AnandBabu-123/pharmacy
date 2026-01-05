import 'package:flutter/cupertino.dart';

class SalesItemForm {
  final itemName = TextEditingController();
  final itemCode = TextEditingController();
  final manufacturer = TextEditingController();
  final brand = TextEditingController();
  final batch = TextEditingController();
  final expiryDate = TextEditingController();
  final mrp = TextEditingController();
  final gst = TextEditingController();
  final hsn = TextEditingController();
  final purchaseRate = TextEditingController();
  final discount =TextEditingController();
  final afterDiscount =TextEditingController();
  final IGST =TextEditingController();
  final SGST =TextEditingController();
  final CGST =TextEditingController();
  final IGSTAmount =TextEditingController();
  final SGSTAmount =TextEditingController();
  final CGSTAmount =TextEditingController();
  final FinalSalePrice =TextEditingController();
  final TotalPurchasePrice =TextEditingController();
  final ProfitOrLoss =TextEditingController();
  final BoxQuantity =TextEditingController();



  /// 🔹 LABEL → CONTROLLER MAP
  late final Map<String, TextEditingController> fields = {
    "Item Name": itemName,
    "Item Code": itemCode,
    "Manufacturer": manufacturer,
    "Brand": brand,
    "Batch No": batch,
    "Expiry Date": expiryDate,
    "MRP": mrp,
    "GST": gst,
    "HSN": hsn,
    "Purchase Rate": purchaseRate,
    "Discount": discount,
    "After Discount": afterDiscount,
    "IGST %": IGST,
    "SGST %": SGST,
    "CGST %": CGST,
    "IGST Amount": IGSTAmount,
    "SGST Amount":SGSTAmount,
    "CGST Amount": CGSTAmount,
    "Final Sale Price": FinalSalePrice,
    "Total Purchase Price": TotalPurchasePrice,
    "Profit Or Loss": ProfitOrLoss,
    "Box Quantity": BoxQuantity,


  };
}
