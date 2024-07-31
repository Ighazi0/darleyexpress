import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/controller/user_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  GlobalKey<FormState> key = GlobalKey();
  final _googleSignIn = GoogleSignIn();
  AuthorizationCredentialAppleID? appleCredential;
  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController();
  UserModel userData = UserModel(address: []);
  bool agree = false, signIn = true, notification = false, loading = false;

  changeNotification(x) async {
    notification = x;
    getStorage.write('notification', x);
    if (x) {
      requestPermission();
    } else {
      firebaseMessaging.deleteToken();
    }
    update();
  }

  requestPermission() async {
    notification = getStorage.read('notification') ?? true;

    await firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    if (notification) {
      firebaseMessaging.getToken().then((value) {
        firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'token': value,
        });
      });
    }
  }

  agreeTerm() {
    agree = !agree;
    update();
  }

  changeStatus() {
    signIn = !signIn;
    update();
  }

  logOut() async {
    Get.find<UserController>().selectedIndex = 0;
    _googleSignIn.signOut();
    userData = UserModel(address: []);
    await firebaseAuth.signOut();
    Get.toNamed('register');
  }

  checkUser() async {
    var v = '0', app = {};
    if (firebaseAuth.currentUser != null) {
      if (firebaseAuth.currentUser!.uid == staticData.adminUID) {
        await Future.delayed(const Duration(seconds: 1));
      } else {
        await firestore
            .collection('appInfo')
            .doc('0')
            .get()
            .then((value) async {
          app = value.data() as Map;
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          v = packageInfo.version;
        }).onError((e, e1) {
          Get.offNamed('updated');
        });

        if (GetPlatform.isIOS) {
          if (v != app['ios']) {
            Get.offNamed('updated');
            return;
          }
        } else {
          if (v != app['android']) {
            Get.offNamed('updated');
            return;
          }
        }

        await getUserData();
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }
    navigator();
  }

  getUserData() async {
    if (firebaseAuth.currentUser!.uid != staticData.adminUID) {
      try {
        await firestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .get()
            .then((value) {
          userData = UserModel.fromJson(value.data() as Map);
        });
      } catch (e) {
        Fluttertoast.showToast(msg: 'error');
      }
    }
  }

  navigator() async {
    if (firebaseAuth.currentUser?.uid == staticData.adminUID) {
      Get.offNamed('admin');
    } else {
      if (userData.uid.isEmpty) {
        Get.offNamed('register');
      } else {
        requestPermission();
        Get.offNamed('user');
      }
    }
  }

  Future<void> appleSignIn() async {
    HapticFeedback.lightImpact();
    loading = true;

    update();
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential!.identityToken,
      );

      await firebaseAuth.signInWithCredential(oauthCredential);

      await createUser(
          '${appleCredential!.givenName} ${appleCredential!.familyName}',
          '',
          appleCredential!.email.toString(),
          true);

      await navigator();
      email.clear();
      name.clear();
      password.clear();
    } catch (e) {
      loading = false;
      Fluttertoast.showToast(msg: 'Error');
    }
    update();
  }

  Future<void> googleSignIn() async {
    HapticFeedback.lightImpact();
    loading = true;

    update();
    try {
      GoogleSignInAccount? googleSignInAccount;

      googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        loading = false;

        update();
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);
      await createUser(googleSignInAccount.displayName.toString(),
          googleSignInAccount.photoUrl ?? '', googleSignInAccount.email, true);
      await navigator();
      email.clear();
      name.clear();
      password.clear();
    } catch (e) {
      loading = false;

      update();
      Fluttertoast.showToast(msg: e.toString());
    }

    update();
  }

  Future<void> createUser(
    String name,
    String photo,
    String email,
    bool check,
  ) async {
    Map<String, dynamic> data = {
      'uid': firebaseAuth.currentUser!.uid,
      'pic': photo,
      'verified': false,
      'blocked': false,
      'link': '',
      'token': '',
      'timestamp': Timestamp.now(),
      'birth': Timestamp.now(),
      'phone': '',
      'coins': 0,
      'wallet': [],
      'email': email.trim(),
      'name': name.trim(),
      'address': [],
      'gender': '',
    };

    if (check) {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) async {
        if (!value.exists) {
          firestore
              .collection('users')
              .doc(firebaseAuth.currentUser!.uid)
              .set(data);
          userData = UserModel.fromJson(data);
        } else {
          await getUserData();
        }
      });
    } else {
      firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(data);
      userData = UserModel.fromJson(data);
    }
  }

  auth(context) async {
    if (!key.currentState!.validate()) {
      return;
    }
    loading = true;

    update();
    try {
      if (signIn) {
        await signInAuth();
      } else {
        await signUp();
      }
      email.clear();
      name.clear();
      password.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: e.code.tr);
      }
      Fluttertoast.showToast(msg: 'invalidCredentials'.tr);
    }
    update();
  }

  Future<void> signUp() async {
    if (agree) {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text);
      await createUser(name.text, '', email.text.trim(), false);
      navigator();
    } else {
      Get.snackbar('', 'Please read the Terms & Conditions and agree with it');
    }
  }

  Future<void> signInAuth() async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text);
    await getUserData();
    await navigator();
  }
}
