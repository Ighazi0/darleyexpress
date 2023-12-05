import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'notifications'.tr(context),
        action: const {},
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore.collection('notifications').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_notification.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'noNotifications'.tr(context),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
