class ProductModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final int stock;
  final int seller;
  final DateTime? timestamp;
  final String link;
  final List? favorites;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final double discount;
  final List? media;
  final String category;
  final String mainCategory;
  final List? extra;

  ProductModel(
      {this.id = '',
      this.titleEn = '',
      this.titleAr = '',
      this.timestamp,
      this.favorites,
      this.link = '',
      this.descriptionAr = '',
      this.descriptionEn = '',
      this.price = 0.0,
      this.stock = 0,
      this.seller = 0,
      this.discount = 0.0,
      this.media,
      this.extra,
      this.mainCategory = '',
      this.category = ''});

  factory ProductModel.fromJson(Map json) {
    return ProductModel(
        titleEn: json['titleEn'] ?? '',
        titleAr: json['titleAr'] ?? '',
        id: json['id'],
        timestamp: json['timestamp'] == null
            ? DateTime.now()
            : json['timestamp'].toDate(),
        link: json['link'] ?? '',
        category: json['category'] ?? '',
        mainCategory: json['mainCategory'] ?? '',
        media: json['media'] ?? [],
        discount: double.parse(
            json['discount'] == null ? '0' : json['discount'].toString()),
        stock: json['stock'] ?? 0,
        seller: json['seller'] ?? 0,
        price: double.parse(json['price'].toString()),
        descriptionAr: json['descriptionAr'] ?? '',
        descriptionEn: json['descriptionEn'] ?? '',
        favorites: json['favorites'] ?? []);
  }
}
