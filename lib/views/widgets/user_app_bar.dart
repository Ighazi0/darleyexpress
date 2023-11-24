import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:flutter/material.dart';

class UserAppBar extends StatefulWidget implements PreferredSizeWidget {
  const UserAppBar({super.key, this.scroll = false});
  final bool scroll;

  @override
  State<UserAppBar> createState() => _UserAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(scroll ? 85 : 145);
}

class _UserAppBarState extends State<UserAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(dWidth, 160),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          child: Column(
            children: [
              if (!widget.scroll)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'deliverTO'.tr(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.white),
                            Text(
                              'Amman, Marj Alhammam',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: Colors.white)
                          ],
                        )
                      ],
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
                            // var id = DateTime.now()
                            //     .millisecondsSinceEpoch
                            //     .toString();
                            // firestore
                            //     .collection('categories')
                            //     .doc('1700424150102')
                            //     .collection('categories')
                            //     .doc(id)
                            //     .set({
                            //   'id': id,
                            //   'timeStamp': DateTime.now(),
                            //   'titleAr': 'عطور للزجال',
                            //   'titleEn': 'men perfumes',
                            //   'link': '',
                            //   'url':
                            //       'https://assets.vogue.com/photos/6054ceb33de64a1c8b706d68/3:4/w_748%2Cc_limit/slide_6.jpg',
                            //   'category': '1700424150102',
                            // });
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
                height: 25,
              ),
              TextField(
                decoration: InputDecoration(
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              )
            ],
          ),
        ));
  }
}
