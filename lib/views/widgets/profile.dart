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
          MaterialButton(
            onPressed: () {
              auth.logOut();
            },
            color: primaryColor,
          )
        ],
      ),
    );
  }
}
