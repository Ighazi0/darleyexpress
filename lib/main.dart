import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await GetInitial().initialApp();

  runApp(const MyApp());
}
