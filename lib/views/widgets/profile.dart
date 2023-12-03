import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';

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
            title: Text(auth.userData.name),
          ),
          const ListTile(
            title: Text(
              'Last orders',
            ),
            leading: Icon(Icons.content_paste),
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
