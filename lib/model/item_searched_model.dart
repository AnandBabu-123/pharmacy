class ItemSearchModel {
  final String itemName;
  final String? itemCode;
  final String? manufacturer;
  final String? brand;
  final int? gst;
  final String? hsnGroup;

  ItemSearchModel({
    required this.itemName,
    this.itemCode,
    this.manufacturer,
    this.brand,
    this.gst,
    this.hsnGroup,
  });

  factory ItemSearchModel.fromJson(Map<String, dynamic> json) {
    return ItemSearchModel(
      itemName: json['itemName'],
      itemCode: json['itemCode'],
      manufacturer: json['manufacturer'],
      brand: json['brand'],
      gst: json['gst'],
      hsnGroup: json['hsnGroup'],
    );
  }
}
