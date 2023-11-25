import 'package:cached_network_image/cached_network_image.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/models/cart_model.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:darleyexpress/views/widgets/counter.dart';
import 'package:darleyexpress/views/widgets/remove_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Container(
            width: dWidth,
            height: dHeight,
            color: Colors.white,
            child: Center(
              child: userCubit.cartList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/empty_cart.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(fontWeight: FontWeight.w500),
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'AED ${cart.productData!.price}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Counter(
                                    remove: () {
                                      userCubit.addToCart(
                                          cart.productData!, -1);
                                    },
                                    add: () {
                                      userCubit.addToCart(cart.productData!, 1);
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
                            ),
                          ),
                        );
                      }),
            ));
      },
    );
  }
}
