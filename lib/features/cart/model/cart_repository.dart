// lib/features/cart/model/cart_repository.dart

import '../../home/model/product_model.dart';
import 'cart_model.dart';

abstract class CartsRepository {
  Future<List<CartModel>> getCarts(String userId);

  Future<void> createCart({
    required String userId,
    required String name,
  });

  Future<void> addProductToCart({
    required String cartId,
    required Product product,
  });

  Future<void> removeProductFromCart({
    required String cartId,
    required int productId,
  });

  Future<void> updateQuantity({
    required String cartId,
    required Product product,
    required bool increment,
  });

  Future<void> addCollaborator({
    required String cartId,
    required CartCollaborator collaborator,
  });

  Future<void> removeCollaborator({
    required String cartId,
    required String collaboratorId,
  });
}
