import 'package:darleyexpress/controller/auth_controller.dart';
import 'package:darleyexpress/controller/language_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        action: {},
        title: 'Settings',
      ),
      body: Column(
        children: [
          if (auth.userData.uid.isNotEmpty)
            GetBuilder(
              init: AuthController(),
              builder: (auth) {
                return SwitchListTile(
                  value: auth.notification,
                  activeColor: appConstant.primaryColor,
                  title: Text(
                    'notifications'.tr,
                  ),
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    auth.changeNotification(value);
                  },
                  secondary: const Icon(Icons.notifications),
                );
              },
            ),
          if (auth.userData.uid.isNotEmpty)
            if (firebaseAuth.currentUser?.providerData.first.providerId ==
                'password')
              ListTile(
                title: Text(
                  'changeEmail'.tr,
                ),
                onTap: () {},
                leading: const Icon(Icons.email),
              ),
          if (auth.userData.uid.isNotEmpty)
            if (firebaseAuth.currentUser?.providerData.first.providerId ==
                'password')
              ListTile(
                title: Text(
                  'changePass'.tr,
                ),
                onTap: () {},
                leading: const Icon(Icons.password),
              ),
          ListTile(
            title: Text(
              'changeLang'.tr,
            ),
            onTap: () {
              if (Get.locale!.languageCode == 'ar') {
                Get.find<LanguageController>().changeLanguage('en');
              } else {
                Get.find<LanguageController>().changeLanguage('ar');
              }
            },
            leading: const Icon(Icons.language),
          ),
          if (auth.userData.uid.isNotEmpty)
            ListTile(
              title: Text(
                'deleteAccount'.tr,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'deleteAccount'.tr,
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            'cancel'.tr,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Delete'.tr,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            auth.logOut();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              leading: const Icon(
                Icons.person_remove,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
