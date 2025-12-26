import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;

  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ApiCalls apiCalls = ApiCalls();

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> data = {
        "userFullName": name,
        "userEmail": email,
        "userPhoneNumber": phone,
        "password": password,
        "role": "STORE_MANAGER",
        "status": "active",
        "storeAdminEmail": "test1234@gmail.com",
        "storeAdminMobile": "456789098",
        "addedBy": "admin",
        "store": "Pharmacy",
        "userType": "SA"
      };

      var response =
      await apiCalls.postMethod(RouteUrls.signUPUrl, data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed('/otp', arguments: {
          "email": email,
          "phone": phone,
        });
      } else {
        Get.snackbar("Error", "Unexpected response from server");
      }
    } catch (e) {
      Get.snackbar("Error", "Registration failed");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

