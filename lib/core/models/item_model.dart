class ItemModel {
  final String id;
  final String name;
  final bool isChecked;
  final String? productId;
  final double? price;
  final int quantity;
  final String? imageUrl;

  ItemModel({
    required this.id,
    required this.name,
    required this.isChecked,
    this.productId,
    this.price,
    this.quantity = 1,
    this.imageUrl,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isChecked: map['isChecked'] ?? false,
      productId: map['productId'],
      price: map['price']?.toDouble(),
      quantity: map['quantity'] ?? 1,
      imageUrl: map['imageUrl'],
    );
  }

  factory ItemModel.fromFirestore(Map<String, dynamic> json, String id) {
    return ItemModel(
      id: id,
      name: json['name'] ?? '',
      isChecked: json['isChecked'] ?? false,
      productId: json['productId'],
      price: json['price']?.toDouble(),
      quantity: json['quantity'] ?? 1,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isChecked': isChecked,
      'quantity': quantity,
      if (productId != null) 'productId': productId,
      if (price != null) 'price': price,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  ItemModel copyWith({
    String? id,
    String? name,
    bool? isChecked,
    String? productId,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isChecked: isChecked ?? this.isChecked,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

