import 'package:darleyexpress/controller/auth_controller.dart';
import 'package:darleyexpress/controller/user_controller.dart';
import 'package:darleyexpress/get_initial.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAppBar extends StatefulWidget implements PreferredSizeWidget {
  const UserAppBar({super.key, this.scroll = false});
  final bool scroll;

  @override
  State<UserAppBar> createState() => _UserAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(140);
}

class _UserAppBarState extends State<UserAppBar> {
  var auth = Get.find<AuthController>();

  bool end = true;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (userCubit) {
        return PreferredSize(
            preferredSize: Size(Get.width, 130),
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
                color: appConstant.primaryColor,
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
                                'deliverTO'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: Get.width / 1.5,
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
                        hintText: 'search'.tr,
                        prefixIcon: Icon(
                          Icons.search,
                          color: appConstant.primaryColor,
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
