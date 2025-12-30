
import 'package:get/get.dart';
import 'package:propertysearch/screens/dash_board.dart';
import 'package:propertysearch/screens/authentication_views/login_view.dart';
import 'package:propertysearch/screens/authentication_views/signup_view.dart';
import 'package:propertysearch/screens/forgot_password/forgot_password.dart';
import 'package:propertysearch/screens/pharmacyStore/add_pharmacy.dart';
import 'package:propertysearch/screens/store_list.dart';
import 'package:propertysearch/screens/update_details_screen.dart';
import 'package:propertysearch/screens/userstore_details.dart';

import '../screens/authentication_views/otp_screen.dart';


class AppRoutes {

  static const loginView = "/loginView";
  static const signupView = "/signupView";
  static const dashBoardView ="/dashBoardView";
  static const forgotPassword ="/forgotPassword";
   static const otpScreen ="/otpScreen";
   static const updateStoreDetails ="/updateStoreDetails";
   static const userStoreDetails ="/userStoreDetails";
   static const storeList = "/storeList";
   static const addPharmacy ="/addPharmacy";

  static final routes = [
    GetPage(name: loginView, page: () =>  LoginView(),),
    GetPage(name: signupView, page: () =>  SignUPView(),),
    GetPage(name: dashBoardView, page: () =>  DashboardView(),),
    GetPage(name: forgotPassword, page: () => ForgotPassword()),
    GetPage(name: signupView, page: () => SignUPView()),
    GetPage(name: otpScreen, page: () => OtpScreen()),
    GetPage(name: updateStoreDetails, page: () => UpdateDetailsScreen()),
    GetPage(name: userStoreDetails, page: () => UserStoreDetails()),
    GetPage(name: storeList, page: () => StoreList()),
    GetPage(name: addPharmacy, page: () => AddPharmacy()),

  ];
}

