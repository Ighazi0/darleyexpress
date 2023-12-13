import 'package:cached_network_image/cached_network_image.dart';
import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/models/cart_model.dart';
import 'package:darleyexpress/views/screens/product_details.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:darleyexpress/views/widgets/counter.dart';
import 'package:darleyexpress/views/widgets/remove_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool showBottom = true, end = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
            bottomNavigationBar: userCubit.cartList.isEmpty
                ? null
                : AnimatedContainer(
                    width: dWidth,
                    onEnd: () {
                      if (showBottom) {
                        setState(() {
                          end = true;
                        });
                      } else {
                        setState(() {
                          end = false;
                        });
                      }
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    duration: const Duration(milliseconds: 250),
                    height: showBottom ? 135 : 85,
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 0.5,
                              spreadRadius: 0.5)
                        ],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  showBottom = !showBottom;
                                });
                              },
                              child: Icon(showBottom
                                  ? Icons.expand_more
                                  : Icons.expand_less)),
                          if (showBottom && end)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${'subtotal'.tr(context)}${' (${userCubit.totalCartCount()} ' 'items'.tr(context)})'),
                                Text(
                                  '${'AED'.tr(context)} ${userCubit.totalCartPrice().toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          if (showBottom && end)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('deliveryFee'.tr(context)),
                                Text(
                                  '${'AED'.tr(context)} 25 ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: MaterialButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              onPressed: () {
                                if (firebaseAuth.currentUser!.isAnonymous) {
                                  navigatorKey.currentState
                                      ?.pushReplacementNamed('register');
                                  Fluttertoast.showToast(
                                      msg: 'pleaseFirst'.tr(context));
                                } else {
                                  Navigator.pushNamed(context, 'checkout');
                                }
                              },
                              height: 45,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              color: primaryColor,
                              textColor: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${'AED'.tr(context)} ${(userCubit.totalCartPrice() + 25.0).toStringAsFixed(2)}'),
                                  Text('CHECKOUT'.tr(context)),
                                ],
                              ),
                            ),
                          )
                        ]),
                  ),
            body: Container(
                width: dWidth,
                height: dHeight,
                color: Colors.white,
                child: Center(
                  child: userCubit.cartList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty_cart.png',
                              height: 150,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'emptyCart'.tr(context),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      : ListView.separated(
                          itemCount: userCubit.cartList.length,
                          separatorBuilder: (context, index) => const Divider(
                                height: 0,
                              ),
                          itemBuilder: (context, index) {
                            CartModel cart =
                                userCubit.cartList.values.toList()[index];
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                staticWidgets.showBottom(
                                    context,
                                    BottomSheetRemoveCart(
                                      index: index,
                                    ),
                                    0.4,
                                    0.5);
                                return false;
                              },
                              onDismissed: (direction) async {},
                              key: UniqueKey(),
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                ),
                                padding: const EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade900,
                                ),
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                              product: cart.productData!),
                                        ));
                                  },
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: cart.productData!.media![0],
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    locale.locale == 'ar'
                                        ? cart.productData!.titleAr
                                        : cart.productData!.titleEn,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  visualDensity:
                                      const VisualDensity(vertical: 4),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (cart.productData!.discount != 0)
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${'AED'.tr(context)} ${cart.productData!.price}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                decoration: cart.productData!
                                                            .discount !=
                                                        0
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Counter(
                                            remove: () {
                                              userCubit.addToCart(
                                                  cart.productData!, -1);
                                            },
                                            add: () {
                                              userCubit.addToCart(
                                                  cart.productData!, 1);
                                            },
                                            other: () {
                                              staticWidgets.showBottom(
                                                  context,
                                                  BottomSheetRemoveCart(
                                                    index: index,
                                                  ),
                                                  0.4,
                                                  0.5);
                                            },
                                            count: cart.count,
                                          )
                                        ],
                                      ),
                                      if (cart.productData!.discount != 0)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Text(
                                            '${'AED'.tr(context)} ${(cart.productData!.price - (cart.productData!.price * (cart.productData!.discount / 100))).toStringAsFixed(2)}',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                )));
      },
    );
  }
}
