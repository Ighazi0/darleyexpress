import 'package:darleyexpress/controller/firebase_options.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Stripe.publishableKey =
      'pk_test_51OJ2BXIgy4HITOKuKJdeAZ02svSYxmqjA9UWpictKgOsgeHUigfOJhy4Z8McYXVLJowpv1E7DXio9AKuzDOYOEFA00hbMLvTrT';
  runApp(const MyApp());
}
