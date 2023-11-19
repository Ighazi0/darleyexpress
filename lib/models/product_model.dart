class ProductModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final String url;
  final DateTime? timestamp;
  final String link;
  final List? favorites;
  final String description;
  final double price;
  final double discount;
  final List? media;
  final String category;
  final List? extra;

  ProductModel(
      {this.id = '',
      this.titleEn = '',
      this.titleAr = '',
      this.url = '',
      this.timestamp,
      this.favorites,
      this.link = '',
      this.description = '',
      this.price = 0.0,
      this.discount = 0.0,
      this.media,
      this.extra,
      this.category = ''});

  factory ProductModel.fromJson(Map json) {
    return ProductModel(
        titleEn: json['titleEn'] ?? '',
        titleAr: json['titleAr'] ?? '',
        id: json['id'] ?? '',
        url: json['url'] ?? '',
        timestamp: json['timestamp'] ?? DateTime.now(),
        link: json['link'] ?? '',
        category: json['category'] ?? '',
        media: json['media'] ?? [],
        discount: json['discount'] ?? 0.0,
        price: json['price'] ?? 0.0,
        description: json['description'] ?? '',
        favorites: json['favorites'] ?? []);
  }
}
