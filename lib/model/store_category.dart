class StoreCategory {
  String? storeCategoryId;
  String? storeCategoryName;

  StoreCategory({
    this.storeCategoryId,
    this.storeCategoryName,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      storeCategoryId: json['storeCategoryId'],
      storeCategoryName: json['storeCategoryName'],
    );
  }
}
