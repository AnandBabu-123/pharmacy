class PurchaseItem {
  String? invoiceNo;
  DateTime? date;
  String? suppName;
  String? storeId;
  String? userIdStoreId;

  PurchaseItem({
    this.invoiceNo,
    this.date,
    this.suppName,
    this.storeId,
    this.userIdStoreId,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      invoiceNo: json['invoiceNo'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      suppName: json['suppName'],
      storeId: json['storeId'],
      userIdStoreId: json['userIdStoreId'],
    );
  }
}
