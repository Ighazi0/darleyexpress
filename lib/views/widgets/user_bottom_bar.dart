import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:flutter/material.dart';

class UserBottomBar extends StatefulWidget {
  const UserBottomBar({super.key});

  @override
  State<UserBottomBar> createState() => _UserBottomBarState();
}

class _UserBottomBarState extends State<UserBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 0.5, offset: Offset(0, -1), color: Colors.grey)
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                4,
                (index) => InkWell(
                      onTap: () {
                        userCubit.changeIndex(index);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(200),
                                      bottomRight: Radius.circular(200),
                                    ),
                                    color: primaryColor),
                                width: 20,
                                height:
                                    userCubit.selectedIndex == index ? 10 : 0,
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                          Icon(
                            staticData.bottomBar[index].values.first,
                            color: userCubit.selectedIndex == index
                                ? Colors.amber
                                : Colors.black,
                          ),
                          Text(
                            staticData.bottomBar[index].keys.first,
                            style: TextStyle(
                              color: userCubit.selectedIndex == index
                                  ? Colors.amber
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
