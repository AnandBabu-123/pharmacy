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

  var nameError = "".obs;
  var emailError = "".obs;
  var passwordError = "".obs;
  var confirmPasswordError = "".obs;
  var phoneError = "".obs;

  bool isFormValid() {
    validateName();
    validatePhoneNumber();
    validateEmail();
    validatePassword();
    validateConfirmPassword();

    return nameError.value.isEmpty &&
        phoneError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty;
  }

  void validateName() {
    if (nameController.text.trim().isEmpty) {
      nameError.value = "Name is required";
    } else if (!RegExp(r"^[A-Za-z\s]+$").hasMatch(nameController.text.trim())) {
      nameError.value = "Enter a valid name";
    } else {
      nameError.value = "";
    }
  }

  void validatePhoneNumber() {

    // if (phoneController.text.trim().isEmpty) {
    //   phoneError.value = "Name is required";
    // }  else if (phoneController.length < 10 || phoneNumber.length > 15) {
    //   phoneError.value = "Enter a valid phone number (10–15 digits)";
    // } else {
    //   phoneError.value = "";
    // }
    //




    final phoneNumber = phoneController.text.trim();

    // If empty → no error (because it's not mandatory)
    if (phoneNumber.isEmpty) {
      phoneError.value = "phone number required";
    }
    // If not empty → check length 10–15
    else if (phoneNumber.length < 10 || phoneNumber.length > 15) {
      phoneError.value = "Enter a valid phone number (10–15 digits)";
    }
    else {
      phoneError.value = "";
    }
  }

  void validateEmail() {
    if (emailController.text.isEmpty) {
      emailError.value = "Email is required";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      emailError.value = "Enter a valid email address";
    } else {
      emailError.value = "";
    }
  }


  void validatePassword() {
    if (passwordController.text.isEmpty) {
      passwordError.value = "Password is required";
    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*#?&.,:;])[A-Za-z\d@$!%*#?&.,:;]{8,}$')
        .hasMatch(passwordController.text)) {
      passwordError.value = "Must contain uppercase, lowercase, numbers & special characters";
    } else {
      passwordError.value = "";
    }

    // ✅ Only validate confirm password if it's filled (prevents recursion)
    if (confirmPasswordController.text.isNotEmpty && confirmPasswordError.value.isNotEmpty) {
      validateConfirmPassword();
    }
  }

  void validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = "Confirm password is required";
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = "Passwords do not match";
    } else {
      confirmPasswordError.value = "";
    }

    // ✅ Only validate password if there's an error (prevents recursion)
    if (passwordController.text.isNotEmpty && passwordError.value.isNotEmpty) {
      validatePassword();
    }
  }

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

