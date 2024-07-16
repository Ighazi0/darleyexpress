import 'package:darleyexpress/cubit/auth_cubit.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

AuthCubit auth = AuthCubit();

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    auth = BlocProvider.of<AuthCubit>(context);
    auth.checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appConstant.primaryColor,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png'),
          Text(
            'darley'.tr,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      )),
    );
  }
}
