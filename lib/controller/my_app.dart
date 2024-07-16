import 'package:darleyexpress/controller/language_controller.dart';
import 'package:darleyexpress/controller/static_data.dart';
import 'package:darleyexpress/controller/static_functions.dart';
import 'package:darleyexpress/controller/static_widgets.dart';
import 'package:darleyexpress/cubit/auth_cubit.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

StaticData staticData = StaticData();
StaticWidgets staticWidgets = StaticWidgets();
StaticFunctions staticFunctions = StaticFunctions();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => UserCubit(),
          ),
        ],
        child: GetMaterialApp(
          locale: Locale(Get.find<LanguageController>().getSavedLanguage()),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: false,
              progressIndicatorTheme:
                  ProgressIndicatorThemeData(color: appConstant.primaryColor),
              scaffoldBackgroundColor: Colors.white,
              primaryColor: appConstant.primaryColor,
              appBarTheme:
                  AppBarTheme(backgroundColor: appConstant.primaryColor)),
          supportedLocales: const [Locale('en'), Locale('ar')],
          routes: appConstant.routes,
          home: const SplashScreen(),
        ));
  }
}
