import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/cart_model.dart';
import 'package:darleyexpress/models/coupon_model.dart';
import 'package:darleyexpress/models/order_model.dart';
import 'package:darleyexpress/views/screens/order_details.dart';
import 'package:darleyexpress/views/screens/product_details.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:darleyexpress/views/widgets/payment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool makeOrder = false, loading = false;
  CouponModel couponData = CouponModel();
  TextEditingController code = TextEditingController();

  ordering() async {
    Fluttertoast.showToast(msg: 'orderPlaced'.tr(context));
    var id = DateTime.now(), numbbers = 0;
    await firestore.collection('orders').get().then((value) {
      numbbers = value.size;
    });

    for (int i = 0; i < userCubit.cartList.entries.length; i++) {
      await firestore
          .collection('products')
          .doc(userCubit.cartList.entries.toList()[i].key)
          .update({
        'stock': FieldValue.increment(
            -userCubit.cartList.entries.toList()[i].value.count),
        'seller': FieldValue.increment(1)
      });
    }

    var data = {
      'number': numbbers + 1,
      'uid': firebaseAuth.currentUser!.uid,
      'total': userCubit.totalCartPrice(),
      'discount': couponData.discount,
      'delivery': 25,
      'rated': false,
      'status': 'inProgress',
      'name': auth.userData.name,
      'timestamp': id.toIso8601String(),
      'addressData': {
        'address': auth.userData.address!.first.address,
        'phone': auth.userData.address!.first.phone,
        'label': auth.userData.address!.first.label,
        'name': auth.userData.address!.first.name,
      },
      'walletData': {
        'number': CryptLib.instance.encryptPlainTextWithRandomIV(
            auth.userData.wallet!.first.number, "number"),
      },
      'orderList': userCubit.cartList.entries
          .map((e) => {
                'id': e.key,
                'titleEn': e.value.productData!.titleEn,
                'titleAr': e.value.productData!.titleAr,
                'price': e.value.productData!.price,
                'discount': e.value.productData!.discount,
                'media': [e.value.productData!.media!.first],
                'count': e.value.count,
              })
          .toList()
    };
    firestore
        .collection('orders')
        .doc(id.millisecondsSinceEpoch.toString())
        .set(data);
    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
      builder: (context) => OrderDetails(
          order:
              OrderModel.fromJson(data, id.millisecondsSinceEpoch.toString())),
    ));
    userCubit.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 0.5,
                    offset: const Offset(0, -2),
                  ),
                ],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${'total'.tr(context)}: ${'AED'.tr(context)} ${(userCubit.totalCartPrice() + 25).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: couponData.id.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      if (couponData.id.isNotEmpty)
                        Text(
                          '${'AED'.tr(context)} ${(userCubit.totalCartPrice() - ((userCubit.totalCartPrice() * (couponData.discount / 100)) > couponData.max ? couponData.max : (userCubit.totalCartPrice() * (couponData.discount / 100)))).toStringAsFixed(2)} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  makeOrder
                      ? const CircularProgressIndicator()
                      : MaterialButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          onPressed: () async {
                            if (auth.userData.address!.isNotEmpty) {
                              if (auth.userData.wallet!.isNotEmpty) {
                                setState(() {
                                  makeOrder = true;
                                });

                                await ordering();
                              } else {
                                staticWidgets.showBottom(context,
                                    const BottomSheetPayment(), 0.85, 0.9);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'pleaseAddress'.tr(context));
                            }
                          },
                          height: 45,
                          minWidth: 100,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          color: primaryColor,
                          textColor: Colors.white,
                          child: Text('placeOrder'.tr(context)),
                        ),
                ])),
      ),
      appBar: AppBarCustom(
        title: 'CHECKOUT'.tr(context),
        action: const {},
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'shipping'.tr(context),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            auth.userData.address!.isEmpty
                ? MaterialButton(
                    minWidth: 0,
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () async {
                      await Navigator.pushNamed(context, 'address');
                      setState(() {});
                    },
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      'addNew'.tr(context),
                      style:
                          TextStyle(fontSize: 12, color: Colors.amber.shade700),
                    ),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.location_on,
                      color: primaryColor,
                    ),
                    title: Text(auth.userData.address!.first.name),
                    subtitle: Text(auth.userData.address!.first.address),
                    trailing: MaterialButton(
                      minWidth: 0,
                      height: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () async {
                        await Navigator.pushNamed(context, 'address');
                        setState(() {});
                      },
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        'change'.tr(context),
                        style: TextStyle(
                            fontSize: 12, color: Colors.amber.shade700),
                      ),
                    ),
                  ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'havePromo'.tr(context),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: Colors.grey.shade200),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: code,
                      decoration: InputDecoration(
                          hintText: 'promo'.tr(context),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: loading
                        ? const CircularProgressIndicator()
                        : MaterialButton(
                            textColor: Colors.white,
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });

                              await firestore
                                  .collection('coupons')
                                  .where('code', whereIn: [
                                    code.text.toLowerCase(),
                                    code.text.toUpperCase()
                                  ])
                                  .get()
                                  .then((value) {
                                    if (value.size > 0) {
                                      couponData = CouponModel.fromJson(
                                          value.docs.first.data());

                                      if (couponData.endTime!
                                          .isBefore(DateTime.now())) {
                                        Fluttertoast.showToast(
                                            msg: 'expired'.tr(context));
                                        couponData = CouponModel();
                                      }
                                    } else {
                                      couponData = CouponModel();
                                      Fluttertoast.showToast(
                                          msg: 'noCode'.tr(context));
                                    }
                                  });
                              setState(() {
                                loading = false;
                              });
                            },
                            color: primaryColor,
                            height: 40,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Text('apply'.tr(context)),
                          ),
                  )
                ],
              ),
            ),
            if (couponData.id.isNotEmpty)
              ListTile(
                title: Text(couponData.titleEn),
                trailing: Text('${couponData.discount}%'),
                subtitle: Text(
                    '${'upTo'.tr(context)} ${couponData.max.toStringAsFixed(2)} ${'AED'.tr(context)}'),
              ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'orderList'.tr(context),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userCubit.cartList.length,
                itemBuilder: (context, index) {
                  CartModel cart = userCubit.cartList.values.toList()[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: cart.productData!.media![0],
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetails(product: cart.productData!),
                          ));
                    },
                    title: Text(
                      cart.productData!.titleEn,
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: const VisualDensity(vertical: 4),
                    subtitle: Text(
                      '${'AED'.tr(context)} ${cart.productData!.price}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
