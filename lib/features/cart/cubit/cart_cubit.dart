// lib/features/cart/cubit/cart_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../home/model/product_model.dart';
import '../model/cart_model.dart';
import '../model/cart_repository.dart';
import 'cart_state.dart';

class CartsCubit extends Cubit<CartsState> {
  final CartsRepository repo;
  final String userId;

  CartsCubit(this.repo, this.userId) : super(CartsInitial());

  Future<void> loadCarts() async {
    emit(CartsLoading());
    try {
      final carts = await repo.getCarts(userId);
      emit(CartsLoaded(carts));
    } catch (_) {
      emit(CartsError("Failed to load carts"));
    }
  }

  CartModel? getCart(String id) {
    if (state is! CartsLoaded) return null;
    try {
      return (state as CartsLoaded).carts.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> createCart(String name) async {
    await repo.createCart(userId: userId, name: name);
    await loadCarts();
  }

  Future<void> addProductToCart({
    required String cartId,
    required Product product,
  }) async {
    await repo.addProductToCart(cartId: cartId, product: product);
    await loadCarts();
  }

  Future<void> removeProductFromCart({
    required String cartId,
    required int productId,
  }) async {
    await repo.removeProductFromCart(cartId: cartId, productId: productId);
    await loadCarts();
  }

  Future<void> updateQuantity({
    required String cartId,
    required Product product,
    required bool increment,
  }) async {
    await repo.updateQuantity(
      cartId: cartId,
      product: product,
      increment: increment,
    );
    await loadCarts();
  }

  Future<void> addCollaborator({
    required String cartId,
    required String name,
    required String email,
  }) async {
    final collaborator = CartCollaborator(
      id: const Uuid().v4(),
      name: name,
      email: email,
    );

    await repo.addCollaborator(
      cartId: cartId,
      collaborator: collaborator,
    );
    await loadCarts();
  }

  Future<void> removeCollaborator({
    required String cartId,
    required String collaboratorId,
  }) async {
    await repo.removeCollaborator(
      cartId: cartId,
      collaboratorId: collaboratorId,
    );
    await loadCarts();
  }
}
