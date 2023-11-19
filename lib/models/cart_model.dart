class CartModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final String code;
  final double discount;
  final double max;
  final DateTime? timestamp;
  final DateTime? endTime;
  final String link;

  CartModel(
      {this.id = '',
      this.titleEn = '',
      this.titleAr = '',
      this.code = '',
      this.timestamp,
      this.endTime,
      this.discount = 0.0,
      this.max = 0.0,
      this.link = ''});

  factory CartModel.fromJson(Map json) {
    return CartModel(
        titleEn: json['titleEn'] ?? '',
        titleAr: json['titleAr'] ?? '',
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        timestamp: json['timestamp'] ?? DateTime.now(),
        endTime: json['endTime'] ?? DateTime.now(),
        link: json['link'] ?? '',
        max: json['max'] ?? 0.0,
        discount: json['discount'] ?? 0.0);
  }
}
