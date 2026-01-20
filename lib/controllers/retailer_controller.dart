import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../data/api_calls.dart';
import '../data/shared_preferences_data.dart';
import '../model/retailer_purchase_model.dart';
import '../model/retailers_dropdown_model.dart';

class RetailerPurchaseController extends GetxController {
  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();
  /// 🔹 Controllers
  final locationCtrl = TextEditingController();

  /// 🔹 Dropdown values
  var businessTypes = <String>[].obs;
  var selectedBusinessType = RxnString();

  var storeList = <RetailerStoreDropdown>[].obs;
  var selectedStore = Rxn<RetailerStoreDropdown>();

  var isLoadingStore = false.obs;
  /// Result list
  RxList<RetailerStockItem> stockResults = <RetailerStockItem>[].obs;


  final ScrollController scrollController = ScrollController();


  final TextEditingController medicineCtrl = TextEditingController();
  final TextEditingController manufacturerCtrl = TextEditingController();



  /// Pagination
  var currentPage = 0.obs;
  var pageSize = 10.obs;
  var totalPages = 1.obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    loadBusinessTypes();
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore.value) {
        loadMoreStock();
      }
    });
  }
  void loadMoreStock() {
    if (currentPage.value >= totalPages.value - 1) return;

    searchMedicine(
      page: currentPage.value + 1,
      isLoadMore: true,
    );
  }


  Future<void> searchMedicine({
    int page = 0,
    bool isLoadMore = false,
  }) async {
    /// 🔹 SAFETY CHECK
    if (selectedStore.value == null) {
      debugPrint(" selectedStore is null");
      return;
    }

    try {
      /// 🔹 LOADING HANDLING
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        stockResults.clear();
        currentPage.value = 0;
      }

      await apiCalls.initializeDio();
      final String userId = await prefs.getUserId();

      /// 🔹 BUILD URL
      final String url =
          "http://3.111.125.81/search-medicine-by-distributor"
          "?medicineName=${medicineCtrl.text.trim()}"
          "&mfName=${manufacturerCtrl.text.trim()}"
          "&userId=${userId}"
          "&storeId=AS"
          "&location=${locationCtrl.text.trim()}"
          "&page=$page"
          "&size=${pageSize.value}";

      debugPrint("🌐 API URL:");
      debugPrint(url);
      // "&storeId=${selectedStore.value!.id}"
      /// 🔹 API CALL
      final res = await apiCalls.getMethod(url);

      debugPrint(" Status Code: ${res.statusCode}");
      debugPrint(" Response Type: ${res.data.runtimeType}");

      if (res.statusCode == 200 && res.data != null) {
        /// 🔹 HANDLE STRING / MAP RESPONSE
        final Map<String, dynamic> json =
        res.data is String ? jsonDecode(res.data) : res.data;

        debugPrint(" Raw JSON: ${jsonEncode(json)}");

        /// 🔹 PARSE MODEL
        final RetailerPurchaseModel model =
        RetailerPurchaseModel.fromJson(json);

        debugPrint(" Model Status: ${model.status}");
        debugPrint(" Message: ${model.message}");
        debugPrint(" Current Page: ${model.currentPage}");
        debugPrint(" Total Pages: ${model.totalPages}");
        debugPrint("Data Length: ${model.data?.length}");

        /// 🔹 EXTRACT STOCK ITEMS SAFELY
        final List<RetailerStockItem> newItems =
            model.data
                ?.expand(
                  (e) => e.stock ?? <RetailerStockItem>[],
            )
                .toList() ??
                <RetailerStockItem>[];

        debugPrint(" New stock items fetched: ${newItems.length}");

        /// 🔹 ADD TO LIST
        stockResults.addAll(newItems);

        /// 🔹 UPDATE PAGINATION
        currentPage.value = model.currentPage ?? page;
        totalPages.value = model.totalPages ?? 1;

        debugPrint(" Total items in list: ${stockResults.length}");
        debugPrint(
          " Page ${currentPage.value + 1} of ${totalPages.value}",
        );
      }
    } catch (e, stack) {
      debugPrint(" Search Error: $e");
      debugPrint(" StackTrace: $stack");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }


  /// 🔹 Load business types (DT / RT)
  Future<void> loadBusinessTypes() async {
    try {
      await apiCalls.initializeDio();
      final res = await apiCalls.getMethod(
        "http://3.111.125.81/store/distinct-store-business-types",
      );

      if (res.statusCode == 200 && res.data != null) {
        businessTypes.value = List<String>.from(res.data);
      }
    } catch (e) {
      debugPrint(" BusinessType Error: $e");
    }
  }

  /// 🔹 Load stores based on business type + location
  Future<void> loadStores() async {
    if (selectedBusinessType.value == null ||
        locationCtrl.text.isEmpty) {
      return;
    }

    try {
      isLoadingStore.value = true;
      await apiCalls.initializeDio();

      final url =
          "http://3.111.125.81/store/search-supplier-by-store-owner"
          "?storeBusinessType=${selectedBusinessType.value}"
          "&location=${locationCtrl.text}";

      final res = await apiCalls.getMethod(url);

      if (res.statusCode == 200 && res.data != null) {
        final List list = res.data;

        storeList.value = list
            .map((e) => RetailerStoreDropdown.fromJson(e))
            .where((e) => e.storeVerifiedStatus == true)
            .toList();
      }
    } catch (e) {
      debugPrint(" Store API Error: $e");
    } finally {
      isLoadingStore.value = false;
    }
  }


  /// 🔹 Label helper
  String businessTypeLabel(String code) {
    if (code == "DT") return "Distributor";
    if (code == "RT") return "Retailer";
    return code;
  }

}
