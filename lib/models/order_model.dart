import 'package:darleyexpress/models/product_model.dart';
import 'package:darleyexpress/models/user_model.dart';

class OrderModel {
  final int number;
  final String id;
  final String invoice;
  final String name;
  final String uid;
  final String status;
  final double total;
  final double discount;
  final double delivery;
  final bool rated;
  final DateTime? timestamp;
  final AddressModel? addressData;
  final WalletModel? walletData;
  final List<ProductModel>? orderList;

  OrderModel(
      {this.number = 0,
      this.total = 0,
      this.discount = 0,
      this.delivery = 0,
      this.timestamp,
      this.name = '',
      this.invoice = '',
      this.id = '',
      this.uid = '',
      this.status = '',
      this.rated = false,
      this.orderList,
      this.walletData,
      this.addressData});

  factory OrderModel.fromJson(Map data, String id) {
    List d = data['orderList'];
    return OrderModel(
        id: id,
        number: data['number'],
        invoice: data['invoice'] ?? '',
        name: data['name'],
        total: double.parse(data['total'].toString()),
        delivery: double.parse(data['delivery'].toString()),
        discount: double.parse(data['discount'].toString()),
        uid: data['uid'] ?? '',
        rated: data['rated'] ?? false,
        status: data['status'],
        timestamp: DateTime.parse(
            data['timestamp'] ?? DateTime.now().toIso8601String()),
        addressData: AddressModel.fromJson(data['addressData'] as Map),
        // walletData: WalletModel.fromJson(data['walletData'] as Map),
        orderList: d.map((e) => ProductModel.fromJson(e as Map)).toList());
  }
}
