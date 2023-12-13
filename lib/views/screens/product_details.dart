import 'package:cached_network_image/cached_network_image.dart';
import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/screens/user_screen.dart';
import 'package:darleyexpress/views/widgets/counter.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool favorite = false;
  final PageController _pageController = PageController();
  int _activePage = 0, count = 1;

  @override
  void initState() {
    favorite =
        widget.product.favorites!.contains(firebaseAuth.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                children: [
                  Text('total'.tr(context)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${'AED'.tr(context)} ${(count * widget.product.price).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Counter(
                    remove: () {
                      setState(() {
                        count--;
                      });
                    },
                    other: () {},
                    add: () {
                      if (count < widget.product.stock) {
                        setState(() {
                          count++;
                        });
                      }
                    },
                    count: count,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      userCubit.addToCart(widget.product, count);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 50,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ),
            leadingWidth: 55,
            pinned: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: InkWell(
                    onTap: () async {
                      staticFunctions.shareData(widget.product.link);
                    },
                    child: Icon(
                      Icons.ios_share,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: StreamBuilder(
                      stream: firestore
                          .collection('products')
                          .doc(widget.product.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          ProductModel product = ProductModel.fromJson(
                              snapshot.data!.data() as Map);
                          return IconButton(
                            icon: Icon(
                              product.favorites!
                                      .contains(firebaseAuth.currentUser!.uid)
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
                            widget.product.favorites!
                                    .contains(firebaseAuth.currentUser!.uid)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                            size: 18,
                          ),
                          onPressed: () async {
                            await userCubit.favoriteStatus(widget.product);
                          },
                        );
                      }),
                ),
              )
            ],
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                  child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _activePage = page;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.media!.length,
                    itemBuilder: (context, index) => CachedNetworkImage(
                      imageUrl: widget.product.media![index],
                      width: dWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                          widget.product.media!.length,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: InkWell(
                                  onTap: () {
                                    _pageController.animateToPage(index,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn);
                                  },
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: _activePage == index
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                ),
                              )),
                    ),
                  ),
                ],
              )),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Text(
                widget.product.titleEn,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'AED'.tr(context)} ${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        decoration: widget.product.discount != 0
                            ? TextDecoration.lineThrough
                            : null),
                  ),
                  if (widget.product.discount != 0)
                    Text(
                      '${'AED'.tr(context)} ${(widget.product.price - (widget.product.price * (widget.product.discount / 100))).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (widget.product.descriptionEn.isNotEmpty)
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.product.descriptionEn,
                style: const TextStyle(fontSize: 16),
              ),
            ])),
          )
        ],
      ),
    );
  }
}
