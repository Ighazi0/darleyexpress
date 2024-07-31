import 'package:darleyexpress/views/screens/address_screen.dart';
import 'package:darleyexpress/views/screens/admin_banners.dart';
import 'package:darleyexpress/views/screens/admin_coupons.dart';
import 'package:darleyexpress/views/screens/admin_orders.dart';
import 'package:darleyexpress/views/screens/admin_products.dart';
import 'package:darleyexpress/views/screens/admin_reviews.dart';
import 'package:darleyexpress/views/screens/admin_screen.dart';
import 'package:darleyexpress/views/screens/checkout_screen.dart';
import 'package:darleyexpress/views/screens/delete_account_screen.dart';
import 'package:darleyexpress/views/screens/notification_screen.dart';
import 'package:darleyexpress/views/screens/orders_screen.dart';
import 'package:darleyexpress/views/screens/payment_screen.dart';
import 'package:darleyexpress/views/screens/register_screen.dart';
import 'package:darleyexpress/views/screens/settings_screen.dart';
import 'package:darleyexpress/views/screens/updated_screen.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:flutter/material.dart';

class AppConstant {
  String adminUid = 'IyCnrdBdowaVW5ZDLN53dlpYeD63';

  final RegExp isArabic =
          RegExp(r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]'),
      userNameCode = RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9_]{3,20}$');

  Color primaryColor = const Color(0xfffcba03);

  List<BoxShadow> shadow = [
    const BoxShadow(
      color: Colors.black12,
      spreadRadius: 0.1,
      blurRadius: 5,
    ),
  ];

  Map<String, Widget Function(BuildContext)> routes = {
    'adminOrders': (context) => const AdminOrders(),
    'adminReviews': (context) => const AdminReviews(),
    'register': (context) => const RegisterScreen(),
    'user': (context) => const UserScreen(),
    'payment': (context) => const PaymentScreen(),
    'orders': (context) => const OrdersScreen(),
    'settings': (context) => const SettingsScreen(),
    'delete': (context) => const DeleteAccountScreen(),
    'admin': (context) => const AdminScreen(),
    'adminP': (context) => const AdminProducts(),
    'adminB': (context) => const AdminBanners(),
    'address': (context) => const AddressScreen(),
    'coupons': (context) => const AdminCoupons(),
    'checkout': (context) => const CheckoutScreen(),
    'notification': (context) => const NotificationScreen(),
    'updated': (context) => const UpdatedScreen(),
  };

  ThemeData theme = ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color(0xff33367E),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff33367E),
      ),
      primarySwatch: Colors.purple,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
}
