import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  GlobalKey<FormState> key = GlobalKey();
  final _googleSignIn = GoogleSignIn();
  AuthorizationCredentialAppleID? appleCredential;
  TextEditingController email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController();
  UserModel userData = UserModel();
  bool agree = false, signIn = true;

  agreeTerm() {
    agree = !agree;
    emit(AuthInitial());
  }

  changeStatus() {
    signIn = !signIn;
    emit(AuthInitial());
  }

  logOut() async {
    userData = UserModel();
    await firebaseAuth.signOut();
    navigatorKey.currentState?.pushReplacementNamed('register');
  }

  checkUser() async {
    if (firebaseAuth.currentUser != null) {
      if (firebaseAuth.currentUser!.uid == staticData.adminUID) {
        await Future.delayed(const Duration(seconds: 1));
      }
      if (firebaseAuth.currentUser!.isAnonymous) {
        await Future.delayed(const Duration(seconds: 1));
      } else {
        final stopwatch = Stopwatch()..start();
        await getUserData();
        stopwatch.stop();
        if (stopwatch.elapsed.inSeconds < 2) {
          await Future.delayed(
              Duration(seconds: 2 - stopwatch.elapsed.inSeconds));
        }
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }
    navigator();
  }

  getUserData() async {
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

  navigator() async {
    if (userData.uid.isEmpty) {
      navigatorKey.currentState?.pushReplacementNamed('register');
    } else {
      navigatorKey.currentState?.pushReplacementNamed('user');
    }
  }

  Future<void> appleSignIn() async {
    HapticFeedback.lightImpact();
    emit(LoadingState());
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
    } catch (e) {
      emit(AuthInitial());
      Fluttertoast.showToast(msg: e.toString());
    }
    emit(AuthInitial());
  }

  Future<void> googleSignIn() async {
    HapticFeedback.lightImpact();
    emit(LoadingState());
    try {
      GoogleSignInAccount? googleSignInAccount;

      googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        emit(AuthInitial());
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
    } catch (e) {
      emit(AuthInitial());
      Fluttertoast.showToast(msg: e.toString());
    }

    emit(AuthInitial());
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
          var link = await staticFunctions.generateLink(
              firebaseAuth.currentUser!.uid, 'profile');
          data.update(
            'link',
            (v) => link,
          );
          await firestore
              .collection('users')
              .doc(firebaseAuth.currentUser!.uid)
              .set(data);
          userData = UserModel.fromJson(data);
        }
      });
    } else {
      var link = await staticFunctions.generateLink(
          firebaseAuth.currentUser!.uid, 'profile');
      data.update(
        'link',
        (v) => link,
      );
      await firestore
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
    emit(LoadingState());
    try {
      if (signIn) {
        await signInAuth();
      } else {
        await signUp();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: e.code.tr(context));
      }
      Fluttertoast.showToast(msg: 'invalidCredentials'.tr(context));
    }
    emit(AuthInitial());
  }

  Future<void> signUp() async {
    if (agree) {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text);
      await createUser(name.text, '', email.text.trim(), false);
      navigator();
      email.clear();
      name.clear();
      password.clear();
    } else {
      snackbarKey.currentState?.showSnackBar(const SnackBar(
        width: 300,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        content: Center(
            child: Text(
          'Please read the Terms & Conditions and agree with it',
          style: TextStyle(fontSize: 18),
        )),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> signInAuth() async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text);
    await getUserData();
    await navigator();
    email.clear();
    name.clear();
    password.clear();
  }
}
