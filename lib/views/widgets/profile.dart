import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dWidth,
      height: dHeight,
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              auth.userData.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          if (auth.userData.uid.isNotEmpty)
            ListTile(
              title: Text(
                'myOrders'.tr(context),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'orders');
              },
              leading: const Icon(Icons.content_paste),
            ),
          if (auth.userData.uid.isNotEmpty)
            ListTile(
              title: Text(
                'manageAdd'.tr(context),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'address');
              },
              leading: const Icon(Icons.map),
            ),
          ListTile(
            title: Text(
              'settings'.tr(context),
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
              'help'.tr(context),
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
              'contactUs'.tr(context),
            ),
            onTap: () {
              staticFunctions.urlLauncher(Uri.parse('tel:+1234567890'));
            },
            leading: const Icon(
              Icons.contact_phone_rounded,
            ),
          ),
          ListTile(
            leading: Icon(
              auth.userData.uid.isNotEmpty ? Icons.logout : Icons.login,
              color: Colors.red,
            ),
            title: Text(
              auth.userData.uid.isNotEmpty
                  ? 'logOut'.tr(context)
                  : 'signIn'.tr(context),
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              auth.logOut();
            },
          ),
        ],
      ),
    );
  }
}
