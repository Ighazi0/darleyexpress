import 'package:cached_network_image/cached_network_image.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/category_model.dart';
import 'package:darleyexpress/views/screens/category_details.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminCategories extends StatefulWidget {
  const AdminCategories({super.key, required this.category});
  final CategoryModel category;

  @override
  State<AdminCategories> createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends State<AdminCategories> {
  TextEditingController search = TextEditingController();
  Iterable<CategoryModel> result = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: widget.category.titleEn, action: {
        'icon': Icons.add,
        'function': () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetails(
                  category: CategoryModel(titleEn: 'New Category'),
                  catId: widget.category.id,
                ),
              ));
          setState(() {});
        }
      }),
      body: RefreshIndicator(
        color: appConstant.primaryColor,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: widget.category.id.isEmpty
              ? firestore.collection('categories').get()
              : firestore
                  .collection('categories')
                  .doc(widget.category.id)
                  .collection('categories')
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<CategoryModel> data = snapshot.data!.docs
                  .map((e) => CategoryModel.fromJson(e.data()))
                  .toList();
              result = data.where((a) =>
                  a.titleEn.toLowerCase().contains(search.text.toLowerCase()) ||
                  a.titleAr.toLowerCase().contains(search.text.toLowerCase()));
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    CupertinoSearchTextField(
                      controller: search,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Expanded(
                      child: result.isEmpty
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.description,
                                  size: 100,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text('No data found')
                              ],
                            )
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: result.length,
                              itemBuilder: (context, index) {
                                CategoryModel category = result.toList()[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  leading: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: category.url,
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CategoryDetails(
                                            category: category,
                                            catId: widget.category.id,
                                          ),
                                        ));
                                    setState(() {});
                                  },
                                  title: Text(
                                    category.titleEn,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
