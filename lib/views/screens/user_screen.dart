import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/views/widgets/cart.dart';
import 'package:darleyexpress/views/widgets/home.dart';
import 'package:darleyexpress/views/widgets/profile.dart';
import 'package:darleyexpress/views/widgets/user_app_bar.dart';
import 'package:darleyexpress/views/widgets/user_bottom_bar.dart';
import 'package:darleyexpress/views/widgets/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

UserCubit userCubit = UserCubit();

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          userCubit = BlocProvider.of<UserCubit>(context);
          return Scaffold(
              backgroundColor: primaryColor,
              appBar: const UserAppBar(
                scroll: false,
              ),
              bottomNavigationBar: const UserBottomBar(),
              body: IndexedStack(
                index: userCubit.selectedIndex,
                children: const [Home(), WishList(), Cart(), Profile()],
              ));
        },
      ),
    );
  }
}
