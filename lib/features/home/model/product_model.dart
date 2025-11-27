class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final num discountPercentage;
  final num rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;
  final int qty;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    this.qty = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()) ?? 0,

      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      discountPercentage: json["discountPercentage"] ?? 0,
      rating: json["rating"] ?? 0,
      stock: json["stock"] ?? 0,
      brand: json["brand"] ?? "",
      category: json["category"] ?? "",
      thumbnail: json["thumbnail"] ?? "",

      images: json["images"] != null
          ? List<String>.from(json["images"])
          : [],

      qty: json["qty"] ?? 1,  // 🔥 Firestore qty or default
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "price": price,
      "discountPercentage": discountPercentage,
      "rating": rating,
      "stock": stock,
      "brand": brand,
      "category": category,
      "thumbnail": thumbnail,
      "images": images,
      "qty": qty,
    };
  }

  Product copyWith({
    int? qty,
  }) {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      brand: brand,
      category: category,
      thumbnail: thumbnail,
      images: images,
      qty: qty ?? this.qty,
    );
  }
}
