import 'package:darleyexpress/models/product_model.dart';

class OrderModel {
  final ProductModel? productData;
  final int count;
  final int numbder;
  final String name;
  final String address;
  final String status;
  final double total;
  final double discount;
  final double delivery;
  final String link;
  final DateTime? timestamp;
  final List<ProductModel>? orderList;

  OrderModel(
      {this.productData,
      this.count = 0,
      this.numbder = 0,
      this.total = 0,
      this.discount = 0,
      this.delivery = 0,
      this.timestamp,
      this.name = '',
      this.address = '',
      this.status = '',
      this.orderList,
      this.link = ''});

  factory OrderModel.fromJson(ProductModel product, int c) {
    return OrderModel(productData: product, count: c);
  }
}
