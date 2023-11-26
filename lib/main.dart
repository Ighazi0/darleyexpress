import 'package:darleyexpress/controller/firebase_options.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey =
      'pk_test_51OGoUUBkldohVpSKP6HOtAKCf82eUj3O7NClMWiEl3uC5kolDBfzhhdsLU0dt7hURWIlvoWcXtRs1fPQKIqNtXaL00RcIvH5YI';
  runApp(const MyApp());
}
