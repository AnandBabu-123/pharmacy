import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../data/api_calls.dart';
import '../data/route_urls.dart';

class OtpController extends GetxController {

  final ApiCalls apiCalls = ApiCalls();


  String emailOtp = '';
  String mobileOtp = '';

  late String email;
  late String phoneNumber;

  @override
  void onInit() {
    super.onInit();

    email = Get.arguments['email'];
    phoneNumber = Get.arguments['phone'];

    print("📩 OTP SCREEN RECEIVED EMAIL: $email");
    print("📱 OTP SCREEN RECEIVED PHONE: $phoneNumber");
  }

  /// SEND EMAIL OTP
  Future<void> sendEmailOtp() async {
    try {
      print("📤 SEND EMAIL OTP → $email");

      Map<String, dynamic> data = {
        "email": email,
      };

      var response = await apiCalls.postMethod(RouteUrls.verifyEmailOTP, data);

      print("✅ EMAIL OTP SENT RESPONSE: ${response.data}");
      Get.snackbar("Success", "OTP sent to $email");
    } on DioException catch (e) {
      print("❌ EMAIL OTP ERROR: ${e.response?.data}");
      Get.snackbar(
        "Error",
        e.response?.data['message']?.toString() ??
            "Failed to send Email OTP",
      );
    }
  }

  /// VERIFY EMAIL OTP
  Future<void> verifyEmailOtp() async {
    try {
      print("📤 VERIFY EMAIL OTP → $email | OTP: $emailOtp");

      Map<String, dynamic> data = {
        "email": email,
        "otp": emailOtp,
      };

      var response = await apiCalls.postMethod(RouteUrls.verifyEmailOTP, data);

      print("✅ EMAIL VERIFIED RESPONSE: ${response.data}");
      Get.snackbar("Success", "Email verified successfully");
    } on DioException catch (e) {
      print("❌ EMAIL VERIFY ERROR: ${e.response?.data}");
      Get.snackbar(
        "Error",
        e.response?.data['message']?.toString() ??
            "Invalid Email OTP",
      );
    }
  }

  /// SEND MOBILE OTP
  Future<void> sendMobileOtp() async {
    try {

      Map<String, dynamic> data = {
        "phoneNumber": phoneNumber,
      };

      var response = await apiCalls.postMethod(RouteUrls.mobileOTP, data);

      print("✅ MOBILE OTP SENT RESPONSE: ${response.data}");
      Get.snackbar("Success", "OTP sent to $phoneNumber");
    } on DioException catch (e) {
      print("❌ MOBILE OTP ERROR: ${e.response?.data}");
      Get.snackbar(
        "Error",
        e.response?.data['message']?.toString() ??
            "Failed to send Mobile OTP",
      );
    }
  }

  /// VERIFY MOBILE OTP
  Future<void> verifyMobileOtp() async {
    try {

      Map<String, dynamic> data = {
        "phoneNumber": phoneNumber,
        "otp": mobileOtp,
      };

      var response = await apiCalls.postMethod(RouteUrls.mobileOTP, data);

      print("✅ MOBILE VERIFIED RESPONSE: ${response.data}");
      Get.snackbar("Success", "Mobile number verified");
    } on DioException catch (e) {
      print("❌ MOBILE VERIFY ERROR: ${e.response?.data}");
      Get.snackbar(
        "Error",
        e.response?.data['message']?.toString() ??
            "Invalid Mobile OTP",
      );
    }
  }
}



