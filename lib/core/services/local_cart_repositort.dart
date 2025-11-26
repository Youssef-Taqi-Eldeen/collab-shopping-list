// lib/core/services/local_cart_repositort.dart

import 'package:uuid/uuid.dart';

import '../../features/cart/model/cart_model.dart';
import '../../features/cart/model/cart_repository.dart';
import '../../features/home/model/product_model.dart';

class LocalCartsRepository implements CartsRepository {
  final List<CartModel> _carts = [];
  final Uuid _uuid = const Uuid();

  @override
  Future<List<CartModel>> getCarts(String userId) async {
    if (_carts.isEmpty) {
      _carts.addAll([
        CartModel(
          id: _uuid.v4(),
          name: "Groceries",
          ownerId: userId,
          products: [],
          collaborators: [],
        ),
        CartModel(
          id: _uuid.v4(),
          name: "Electronics",
          ownerId: userId,
          products: [],
          collaborators: [],
        ),
      ]);
    }

    // you can filter by owner if you want multi-user later
    return List<CartModel>.from(_carts.where((c) => c.ownerId == userId));
  }

  CartModel? _getCart(String cartId) {
    try {
      return _carts.firstWhere((c) => c.id == cartId);
    } catch (_) {
      return null;
    }
  }

  void _replaceCart(CartModel updated) {
    final index = _carts.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _carts[index] = updated;
    }
  }

  @override
  Future<void> createCart({
    required String userId,
    required String name,
  }) async {
    final newCart = CartModel(
      id: _uuid.v4(),
      name: name,
      ownerId: userId,
      products: [],
      collaborators: [],
    );
    _carts.add(newCart);
  }

  @override
  Future<void> addProductToCart({
    required String cartId,
    required Product product,
  }) async {
    final cart = _getCart(cartId);
    if (cart == null) return;

    final updatedProducts = List<Product>.from(cart.products);
    final existingIndex =
    updatedProducts.indexWhere((p) => p.id == product.id);

    if (existingIndex != -1) {
      final existing = updatedProducts[existingIndex];
      updatedProducts[existingIndex] =
      existing..qty = existing.qty + product.qty;
    } else {
      updatedProducts.add(product);
    }

    _replaceCart(cart.copyWith(products: updatedProducts));
  }

  @override
  Future<void> removeProductFromCart({
    required String cartId,
    required int productId,
  }) async {
    final cart = _getCart(cartId);
    if (cart == null) return;

    final updatedProducts =
    cart.products.where((p) => p.id != productId).toList();

    _replaceCart(cart.copyWith(products: updatedProducts));
  }

  @override
  Future<void> updateQuantity({
    required String cartId,
    required Product product,
    required bool increment,
  }) async {
    final cart = _getCart(cartId);
    if (cart == null) return;

    final updatedProducts = cart.products.map((p) {
      if (p.id == product.id) {
        final newQty = increment ? p.qty + 1 : (p.qty > 1 ? p.qty - 1 : 1);
        return Product(
          id: p.id,
          title: p.title,
          description: p.description,
          price: p.price,
          discountPercentage: p.discountPercentage,
          rating: p.rating,
          stock: p.stock,
          brand: p.brand,
          category: p.category,
          thumbnail: p.thumbnail,
          images: p.images,
          qty: newQty,
        );
      }
      return p;
    }).toList();

    _replaceCart(cart.copyWith(products: updatedProducts));
  }

  @override
  Future<void> addCollaborator({
    required String cartId,
    required CartCollaborator collaborator,
  }) async {
    final cart = _getCart(cartId);
    if (cart == null) return;

    final updatedCollaborators =
    List<CartCollaborator>.from(cart.collaborators)..add(collaborator);

    _replaceCart(cart.copyWith(collaborators: updatedCollaborators));
  }

  @override
  Future<void> removeCollaborator({
    required String cartId,
    required String collaboratorId,
  }) async {
    final cart = _getCart(cartId);
    if (cart == null) return;

    final updatedCollaborators = cart.collaborators
        .where((c) => c.id != collaboratorId)
        .toList();

    _replaceCart(cart.copyWith(collaborators: updatedCollaborators));
  }
}
