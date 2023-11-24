import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/category_model.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/widgets/product_tile.dart';
import 'package:darleyexpress/views/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key, required this.category});
  final CategoryModel category;

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category.titleEn),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: FutureBuilder(
            future: firestore
                .collection('products')
                .where('category', isEqualTo: widget.category.id)
                .get(),
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
                        Image.asset('assets/images/empty_pro.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'No products available',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  );
                }
                return GridView.builder(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.65),
                  itemCount: 6,
                  itemBuilder: (context, index) => Shimmers(
                      child: ProductTile(
                          product: ProductModel(favorites: [], media: []))));
            },
          ),
        ));
  }
}
