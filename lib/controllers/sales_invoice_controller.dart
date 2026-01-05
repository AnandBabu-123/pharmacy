
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:propertysearch/controllers/sales_item_form.dart';
import 'package:propertysearch/model/price_manage_model.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/item_stock.dart';
import '../model/user_pharmacy_model.dart';
import '../screens/pharmacyStore/editable_price_item.dart';

class SalesInVoiceController extends GetxController{

  final ApiCalls apiCalls = ApiCalls();
  var storesList = <Stores>[].obs;
  var selectedStore = Rxn<Stores>();
  final RxBool isLoading = false.obs;


  final RxList<EditablePriceItem> priceList =
      <EditablePriceItem>[].obs;



  final SharedPreferencesData prefs = SharedPreferencesData();
  var customerNameController = TextEditingController();
  var customerPhoneController = TextEditingController();

  var itemForms = <SalesItemForm>[].obs;
  var itemSearchList = <String>[].obs;
  late Dio dio;

  void addItem() {
    itemForms.add(SalesItemForm());
  }

  void removeItem(int index) {
    if (index != 0) {
      itemForms.removeAt(index);
    }
  }


  @override
  void onReady() {
    super.onReady();
    getPharmacyDropDown();
    searchItem();
    addItem();

  }

  Future<void> submitOffers() async {
    final selectedItems =
    priceList.where((e) => e.isSelected.value).toList();

    if (selectedItems.isEmpty) {
      Get.snackbar("Error", "Please select at least one item");
      return;
    }

    final store = selectedStore.value;
    if (store == null) {
      Get.snackbar("Error", "Store not selected");
      return;
    }

    try {
      isLoading.value = true;

      /// 🔹 GET ACCESS TOKEN
      String accessToken = await prefs.getAccessToken();
      debugPrint("➡ ACCESS TOKEN: $accessToken");

      /// 🔹 CORRECT JSON BODY (NO OUTER ARRAY )
      final Map<String, dynamic> body = {
        "storeId": store.id,
        "userId": store.userId,
        "userIdStoreId": store.userIdStoreId,
        "itemOffers": selectedItems.map((item) {
          return {
            "userIdStoreId_itemCode": item.data.userIdStoreIdItemCode,
            "batchNumber": item.data.batch,
            "discount": int.tryParse(item.discountCtrl.text) ?? 0,
            "offerQty": int.tryParse(item.offerQtyCtrl.text) ?? 0,
            "minOrderQty": int.tryParse(item.minOrderQtyCtrl.text) ?? 0,
          };
        }).toList(),
      };

      debugPrint("➡ REQUEST BODY: $body");

      /// 🔹 DIO INSTANCE
      final dio = Dio(
        BaseOptions(
          baseUrl: "http://3.111.125.81/",
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      /// 🔹 POST API (MATCHES POSTMAN)
      final response = await dio.post(
        "api/item-offer/add",
        data: body,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Item offers saved successfully");

        /// Clear selection after success
        for (var item in priceList) {
          item.isSelected.value = false;
        }
      } else {
        Get.snackbar("Error", "Something went wrong");
      }
    } catch (e) {
      debugPrint("Submit Offer Error: $e");
      Get.snackbar("Error", "Failed to submit offers");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> getPriceMange() async {
    try {
      isLoading.value = true;
      await apiCalls.initializeDio();
      final store = selectedStore.value;
      if (store == null) return;

      await apiCalls.initializeDio();

      final response = await apiCalls.getMethod(
        "${RouteUrls.getPriceMange}"
            "?storeId=${store.id}"
            "&userIdStoreId=${store.userIdStoreId}"
            "&userId=${store.userId}",
      );
      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final model = PriceManageModel.fromJson(json);

        /// 🔥 CONVERT DataItem → EditablePriceItem
        priceList.value = model.data
            ?.map((e) => EditablePriceItem(e))
            .toList() ??
            [];
      }
    } catch (e) {
      debugPrint("PriceManage Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> getPriceMange() async {
  //   try {
  //     final store = selectedStore.value;
  //     if (store == null) return;
  //
  //
  //
  //     await apiCalls.initializeDio();
  //
  //     final response = await apiCalls.getMethod(
  //       "${RouteUrls.getPriceMange}"
  //           "?storeId=${store.id}"
  //           "&userIdStoreId=${store.userIdStoreId}"
  //           "&userId=${store.userId}",
  //     );
  //
  //     if (response.statusCode == 200 && response.data != null) {
  //       final json = response.data is String
  //           ? jsonDecode(response.data)
  //           : response.data;
  //
  //       final model = PriceManageModel.fromJson(json);
  //
  //       priceList.value = model.data ?? [];
  //     }
  //   } catch (e, s) {
  //     debugPrint("Price Manage Error: $e");
  //     debugPrint("$s");
  //   } finally {
  //
  //   }
  // }


  Future<void> searchItem() async {
    try {
      await apiCalls.initializeDio();

      final userId = await prefs.getUserId();
      if (userId.isEmpty) return;

      final response =
      await apiCalls.getMethod(RouteUrls.searchInVoiceItem);

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        itemSearchList.value = List<String>.from(json);
      }
    } catch (e, s) {
      debugPrint("Item Search Error: $e");
      debugPrint("$s");
    }
  }

  /// 🔹 Call API using selected item name
  Future<void> searchItemByName(
      String itemName,
      SalesItemForm form,

      ) async
  {
    try {
      await apiCalls.initializeDio();


      final response = await apiCalls.getMethod(
        "${RouteUrls.searchInVoiceByName}=$itemName",
      );

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final List list = json['data'] ?? [];
        if (list.isEmpty) return;

        final item = ItemStock.fromJson(list.first);

        ///  AUTO-FILL FIELDS
        form.itemCode.text = item.itemCode ?? "";
        form.manufacturer.text = item.manufacturer ?? "";
        form.brand.text = item.brand ?? "";
        form.batch.text = item.batch ?? "";
        form.mrp.text = item.mRP?.toString() ?? "";
        form.gst.text = item.gst?.toString() ?? "";
        form.hsn.text = item.hsnGroup ?? "";
        form.purchaseRate.text = item.purRate?.toString() ?? "";

        if (item.expiryDate != null) {
          form.expiryDate.text =
              item.expiryDate!.toIso8601String().split('T').first;
        }
      }
    } catch (e, s) {
      debugPrint(" Item Search Error: $e");
      debugPrint("$s");
    }
  }



  Future<void> getPharmacyDropDown() async {
    try {
      await apiCalls.initializeDio();

      final userId = await prefs.getUserId();
      if (userId.isEmpty) return;

      final response = await apiCalls.getMethod(
        "${RouteUrls.addpharmacyUser}?userId=$userId",
      );


      if (response.statusCode == 200 && response.data != null) {
        final json = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        final model = UserPharmacyModel.fromJson(json);

        ///  FILTER VERIFIED STORES ONLY
        storesList.assignAll(
          model.stores
              ?.where(
                (e) =>
            e.storeVerifiedStatus == "true" &&
                e.type == "PH",
          )
              .toList() ??
              [],
        );

      }
    } catch (e, s) {
      print("❌ Dropdown API error: $e");
      print("$s");
    }
  }
}