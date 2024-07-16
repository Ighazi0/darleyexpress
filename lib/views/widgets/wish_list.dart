import 'package:darleyexpress/controller/user_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/widgets/product_tile.dart';
import 'package:darleyexpress/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserController(),
      builder: (context) {
        return Container(
            height: Get.height,
            width: Get.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: RefreshIndicator(
                color: appConstant.primaryColor,
                onRefresh: () async {
                  setState(() {});
                },
                child: FutureBuilder(
                  future: firestore.collection('products').where('favorites',
                      arrayContainsAny: [
                        firebaseAuth.currentUser?.uid ?? ''
                      ]).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<ProductModel> data = snapshot.data!.docs
                          .map((doc) => ProductModel.fromJson(doc.data()))
                          .toList();
                      if (data.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/empty_fav.png',
                                height: 150,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'noFavorites'.tr,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.65),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            ProductModel product = data[index];
                            return ProductTile(product: product);
                          });
                    }
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) => Shimmers(
                            child: ProductTile(
                                product:
                                    ProductModel(favorites: [], media: []))));
                  },
                ),
              ),
            ));
      },
    );
  }
}
