
 import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:propertysearch/routes/app_routes.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';
import '../data/shared_preferences_data.dart';
import '../utilities/snack_bar_view.dart';

class LoginController extends GetxController{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiCalls apiCalls = ApiCalls();
  var loading = false.obs;

  Future<void> login() async {
    loading.value = true;

    try {
      Map<String, dynamic> data = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      var response = await apiCalls.postMethod(RouteUrls.loginURL, data);

      if (response.statusCode == 200) {
        await saveSessions(response.data);

        print("Login data saved: ${response.data}");

        SnackBarView.showSuccessMessage(
          response.data["responseMessage"] ?? "Login Successfully!",
          from: "login",
        );

        Get.offAllNamed(AppRoutes.dashBoardView);
      } else {
        SnackBarView.showErrorMessage("Login failed");
      }
    } catch (e) {
      print("Login error: $e");
      SnackBarView.showErrorMessage("Something went wrong");
    } finally {
      loading.value = false;
    }
  }


  Future<void> saveSessions(Map<String, dynamic> data) async {
    final SharedPreferencesData preferences = SharedPreferencesData();

    await preferences.saveAccessToken(data["token"] ?? "");
    await preferences.saveLoginStatus(true);

    await preferences.saveUserId(data["userId"] ?? "");
    await preferences.saveName(data["username"] ?? "");
    await preferences.saveEmail(data["userEmailAddress"] ?? "");
    await preferences.saveMobile(data["userContact"] ?? "");

    // Optional (if you need later)
    await preferences.saveUserType(data["userType"] ?? "");
    await preferences.saveDashboardRole(data["dashboardRole"] ?? "");
  }


}