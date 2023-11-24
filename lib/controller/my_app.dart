import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/static_data.dart';
import 'package:darleyexpress/controller/static_functions.dart';
import 'package:darleyexpress/controller/static_widgets.dart';
import 'package:darleyexpress/cubit/auth_cubit.dart';
import 'package:darleyexpress/cubit/locale_cubit.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/views/screens/forgot_password.dart';
import 'package:darleyexpress/views/screens/register_screen.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

LocaleCubit locale = LocaleCubit();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

final physical =
    WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
final devicePixelRatio =
    WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
final double dHeight = physical.height / devicePixelRatio;
final double dWidth = physical.width / devicePixelRatio;

StaticData staticData = StaticData();
StaticWidgets staticWidgets = StaticWidgets();
StaticFunctions staticFunctions = StaticFunctions();

Color primaryColor = const Color(0xfffcba03);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit()..getSavedLanguage(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          locale = BlocProvider.of<LocaleCubit>(context);
          return MaterialApp(
            locale: state.locale,
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: snackbarKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: primaryColor,
                appBarTheme: AppBarTheme(backgroundColor: primaryColor)),
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (deviceLocale != null &&
                    deviceLocale.languageCode == locale.languageCode) {
                  return deviceLocale;
                }
              }

              return supportedLocales.first;
            },
            routes: {
              'register': (context) => const RegisterScreen(),
              'user': (context) => const UserScreen(),
              'forgot': (context) => const ForgotPasswordScreen()
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
