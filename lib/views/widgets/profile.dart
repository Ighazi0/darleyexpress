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
          ListTile(
            title: const Text(
              'Past orders',
            ),
            onTap: () {
              Navigator.pushNamed(context, 'orders');
            },
            leading: const Icon(Icons.content_paste),
          ),
          ListTile(
            title: const Text(
              'Addresses',
            ),
            onTap: () {
              Navigator.pushNamed(context, 'address');
            },
            leading: const Icon(Icons.map),
          ),
          // ListTile(
          //   title: const Text(
          //     'Settings',
          //   ),
          //   onTap: () {
          //     Navigator.pushNamed(context, 'settings');
          //   },
          //   leading: const Icon(
          //     Icons.settings,
          //   ),
          // ),
          ListTile(
            title: const Text(
              'Change language',
            ),
            onTap: () {
              if (locale.locale == 'ar') {
                locale.changeLanguage('en');
              } else {
                locale.changeLanguage('ar');
              }
            },
            leading: const Icon(Icons.language),
          ),
          ListTile(
            title: const Text(
              'Help',
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
            title: const Text(
              'Contact US',
            ),
            onTap: () {
              staticFunctions.urlLauncher(Uri.parse('tel:+1234567890'));
            },
            leading: const Icon(
              Icons.contact_phone_rounded,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
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
