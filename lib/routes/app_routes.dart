
import 'package:get/get.dart';
import 'package:propertysearch/screens/dash_board.dart';
import 'package:propertysearch/screens/authentication_views/login_view.dart';
import 'package:propertysearch/screens/authentication_views/signup_view.dart';
import 'package:propertysearch/screens/forgot_password/forgot_password.dart';
import 'package:propertysearch/screens/get_store_user_view.dart';
import 'package:propertysearch/screens/pharmacyStore/add_pharmacy.dart';
import 'package:propertysearch/screens/pharmacyStore/add_rack_management.dart';
import 'package:propertysearch/screens/pharmacyStore/custore_management.dart';
import 'package:propertysearch/screens/pharmacyStore/get_purchase_view.dart';
import 'package:propertysearch/screens/pharmacyStore/get_rock_management.dart';
import 'package:propertysearch/screens/pharmacyStore/get_sales_report.dart';
import 'package:propertysearch/screens/pharmacyStore/gst_report_view.dart';
import 'package:propertysearch/screens/pharmacyStore/manual_stock_view.dart';
import 'package:propertysearch/screens/pharmacyStore/price_manage_view.dart';
import 'package:propertysearch/screens/pharmacyStore/purcahse_invoice_view.dart';
import 'package:propertysearch/screens/pharmacyStore/sales_invoice_view.dart';
import 'package:propertysearch/screens/pharmacyStore/search_pharmacy_user.dart';
import 'package:propertysearch/screens/pharmacyStore/stock_report_view.dart';
import 'package:propertysearch/screens/store_list.dart';
import 'package:propertysearch/screens/update_details_screen.dart';
import 'package:propertysearch/screens/update_store_documents_view.dart';
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
   static const searchPharmacyUser ="/searchPharmacyUser";
   static const getRackManagement ="/getRackManagement";
   static const getInvoice = "/getInvoice";
   static const addRackManagement = "/addRackManagement";
   static const getPurchaseReport = "/getPurchaseReport";
   static const salesInVoice = "/salesInVoice";
   static const salesReport = "/salesReport";
   static const priceManage ="/priceManage";
   static const getStoreUser = "/getStoreUser";
   static const updateStoreDocuments ="/updateStoreDocuments";
   static const stockReport= "/stockReport";
   static const manualStock ="/manualStock";
   static const gstReport ="/gstReport";
   static const customerManagement = "/customerManagement";


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
    GetPage(name: searchPharmacyUser, page: () => SearchPharmacyUser()),
    GetPage(name: getRackManagement, page: () => GetRackManagement()),
    GetPage(name: getInvoice, page: () => PurcahseInvoiceView()),
    GetPage(name: addRackManagement, page: () => AddRackManagement()),
    GetPage(name: getPurchaseReport, page: () => PurchaseReport()),
    GetPage(name: salesInVoice, page: () => SalesInvoiceView()),
    GetPage(name: salesReport, page: () => GetSalesReport()),
    GetPage(name: priceManage, page: () => PriceManageView()),
    GetPage(name: getStoreUser, page: () => GetStoreUserView()),
    GetPage(name: updateStoreDocuments, page: () => UpdateStoreDocumentsView()),
    GetPage(name: stockReport, page: () => StockReportView()),
    GetPage(name: manualStock, page: () => ManualStockView()),
    GetPage(name: gstReport, page: () => GstReportView()),
    GetPage(name: customerManagement, page: () => CustomerManagement()),

  ];
}

