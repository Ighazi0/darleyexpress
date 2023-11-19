import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/banner_model.dart';
import 'package:darleyexpress/models/category_model.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(children: [
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
                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 30)),
                  items: data.map((i) {
                    return Container(
                      width: dWidth,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: i.url,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Shimmers(
                              child: Container(
                            height: 175,
                            width: dWidth,
                            color: Colors.orangeAccent,
                          )),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
              return CarouselSlider(
                options: CarouselOptions(
                  height: 175,
                  enlargeCenterPage: true,
                ),
                items: [1, 2].map((i) {
                  return Shimmers(
                    child: Container(
                      width: dWidth,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
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
                  'category'.tr(context),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {},
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.amber.shade50)),
                  child: Text('seeAll'.tr(context),
                      style: TextStyle(color: primaryColor, fontSize: 12)),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: firestore.collection('categories').get(),
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
                  width: dWidth,
                  child: ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                          width: 75,
                          child: Column(
                            children: [
                              Container(
                                height: 75,
                                width: 75,
                                decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: CachedNetworkImage(
                                    imageUrl: data[index].url,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                height: 20,
                                child: Text(
                                  data[index].titleEn,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 100,
                width: dWidth,
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
              future: firestore.collection('products').get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ProductModel> data = snapshot.data!.docs
                      .map((doc) => ProductModel.fromJson(doc.data()))
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
                      itemBuilder: (context, index) => Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.5),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
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
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 18,
                                              ),
                                              onPressed: () {},
                                            ),
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
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      height: 100,
                                      width: 100,
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          child: CachedNetworkImage(
                                            imageUrl: data[index].media![0],
                                            fit: BoxFit.fill,
                                          )),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 5),
                                child: Text(
                                  data[index].titleEn,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Row(
                                  children: [
                                    Text(
                                        'AED ${data[index].price.toStringAsFixed(2)}'),
                                    const Spacer(),
                                    const Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text('4.9'),
                                  ],
                                ),
                              )
                            ],
                          ));
                }
                return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => Shimmers(
                            child: GridTile(
                                child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.amber,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 100,
                          width: 100,
                        ))));
              },
            ),
          )
        ]),
      ),
    );
  }
}
