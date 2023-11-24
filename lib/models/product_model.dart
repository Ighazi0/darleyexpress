class ProductModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final int stock;
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
      this.discount = 0.0,
      this.media,
      this.extra,
      this.mainCategory = '',
      this.category = ''});

  factory ProductModel.fromJson(Map json) {
    return ProductModel(
        titleEn: json['titleEn'] ?? '',
        titleAr: json['titleAr'] ?? '',
        id: json['id'] ?? '',
        timestamp: json['timestamp'] ?? DateTime.now(),
        link: json['link'] ?? '',
        category: json['category'] ?? '',
        mainCategory: json['mainCategory'] ?? '',
        media: json['media'] ?? [],
        discount: json['discount'] ?? 0.0,
        stock: json['stock'] ?? 0,
        price: json['price'] ?? 0.0,
        descriptionAr: json['descriptionAr'] ?? '',
        descriptionEn: json['descriptionEn'] ?? '',
        favorites: json['favorites'] ?? []);
  }
}
