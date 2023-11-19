import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/auth_cubit.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
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
                          signIn ? 'signIn'.tr(context) : 'signUp'.tr(context),
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
                          signIn
                              ? 'welcomeBack'.tr(context)
                              : 'fill'.tr(context),
                          textAlign: TextAlign.center,
                          key:
                              ValueKey<String>(signIn ? 'welcomeBack' : 'fill'),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    if (!signIn)
                      TextFieldAuth(
                          hint: 'Ex. Ghazi',
                          function: auth.auth,
                          controller: auth.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseName'.tr(context);
                            }
                            return null;
                          },
                          title: 'name'.tr(context)),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldAuth(
                        hint: 'example@gmail.com',
                        function: auth.auth,
                        controller: auth.email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEmail'.tr(context);
                          }
                          return null;
                        },
                        title: 'email'.tr(context)),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldAuth(
                        hint: '',
                        secure: true,
                        function: auth.auth,
                        controller: auth.password,
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'pleasePassword'.tr(context);
                          }
                          return null;
                        },
                        title: 'password'.tr(context)),
                    if (signIn)
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.red.shade100)),
                            onPressed: () {},
                            child: Text(
                              'forgot'.tr(context),
                              style: const TextStyle(
                                  color: Color(0xffFF4747),
                                  decoration: TextDecoration.underline),
                            )),
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
                                activeColor: const Color(0xffFF4747),
                              ),
                              Text(
                                'agree'.tr(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                              TextButton(
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.red.shade100)),
                                  onPressed: () {},
                                  child: Text(
                                    'term'.tr(context),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xffFF4747),
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          )),
                    Align(
                      child: state is LoadingState
                          ? const CircularProgressIndicator(
                              color: Color(0xffFF4747),
                            )
                          : MaterialButton(
                              minWidth: dWidth,
                              height: 50,
                              onPressed: () async {
                                auth.auth();
                              },
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              color: const Color(0xffFF4747),
                              child: Text(
                                signIn
                                    ? 'signIn'.tr(context)
                                    : 'signUp'.tr(context),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 50, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 100,
                            child: const Divider(
                              thickness: 1,
                            ),
                          ),
                          Text('or'.tr(context)),
                          Container(
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Divider(
                              thickness: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            onTap: () {},
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100))),
                                child: Logo(
                                  Logos.apple,
                                  size: 30,
                                ))),
                        InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            onTap: () {},
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100))),
                                child: Logo(
                                  Logos.google,
                                  size: 30,
                                ))),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            signIn
                                ? 'dontHave'.tr(context)
                                : 'haveAcc'.tr(context),
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
                              overlayColor: MaterialStateProperty.all(
                                  Colors.red.shade100)),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                                signIn
                                    ? 'signUp'.tr(context)
                                    : 'signIn'.tr(context),
                                key: ValueKey<String>(
                                    signIn ? 'signUp' : 'signIn'),
                                style: const TextStyle(
                                    color: Color(0xffFF4747),
                                    decoration: TextDecoration.underline)),
                          ),
                        ),
                      ],
                    )
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

class TextFieldAuth extends StatefulWidget {
  const TextFieldAuth(
      {super.key,
      required this.function,
      required this.controller,
      required this.validator,
      required this.hint,
      this.secure = false,
      required this.title});
  final String title;
  final String hint;
  final Function function;
  final bool secure;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  @override
  State<TextFieldAuth> createState() => _TextFieldAuthState();
}

class _TextFieldAuthState extends State<TextFieldAuth> {
  bool showPass = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Text(widget.title),
        ),
        TextFormField(
            obscureText: !showPass && widget.secure,
            cursorColor: const Color(0xffFF4747),
            onFieldSubmitted: (value) => widget.function(),
            decoration: InputDecoration(
                hintText: widget.hint,
                suffixIcon: widget.secure
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        icon: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xffFF4747),
                        ))
                    : null,
                fillColor: Colors.grey.shade300,
                filled: true,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15)),
            controller: widget.controller,
            validator: widget.validator),
      ],
    );
  }
}
