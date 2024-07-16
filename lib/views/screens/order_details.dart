import 'package:cached_network_image/cached_network_image.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/order_model.dart';
import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/views/screens/product_details.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:darleyexpress/views/widgets/bottom_sheet_status.dart';
import 'package:darleyexpress/views/widgets/review_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.order});
  final OrderModel order;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderModel order = OrderModel();

  fetch() async {
    await firestore.collection('orders').doc(order.id).get().then((value) {
      order = OrderModel.fromJson(value.data() as Map, order.id);
      setState(() {});
    });
  }

  @override
  void initState() {
    order = widget.order;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        action: order.status != 'complete' &&
                firebaseAuth.currentUser!.uid == staticData.adminUID
            ? {
                'icon': Icons.edit,
                'function': () async {
                  await staticWidgets.showBottom(
                      context, BottomSheetStatus(order: order), 0.4, 0.5);
                  fetch();
                }
              }
            : !order.rated &&
                    order.status == 'complete' &&
                    firebaseAuth.currentUser!.uid != staticData.adminUID
                ? {
                    'icon': Icons.star,
                    'function': () async {
                      await staticWidgets.showBottom(
                          context,
                          BottomSheetReview(
                            id: order.timestamp!.millisecondsSinceEpoch
                                .toString(),
                          ),
                          0.5,
                          0.75);
                      fetch();
                    }
                  }
                : {},
        title: '#${order.number}',
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 135,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'subtotal'.tr}:'),
                    Text(
                      '${'AED'.tr} ${order.total.toStringAsFixed(2)}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'deliveryFee'.tr}:'),
                    Text(
                      '${'AED'.tr} ${order.delivery}',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'discount'.tr}:'),
                    Text(
                      '${order.discount}%',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'total'.tr}:'),
                    Text(
                      '${'AED'.tr} ${(order.total - (order.total * (order.discount / 100)) + order.delivery).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ],
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
        ),
        child: RefreshIndicator(
          color: appConstant.primaryColor,
          onRefresh: () async {
            fetch();
          },
          child: ListView(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('orderNumber'.tr), Text(order.number.toString())],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('name'.tr), Text(order.name)],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('phone'.tr), Text(order.addressData!.phone)],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('address'.tr), Text(order.addressData!.address)],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('orderT&D'.tr),
                Text(DateFormat('dd/MM/yyyy hh:mm a').format(order.timestamp!))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('status'.tr), Text(order.status.tr)],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Text(
              'orderList'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const Divider(),
              itemCount: order.orderList!.length,
              itemBuilder: (context, index) {
                ProductModel orderList = order.orderList![index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: orderList.media![0],
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () async {
                    await firestore
                        .collection('products')
                        .doc(orderList.id)
                        .get()
                        .then((value) {
                      if (value.exists) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                  product: ProductModel.fromJson(
                                      value.data() as Map)),
                            ));
                      }
                    });
                  },
                  title: Text(
                    Get.locale!.languageCode == 'ar'
                        ? orderList.titleAr
                        : orderList.titleEn,
                    overflow: TextOverflow.ellipsis,
                  ),
                  visualDensity: const VisualDensity(vertical: 4),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${'AED'.tr} ${orderList.price}',
                        style: TextStyle(
                            decoration: orderList.discount != 0
                                ? TextDecoration.lineThrough
                                : null,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      if (orderList.discount != 0)
                        Text(
                          '${'AED'.tr} ${(orderList.price - (orderList.price * (orderList.discount / 100))).toStringAsFixed(2)}',
                        ),
                    ],
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
