import 'package:cached_network_image/cached_network_image.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/cubit/user_cubit.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/screens/product_details.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                margin: const EdgeInsets.only(bottom: 5),
                height: 200,
                child: GridTile(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: Colors.white,
                            child: StreamBuilder(
                                stream: firestore
                                    .collection('products')
                                    .doc(widget.product.id)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    ProductModel product =
                                        ProductModel.fromJson(
                                            snapshot.data!.data() as Map);
                                    return IconButton(
                                      icon: Icon(
                                        product.favorites!.contains(
                                                firebaseAuth.currentUser!.uid)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      onPressed: () async {
                                        await userCubit.favoriteStatus(product);
                                      },
                                    );
                                  }

                                  return IconButton(
                                    icon: Icon(
                                      widget.product.favorites!.contains(
                                              firebaseAuth.currentUser!.uid)
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
                                }),
                          ),
                        ),
                      ],
                    ),
                    footer: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.amber,
                                size: 18,
                              ),
                              onPressed: () {
                                userCubit.addToCart(widget.product, 1);
                              },
                            ),
                          ),
                        ),
                      ],
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
                              child: CachedNetworkImage(
                                imageUrl: widget.product.media![0],
                                fit: BoxFit.fill,
                              ))
                          : const SizedBox(),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                child: Text(
                  widget.product.titleEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  children: [
                    Text('AED ${widget.product.price.toStringAsFixed(2)}'),
                    const Spacer(),
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('5.0'),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
