import 'package:darleyexpress/controller/language_controller.dart';
import 'package:darleyexpress/controller/languages.dart';
import 'package:darleyexpress/controller/static_data.dart';
import 'package:darleyexpress/controller/static_functions.dart';
import 'package:darleyexpress/controller/static_widgets.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

StaticData staticData = StaticData();
StaticWidgets staticWidgets = StaticWidgets();
StaticFunctions staticFunctions = StaticFunctions();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: Locale(Get.find<LanguageController>().getSavedLanguage()),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: false,
          progressIndicatorTheme:
              ProgressIndicatorThemeData(color: appConstant.primaryColor),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: appConstant.primaryColor,
          appBarTheme: AppBarTheme(backgroundColor: appConstant.primaryColor)),
      routes: appConstant.routes,
      home: const SplashScreen(),
    );
  }
}
