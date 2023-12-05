import 'package:darleyexpress/controller/app_localization.dart';
import 'package:darleyexpress/controller/my_app.dart';
import 'package:darleyexpress/models/order_model.dart';
import 'package:darleyexpress/views/screens/order_details.dart';
import 'package:darleyexpress/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
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
        title: 'myOrders'.tr(context),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: firestore
              .collection('orders')
              .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderModel> data = snapshot.data!.docs
                  .map((e) => OrderModel.fromJson(e.data()))
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
                      title: Text('${'orderNo'.tr(context)}#${order.number}'),
                      subtitle: Text(
                          DateFormat('dd/MM/yyyy hh:mm a', locale.locale)
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
