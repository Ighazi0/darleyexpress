import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/screens/product_details.dart';
import 'package:darleyexpress/views/screens/splash_screen.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:darleyexpress/views/widgets/counter.dart';
import 'package:darleyexpress/views/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(product: widget.product),
                ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.only(bottom: 5),
                height: 190,
                child: GridTile(
                    header: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        margin: const EdgeInsets.all(5),
                        child: auth.userData.uid.isNotEmpty
                            ? widget.product.id.isNotEmpty
                                ? StreamBuilder(
                                    stream: firestore
                                        .collection('products')
                                        .doc(widget.product.id)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.exists) {
                                          ProductModel product =
                                              ProductModel.fromJson(
                                                  snapshot.data!.data() as Map);
                                          return IconButton(
                                            icon: Icon(
                                              product.favorites!.contains(
                                                      auth.userData.uid)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                            onPressed: () async {
                                              await userCubit
                                                  .favoriteStatus(product);
                                            },
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      }

                                      return IconButton(
                                        icon: Icon(
                                          widget.product.favorites!
                                                  .contains(auth.userData.uid)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        onPressed: () async {
                                          await userCubit
                                              .favoriteStatus(widget.product);
                                        },
                                      );
                                    })
                                : IconButton(
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    onPressed: () async {
                                      await userCubit
                                          .favoriteStatus(widget.product);
                                    },
                                  )
                            : IconButton(
                                icon: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                onPressed: () async {
                                  await userCubit
                                      .favoriteStatus(widget.product);
                                },
                              ),
                      ),
                    ),
                    footer: widget.product.stock == 0
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: userCubit.cartList
                                      .containsKey(widget.product.id)
                                  ? 100
                                  : 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              margin: const EdgeInsets.all(5),
                              child: userCubit.cartList
                                      .containsKey(widget.product.id)
                                  ? FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Counter(
                                        remove: () {
                                          userCubit.addToCart(
                                              widget.product, -1);
                                        },
                                        add: () {
                                          if (userCubit
                                                  .cartList[widget.product.id]!
                                                  .count <
                                              widget.product.stock) {
                                            userCubit.addToCart(
                                                widget.product, 1);
                                          }
                                        },
                                        other: () {
                                          userCubit.removeFromCart(
                                              widget.product.id);
                                        },
                                        count: userCubit
                                            .cartList[widget.product.id]!.count,
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        BoxIcons.bx_cart_add,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        userCubit.addToCart(widget.product, 1);
                                      },
                                    ),
                            ),
                          ),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      height: 100,
                      width: 100,
                      child: widget.product.media!.isNotEmpty
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: NImage(
                                url: widget.product.media![0],
                                h: 100,
                                w: Get.width,
                              ))
                          : const SizedBox(),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: Text(
                  Get.locale!.languageCode == 'ar'
                      ? widget.product.titleAr
                      : widget.product.titleEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  children: [
                    Text(
                      '${'AED'.tr(context)} ${widget.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          decoration: widget.product.discount != 0
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                  ],
                ),
              ),
              if (widget.product.discount != 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Text(
                    '${'AED'.tr(context)} ${(widget.product.price - (widget.product.price * (widget.product.discount / 100))).toStringAsFixed(2)}',
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
