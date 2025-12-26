import 'package:get/get.dart';
import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../model/store_details.dart';


class DashboardController extends GetxController {
  final ApiCalls apiCalls = ApiCalls();
  final SharedPreferencesData prefs = SharedPreferencesData();

  var isLoading = false.obs;
  var storeList = <Stores>[].obs;

  @override
  void onReady() {
    super.onReady();
    fetchStores();
  }

  Future<void> fetchStores() async {
    try {
      print(" Dashboard fetchStores started");
      await apiCalls.initializeDio();
      String userId = await prefs.getUserId();
      String accesstoken = await prefs.getAccessToken();
      print(" UserId: $userId");
      print("accessstoken :$accesstoken");

      if (userId.isEmpty) {
        print(" UserId missing");
        return;
      }

      final response = await apiCalls.getMethod(
        "${RouteUrls.storeDetails}?userId=$userId",
      );

      print(" Status Code: ${response.statusCode}");
      print(" Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final model = StoreDetailsModel.fromJson(response.data);

        print(" Stores Count: ${model.stores.length}");

        storeList.assignAll(model.stores);
      } else {
        print(" API failed");
      }
    } catch (e, stack) {
      print(" fetchStores error: $e");
      print(" StackTrace: $stack");
    }
  }

}

