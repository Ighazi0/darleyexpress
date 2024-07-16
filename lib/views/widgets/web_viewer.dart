import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewer extends StatefulWidget {
  const WebViewer({super.key, required this.url});

  final String url;

  @override
  State<WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  late final WebViewController controller;

  bool loading = true;
  Timer? time;

  @override
  void dispose() {
    if (time != null) {
      time!.cancel();
    }

    super.dispose();
  }

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              loading = false;
            });
          },
          onUrlChange: (UrlChange change) async {
            print(change.url);
            // if (change.url!
            //     .contains('https://uae.paymob.com/api/acceptance/post_pay')) {

            // time = Timer.periodic(const Duration(milliseconds: 500), (timer) {
            Future future = controller
                .runJavaScriptReturningResult("document.body.innerText");
            future.then((data) {
              String text = Platform.isIOS
                  ? data.toString()
                  : jsonDecode(data).toString();
              print(text);
              if (text.contains('Successful')) {
                print('object');
                userCubit.changeDone(true);

                Navigator.pop(context);
              }
            });
            // });
            // }
            print(
                '================================================================');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : WebViewWidget(controller: controller),
      ),
    );
  }
}
