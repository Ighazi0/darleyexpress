import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAppBar extends StatefulWidget implements PreferredSizeWidget {
  const UserAppBar({super.key, this.scroll = false});
  final bool scroll;

  @override
  State<UserAppBar> createState() => _UserAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(140);
}

class _UserAppBarState extends State<UserAppBar> {
  bool end = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return PreferredSize(
            preferredSize: Size(dWidth, 130),
            child: AnimatedContainer(
              height:
                  auth.userData.address!.isEmpty || widget.scroll ? 80 : 130,
              onEnd: () {
                if (!widget.scroll) {
                  setState(() {
                    end = true;
                  });
                } else {
                  setState(() {
                    end = false;
                  });
                }
              },
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Column(
                children: [
                  if (auth.userData.address!.isNotEmpty &&
                      !widget.scroll &&
                      end)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'address');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'deliverTO'.tr(context),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: dWidth / 1.5,
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.white),
                                    Expanded(
                                      child: Text(
                                        auth.userData.address!.first.address,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.white)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                            decoration: const BoxDecoration(
                                color: Colors.white12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, 'notification');
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            )),
                      ],
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: userCubit.search,
                    onChanged: (value) {
                      userCubit.changeIndex(0);
                    },
                    decoration: InputDecoration(
                        suffixIcon: userCubit.search.text.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  userCubit.search.clear();
                                  userCubit.changeIndex(0);
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ))
                            : null,
                        hintText: 'search'.tr(context),
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  )
                ],
              ),
            ));
      },
    );
  }
}
