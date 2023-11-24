import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/views/widgets/cart.dart';
import 'package:darleyexpress/views/widgets/home.dart';
import 'package:darleyexpress/views/widgets/profile.dart';
import 'package:darleyexpress/views/widgets/user_bottom_bar.dart';
import 'package:darleyexpress/views/widgets/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

UserCubit userCubit = UserCubit();

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        userCubit = BlocProvider.of<UserCubit>(context);
        return Scaffold(
            backgroundColor: primaryColor,
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
