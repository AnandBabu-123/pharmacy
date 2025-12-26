import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:propertysearch/routes/app_routes.dart';
import 'data/api_foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Directionality( // Add Directionality widget
          textDirection: TextDirection.ltr, // Set text direction to left-to-right
          child: InternetIndicator(),
        ),
        Expanded(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: AppRoutes.loginView,
            getPages: AppRoutes.routes,
          ),
        ),
      ],
    );
  }
}
