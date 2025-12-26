import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup_controller.dart';
import '../../utilities/custom_textview.dart';
import 'login_view.dart';


class SignUPView extends StatelessWidget {
  SignUPView({super.key});
  final controller = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,

      /// 🌈 GRADIENT APPBAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF90EE90), // light green
                Color(0xFFBBDEFB), // light blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),

      /// 🌈 BODY GRADIENT
      body: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF90EE90),
              Color(0xFFBBDEFB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLabel("Name", isMandatory: true),
                CustomTextField(
                controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  hintText: "Enter your name",
                  maxLength: 30,
                ),

                const SizedBox(height: 20),
                _buildLabel("Phone Number"),
                CustomTextField(
                  controller: controller.phoneController,
                  hintText: "Enter your phone number",
                  keyboardType: TextInputType.phone,
                  maxLength: 15,
                ),

                const SizedBox(height: 20),
                _buildLabel("Email Address", isMandatory: true),
                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Enter your email address",
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 30,
                ),

                const SizedBox(height: 20),
                _buildLabel("Password", isMandatory: true),
                CustomTextField(
                  controller: controller.passwordController,
                  hintText: "Enter valid password",
                  isPassword: true,
                ),

                const SizedBox(height: 20),
                _buildLabel("Confirm Password", isMandatory: true),
                CustomTextField(
                  controller: controller.confirmPasswordController,
                  hintText: "Confirm your password",
                  isPassword: true,
                ),

                const SizedBox(height: 30),

                /// SIGN UP BUTTON
                Obx(() => controller.isLoading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: controller.register,
                  child: Text("Submit"),
                )),
                const SizedBox(height: 30),

                /// LOGIN REDIRECT AT BOTTOM
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildLoginRedirect(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// LABEL
  Widget _buildLabel(String text, {bool isMandatory = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: RichText(
      text: TextSpan(
        text: "$text ",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: isMandatory
            ? const [
          TextSpan(
            text: "*",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ]
            : [],
      ),
    ),
  );

  /// LOGIN REDIRECT
  Widget _buildLoginRedirect() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
              text: "Login",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w800,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.offAll(() => LoginView());
                },
            ),
          ],
        ),
      ),
    );
  }
}


