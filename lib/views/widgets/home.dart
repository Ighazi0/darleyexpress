import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/controller/user_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/banner_model.dart';
import 'package:darleyexpress/models/category_model.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/screens/category_screen.dart';
import 'package:darleyexpress/views/widgets/categories_bottom_sheet.dart';
import 'package:darleyexpress/views/widgets/network_image.dart';
import 'package:darleyexpress/views/widgets/product_tile.dart';
import 'package:darleyexpress/views/widgets/shimmer.dart';
import 'package:darleyexpress/views/widgets/user_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController scrollController = ScrollController();
  Timer? _scrollingTimer;
  bool scroll = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    _scrollingTimer?.cancel();
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      scroll = false;
    } else {
      scroll = true;
    }

    _scrollingTimer = Timer(const Duration(milliseconds: 150), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: UserAppBar(
          scroll: scroll,
        ),
        body: GetBuilder(
          init: UserController(),
          builder: (userCubit) {
            return userCubit.search.text.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: FutureBuilder(
                      future: firestore.collection('products').get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<ProductModel> data = snapshot.data!.docs
                              .map((doc) => ProductModel.fromJson(doc.data()))
                              .toList();

                          Iterable result = data.where((element) =>
                              element.titleEn
                                  .toLowerCase()
                                  .contains(userCubit.search.text) ||
                              element.titleAr.contains(userCubit.search.text));
                          if (result.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/empty_data.png',
                                    height: 150,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'noProducts'.tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
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
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                ProductModel product = result.toList()[index];
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
                                    product: ProductModel(
                                        favorites: [], media: []))));
                      },
                    ),
                  )
                : RefreshIndicator(
                    color: appConstant.primaryColor,
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView(controller: scrollController, children: [
                      FutureBuilder(
                        future: firestore.collection('banners').get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<BannerModel> data = snapshot.data!.docs
                                .map((doc) => BannerModel.fromJson(doc.data()))
                                .toList();
                            if (data.isEmpty) {
                              return const SizedBox();
                            }
                            return CarouselSlider(
                              options: CarouselOptions(
                                  autoPlay: true,
                                  height: 175,
                                  viewportFraction: 0.95,
                                  enlargeCenterPage: true,
                                  autoPlayInterval:
                                      const Duration(seconds: 30)),
                              items: data.map((i) {
                                return Container(
                                  width: Get.width,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      child: NImage(
                                        url: i.url,
                                        h: 175,
                                        w: Get.width,
                                        fit: BoxFit.fitWidth,
                                      )),
                                );
                              }).toList(),
                            );
                          }
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: 175,
                              viewportFraction: 0.95,
                              enlargeCenterPage: true,
                            ),
                            items: [1].map((i) {
                              return Shimmers(
                                child: Container(
                                  width: Get.width,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: const BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              'category'.tr,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () async {
                                staticWidgets.showBottom(context,
                                    const BottomSheetCategories(), 0.75, 0.9);
                              },
                              style: ButtonStyle(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.amber.shade50)),
                              child: Text('seeAll'.tr,
                                  style: TextStyle(
                                      color: appConstant.primaryColor,
                                      fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: firestore.collection('categories').get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<CategoryModel> data = snapshot.data!.docs
                                .map(
                                    (doc) => CategoryModel.fromJson(doc.data()))
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
                                              builder: (context) =>
                                                  CategoryScreen(
                                                category: category,
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: SizedBox(
                                          width: 75,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 75,
                                                width: 75,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: appConstant
                                                          .primaryColor),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(100)),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    child: NImage(
                                                      url: category.url,
                                                      w: Get.width,
                                                      h: 75,
                                                    )),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                height: 20,
                                                child: Text(
                                                  Get.locale!.languageCode ==
                                                          'ar'
                                                      ? category.titleAr
                                                      : category.titleEn,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 35,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      decoration: const BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
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
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: FutureBuilder(
                          future: firestore.collection('products').get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<ProductModel> data = snapshot.data!.docs
                                  .map((doc) =>
                                      ProductModel.fromJson(doc.data()))
                                  .toList();
                              if (data.isEmpty) {
                                return const SizedBox();
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
                                        product: ProductModel(
                                            favorites: [], media: []))));
                          },
                        ),
                      )
                    ]),
                  );
          },
        ));
  }
}
