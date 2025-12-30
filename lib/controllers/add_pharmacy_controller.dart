
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/pharmacy_storemodel.dart';

class AddPharmacyController extends GetxController{

  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();
  var isLoading = false.obs;

  var pharmacyList = <ItemCodeMasters>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStores();
  }

  Future<void> fetchStores() async {
    try {
      debugPrint("📦 Dashboard fetchStores started");

      /// Init Dio (adds baseUrl, headers, token etc.)
      await apiCalls.initializeDio();

      final String userId = await prefs.getUserId();
      final String accessToken = await prefs.getAccessToken();

      debugPrint("👤 UserId: $userId");
      debugPrint("🔐 AccessToken: $accessToken");

      if (userId.isEmpty) {
        debugPrint("❌ UserId is missing, API not called");
        return;
      }

      /// API CALL
      final response = await apiCalls.getMethod(
        "${RouteUrls.getPharmacyStore}?userId=$userId",
      );

      debugPrint("✅ Status Code: ${response.statusCode}");
      debugPrint("📥 Response Data: ${response.data}");

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data is Map<String, dynamic>) {

        final model = PharmacyStoreModel.fromJson(response.data);

        /// Assign safely
        pharmacyList.assignAll(model.itemCodeMasters ?? []);

        debugPrint("📊 Stores count: ${pharmacyList.length}");
      } else {
        debugPrint("⚠️ API failed or invalid response format");
      }
    } catch (e, stack) {
      debugPrint("❌ fetchStores ERROR: $e");
      debugPrint("🧵 STACKTRACE: $stack");
    }
  }


}