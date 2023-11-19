import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  GlobalKey<FormState> key = GlobalKey();
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
    firebaseAuth.signOut();
  }

  checkUser() async {
    if (firebaseAuth.currentUser != null) {
      final stopwatch = Stopwatch()..start();
      await getData();
      stopwatch.stop();
      if (stopwatch.elapsed.inSeconds < 2) {
        await Future.delayed(
            Duration(seconds: 2 - stopwatch.elapsed.inSeconds));
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }
    navigator();
  }

  setData() async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set({});
  }

  getData() async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      userData = UserModel.fromJson(value.data() as Map);
    });
  }

  navigator() async {
    if (userData.uid.isEmpty) {
      navigatorKey.currentState?.pushReplacementNamed('user');
    } else {
      // navigatorKey.currentState?.pushReplacementNamed('register');
    }
  }

  auth() async {
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
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(const SnackBar(
        width: 300,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        content: Center(
            child: Text(
          'Wrong username or password!',
          style: TextStyle(fontSize: 18),
        )),
        behavior: SnackBarBehavior.floating,
      ));
    }
    emit(AuthInitial());
  }

  Future<void> signUp() async {
    if (agree) {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text);
      // user = {
      //   'email': email.text.trim(),
      //   'name': name.text,
      //   'uid': firebaseAuth.currentUser!.uid,
      //   'role': 'U',
      //   'phone': '',
      //   'points': 0,
      //   'wallet': 0,
      //   'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
      // };
      setData();
      await navigator();
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
    await getData();
    await navigator();
    email.clear();
    name.clear();
    password.clear();
  }
}
