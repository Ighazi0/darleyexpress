import 'package:darleyexpress/controller/auth_controller.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AuthController(),
      builder: (auth) {
        return Container(
          width: Get.width,
          height: Get.height,
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  auth.userData.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              if (auth.userData.uid.isNotEmpty)
                ListTile(
                  title: Text(
                    'myOrders'.tr,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'orders');
                  },
                  leading: const Icon(Icons.content_paste),
                ),
              if (auth.userData.uid.isNotEmpty)
                ListTile(
                  title: Text(
                    'manageAdd'.tr,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'address');
                  },
                  leading: const Icon(Icons.map),
                ),
              if (auth.userData.uid.isNotEmpty)
                ListTile(
                  title: Text(
                    'paymentMethod'.tr,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'payment');
                  },
                  leading: const Icon(Icons.wallet),
                ),
              ListTile(
                title: Text(
                  'settings'.tr,
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'settings');
                },
                leading: const Icon(
                  Icons.settings,
                ),
              ),
              ListTile(
                title: Text(
                  'help'.tr,
                ),
                onTap: () {
                  HapticFeedback.lightImpact();
                  var url = Uri(
                    scheme: 'mailto',
                    path: 'comma0tech@gmail.com',
                    query: 'subject=Help',
                  );
                  staticFunctions.urlLauncher(url);
                },
                leading: const Icon(
                  Icons.help_center,
                ),
              ),
              ListTile(
                title: Text(
                  'contactUs'.tr,
                ),
                onTap: () {
                  staticFunctions.urlLauncher(Uri.parse('tel:+1234567890'));
                },
                leading: const Icon(
                  Icons.contact_phone_rounded,
                ),
              ),
              if (auth.userData.uid == 'hiP36E2GauXh58htWy11NJyWa2J2')
                SwitchListTile(
                  value: auth.appData!.orders,
                  onChanged: (e) {
                    auth.changeOrders();
                  },
                  title: const Text('Accept orders?'),
                ),
              if (auth.userData.uid == 'hiP36E2GauXh58htWy11NJyWa2J2')
                Column(
                    children: auth.appData!.paymobs!
                        .map(
                          (m) => SwitchListTile(
                            value: auth.appData!.paymobs!
                                .firstWhere((w) => w.id == m.id)
                                .status,
                            onChanged: (e) {
                              auth.changePaymobs(m.id);
                            },
                            title: Text(m.name),
                          ),
                        )
                        .toList()),
              ListTile(
                leading: Icon(
                  auth.userData.uid.isNotEmpty ? Icons.logout : Icons.login,
                  color: Colors.red,
                ),
                title: Text(
                  auth.userData.uid.isNotEmpty ? 'logOut'.tr : 'signIn'.tr,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  auth.logOut();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
