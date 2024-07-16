import 'dart:io';
import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/auth_cubit.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/widgets/forgot_bottom_sheet.dart';
import 'package:darleyexpress/views/widgets/edit_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool signIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          signIn = auth.signIn;
          return Form(
            key: auth.key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SafeArea(
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 50, bottom: 15),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          signIn ? 'signIn'.tr : 'signUp'.tr,
                          key: ValueKey<String>(signIn ? 'signIn' : 'signUp'),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(bottom: 20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          signIn ? 'welcomeBack'.tr : 'fill'.tr,
                          textAlign: TextAlign.center,
                          key:
                              ValueKey<String>(signIn ? 'welcomeBack' : 'fill'),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    if (!signIn)
                      EditText(
                          hint: 'Ex. Ghazi',
                          function: auth.auth,
                          controller: auth.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseName'.tr;
                            }
                            return null;
                          },
                          title: 'name'),
                    const SizedBox(
                      height: 10,
                    ),
                    EditText(
                        hint: 'example@gmail.com',
                        function: auth.auth,
                        controller: auth.email,
                        validator: (value) {
                          if (!value!.contains('@') && !value.contains('.')) {
                            return 'pleaseEmail'.tr;
                          }
                          return null;
                        },
                        title: 'email'),
                    const SizedBox(
                      height: 10,
                    ),
                    EditText(
                        hint: '',
                        secure: true,
                        function: auth.auth,
                        controller: auth.password,
                        validator: (value) {
                          if (value!.length < 8) {
                            return 'pleasePassword'.tr;
                          }
                          return null;
                        },
                        title: 'password'),
                    if (signIn)
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            style: ButtonStyle(
                                overlayColor: WidgetStateProperty.all(
                                    Colors.amber.shade50)),
                            onPressed: () {
                              staticWidgets.showBottom(
                                  context, const BottomSheetForgot(), 0.4, 0.5);
                            },
                            child: Text('forgot'.tr,
                                style: TextStyle(
                                  color: appConstant.primaryColor,
                                ))),
                      ),
                    if (!signIn)
                      Container(
                          margin: const EdgeInsets.only(bottom: 25, top: 10),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Checkbox(
                                shape: const CircleBorder(),
                                value: auth.agree,
                                onChanged: (v) {
                                  auth.agreeTerm();
                                },
                                activeColor: appConstant.primaryColor,
                              ),
                              Text(
                                'agree'.tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                              TextButton(
                                  style: ButtonStyle(
                                      overlayColor: WidgetStateProperty.all(
                                          Colors.amber.shade100)),
                                  onPressed: () {
                                    staticFunctions.urlLauncher(Uri.parse(''));
                                  },
                                  child: Text(
                                    'term'.tr,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: appConstant.primaryColor,
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          )),
                    Align(
                      child: state is LoadingState
                          ? const CircularProgressIndicator()
                          : MaterialButton(
                              minWidth: Get.width,
                              height: 50,
                              onPressed: () async {
                                auth.auth(context);
                              },
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              color: appConstant.primaryColor,
                              child: Text(
                                signIn ? 'signIn'.tr : 'signUp'.tr,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                    ),
                    if (signIn)
                      Container(
                        padding: const EdgeInsets.only(top: 50, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 100,
                              child: const Divider(
                                thickness: 1,
                              ),
                            ),
                            Text('or'.tr),
                            Container(
                              width: 100,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: const Divider(
                                thickness: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    if (signIn)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (Platform.isIOS)
                            InkWell(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                onTap: () {
                                  auth.appleSignIn();
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100))),
                                    child: const Icon(
                                      AntDesign.apple_fill,
                                      size: 30,
                                    ))),
                          InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              onTap: () {
                                auth.googleSignIn();
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Brand(
                                    Brands.google,
                                    size: 30,
                                  ))),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            signIn ? 'dontHave'.tr : 'haveAcc'.tr,
                            key: ValueKey<String>(
                                signIn ? 'dontHave' : 'haveAcc'),
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            auth.changeStatus();
                          },
                          style: ButtonStyle(
                              overlayColor: WidgetStateProperty.all(
                                  Colors.amber.shade50)),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(signIn ? 'signUp'.tr : 'signIn'.tr,
                                key: ValueKey<String>(
                                    signIn ? 'signUp' : 'signIn'),
                                style: TextStyle(
                                  color: appConstant.primaryColor,
                                )),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      child: TextButton(
                        onPressed: () async {
                          Get.offNamed('user');
                        },
                        style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.all(Colors.amber.shade50)),
                        child: Text('skip'.tr,
                            key: ValueKey<String>(signIn ? 'signUp' : 'signIn'),
                            style: TextStyle(
                              color: appConstant.primaryColor,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
