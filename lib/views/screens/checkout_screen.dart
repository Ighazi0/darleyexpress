import 'package:cached_network_image/cached_network_image.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/cart_model.dart';
import 'package:darleyexpress/models/coupon_model.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                        'Total: '
                        'AED ${(userCubit.totalCartPrice() + 25.0).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: couponData.id.isNotEmpty
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      Text(
                        'AED ${(userCubit.totalCartPrice() - ((userCubit.totalCartPrice() * couponData.discount) / 100) + 25.0).toStringAsFixed(2)} ',
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
                            setState(() {
                              makeOrder = true;
                            });
                            await staticFunctions.makePayment(
                                (userCubit.totalCartPrice() + 25.0));
                            setState(() {
                              makeOrder = false;
                            });
                          },
                          height: 45,
                          minWidth: 150,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          color: primaryColor,
                          textColor: Colors.white,
                          child: const Text('Place order'),
                        ),
                ])),
      ),
      appBar: const AppBarCustom(
        title: 'CHECKOUT',
        action: {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shipping address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                      'Add new address',
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
                    title: Text(auth.userData.address!.first['name']),
                    subtitle: Text(auth.userData.address!.first['address']),
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
                        'Change',
                        style: TextStyle(
                            fontSize: 12, color: Colors.amber.shade700),
                      ),
                    ),
                  ),
            const Divider(
              color: Colors.grey,
            ),
            const Text(
              'Do you have promo code?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                      decoration: const InputDecoration(
                          hintText: 'Promo code',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15)),
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
                                            msg: 'Promo code expired');
                                        couponData = CouponModel();
                                      }
                                    } else {
                                      couponData = CouponModel();
                                      Fluttertoast.showToast(
                                          msg: 'No code found');
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
                            child: const Text('Apply'),
                          ),
                  )
                ],
              ),
            ),
            if (couponData.id.isNotEmpty)
              ListTile(
                title: Text(couponData.titleEn),
                trailing: Text('${couponData.discount}%'),
                subtitle:
                    Text(' up to ${couponData.max.toStringAsFixed(2)} AED'),
              ),
            const Divider(
              color: Colors.grey,
            ),
            const Text(
              'Order list',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                    title: Text(
                      cart.productData!.titleEn,
                      overflow: TextOverflow.ellipsis,
                    ),
                    visualDensity: const VisualDensity(vertical: 4),
                    subtitle: Text(
                      'AED ${cart.productData!.price}',
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
