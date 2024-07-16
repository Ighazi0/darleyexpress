import 'package:darleyexpress/controller/user_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/views/widgets/cart.dart';
import 'package:darleyexpress/views/widgets/home.dart';
import 'package:darleyexpress/views/widgets/profile.dart';
import 'package:darleyexpress/views/widgets/user_bottom_bar.dart';
import 'package:darleyexpress/views/widgets/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return Scaffold(
            backgroundColor: userCubit.selectedIndex == 0
                ? appConstant.primaryColor
                : Colors.white,
            bottomNavigationBar: const UserBottomBar(),
            body: SafeArea(
              child: IndexedStack(
                index: userCubit.selectedIndex,
                children: const [Home(), WishList(), Cart(), Profile()],
              ),
            ));
      },
    );
  }
}
