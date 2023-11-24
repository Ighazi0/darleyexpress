import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/cart_model.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  int selectedIndex = 0;
  Map<String, CartModel> cartList = {};

  addToCart(ProductModel p, int c) {
    if (cartList.containsKey(p.id)) {
      cartList.update(
          p.id,
          (value) => CartModel(
              productData: value.productData, count: value.count + c));
    } else {
      cartList.putIfAbsent(p.id, () => CartModel(productData: p, count: c));
    }

    emit(UserLoaded());
  }

  changeIndex(x) {
    selectedIndex = x;
    emit(UserLoaded());
  }

  favoriteStatus(ProductModel product) async {
    if (firebaseAuth.currentUser!.isAnonymous) {
      navigatorKey.currentState?.pushReplacementNamed('register');
      Fluttertoast.showToast(msg: 'Please sign in first');
    } else {
      await firestore.collection('products').doc(product.id).update({
        'favorites': product.favorites!.contains(firebaseAuth.currentUser!.uid)
            ? FieldValue.arrayRemove([firebaseAuth.currentUser!.uid])
            : FieldValue.arrayUnion([firebaseAuth.currentUser!.uid])
      });
    }
  }
}
