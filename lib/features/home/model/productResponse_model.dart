import 'product_model.dart';

class ProductsResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductsResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      products: (json["products"] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      total: json["total"],
      skip: json["skip"],
      limit: json["limit"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "products": products.map((p) => p.toJson()).toList(),
      "total": total,
      "skip": skip,
      "limit": limit,
    };
  }
}