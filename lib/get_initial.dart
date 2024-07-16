import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darleyexpress/constant_data.dart';
import 'package:darleyexpress/controller/auth_controller.dart';
import 'package:darleyexpress/controller/firebase_options.dart';
import 'package:darleyexpress/controller/language_controller.dart';
import 'package:darleyexpress/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetInitial {
  initialApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Get.put(LanguageController());
    Get.put(AuthController());
    Get.put(UserController());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await GetStorage.init();
  }
}

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
AppConstant appConstant = AppConstant();
// Assets assets = Assets();
GetStorage getStorage = GetStorage();

Color colorCompute(color) {
  return Color(int.parse('0xff$color')).computeLuminance() > 0.5
      ? Colors.black
      : Colors.white;
}
