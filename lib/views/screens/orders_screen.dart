import 'package:darleyexpress/controller/auth_controller.dart';
import 'package:darleyexpress/get_initial.dart';
import 'package:darleyexpress/models/order_model.dart';
import 'package:darleyexpress/views/screens/order_details.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        action: const {},
        title: 'myOrders'.tr,
      ),
      body: RefreshIndicator(
        color: appConstant.primaryColor,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore
              .collection('orders')
              .where('uid', isEqualTo: Get.find<AuthController>().userData.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderModel> data = snapshot.data!.docs
                  .map((e) => OrderModel.fromJson(e.data(), e.id))
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
                        'No orders yet',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  OrderModel order = data[index];
                  return Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ListTile(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetails(order: order),
                            ));
                        setState(() {});
                      },
                      title: Text('${'orderNo'.tr}#${order.number}'),
                      subtitle: Text(DateFormat('dd/MM/yyyy hh:mm a')
                          .format(order.timestamp!)),
                      trailing: Icon(
                        order.status == 'inProgress'
                            ? Icons.pending
                            : order.status == 'cancel'
                                ? Icons.cancel
                                : order.status == 'inDelivery'
                                    ? Icons.delivery_dining
                                    : Icons.check_circle,
                        color: order.status == 'inProgress'
                            ? null
                            : order.status == 'cancel'
                                ? Colors.red
                                : order.status == 'inDelivery'
                                    ? Colors.amber
                                    : Colors.green,
                      ),
                    ),
                  );
                },
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
