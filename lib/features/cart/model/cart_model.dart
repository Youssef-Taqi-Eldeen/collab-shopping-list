import '../../home/model/product_model.dart';

class CartCollaborator {
  final String id;
  final String name;
  final String email;

  CartCollaborator({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
    };
  }

  factory CartCollaborator.fromMap(Map<String, dynamic> map) {
    return CartCollaborator(
      id: map["id"],
      name: map["name"],
      email: map["email"],
    );
  }
}

class CartModel {
  final String id;
  final String name;
  final String ownerId;
  final List<Product> products;
  final List<CartCollaborator> collaborators;

  CartModel({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.products,
    required this.collaborators,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "ownerId": ownerId,
      "products": products.map((e) => e.toJson()).toList(),
      "collaborators": collaborators.map((e) => e.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map["id"],
      name: map["name"],
      ownerId: map["ownerId"],
      products: (map["products"] as List)
          .map((p) => Product.fromJson(p))
          .toList(),
      collaborators: (map["collaborators"] as List)
          .map((c) => CartCollaborator.fromMap(c))
          .toList(),
    );
  }

  CartModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    List<Product>? products,
    List<CartCollaborator>? collaborators,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      products: products ?? this.products,
      collaborators: collaborators ?? this.collaborators,
    );
  }
}
