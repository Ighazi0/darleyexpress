import 'package:cached_network_image/cached_network_image.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/category_model.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/screens/sub_category_screen.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:darleyexpress/views/widgets/product_tile.dart';
import 'package:darleyexpress/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});
  final CategoryModel category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: Get.locale!.languageCode == 'ar'
            ? widget.category.titleAr
            : widget.category.titleEn,
        action: const {},
      ),
      body: RefreshIndicator(
        color: appConstant.primaryColor,
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: firestore
                  .collection('categories')
                  .doc(widget.category.id)
                  .collection('categories')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CategoryModel> data = snapshot.data!.docs
                      .map((doc) => CategoryModel.fromJson(doc.data()))
                      .toList();
                  if (data.isEmpty) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    height: 100,
                    width: Get.width,
                    child: ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          CategoryModel category = data[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubCategoryScreen(
                                      category: category,
                                    ),
                                  ));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                width: 75,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 75,
                                      width: 75,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: appConstant.primaryColor),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                        child: CachedNetworkImage(
                                          imageUrl: category.url,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      height: 20,
                                      child: Text(
                                        Get.locale!.languageCode == 'ar'
                                            ? category.titleAr
                                            : category.titleEn,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                }
                return SizedBox(
                  height: 100,
                  width: Get.width,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Shimmers(
                        child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 35,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: const BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            height: 20,
                            width: 20,
                          )
                        ],
                      ),
                    )),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: FutureBuilder(
                future: firestore
                    .collection('products')
                    .where('mainCategory', isEqualTo: widget.category.id)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ProductModel> data = snapshot.data!.docs
                        .map((doc) => ProductModel.fromJson(
                              doc.data(),
                            ))
                        .toList();
                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset('assets/images/empty_pro.png'),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'noProducts'.tr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.65),
                      itemCount: 6,
                      itemBuilder: (context, index) => Shimmers(
                          child: ProductTile(
                              product:
                                  ProductModel(favorites: [], media: []))));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
