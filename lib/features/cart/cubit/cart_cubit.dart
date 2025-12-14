import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firebase_service.dart';
import '../model/cart_model.dart';
import '../../home/model/product_model.dart';
import 'cart_state.dart';

class CartsCubit extends Cubit<CartsState> {
  final FirebaseService firebase;
  StreamSubscription? _cartsSubscription;
  StreamSubscription? _authSubscription;

  CartsCubit(this.firebase) : super(CartsInitial()) {
    // Listen to authentication changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        // User logged in, start listening to their carts
        _listen();
      } else {
        // User logged out, clear carts
        _cartsSubscription?.cancel();
        emit(CartsInitial());
      }
    });
  }

  @override
  Future<void> close() {
    _cartsSubscription?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }

  // 🔵 Listen to all user carts in real-time
  void _listen() {
    // Cancel any existing subscription
    _cartsSubscription?.cancel();
    
    emit(CartsLoading());

    _cartsSubscription = firebase.streamCarts().listen((carts) {
      emit(CartsLoaded(carts));
    }, onError: (error) {
      emit(CartsError(error.toString()));
    });
  }

  // 🔵 Get cart from current loaded state
  CartModel? getCart(String id) {
    if (state is! CartsLoaded) return null;
    final carts = (state as CartsLoaded).carts;
    try {
      return carts.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // 🔵 Listen to ONE cart live
  Stream<CartModel?> streamCart(String cartId) {
    return firebase.streamCart(cartId);
  }


  // 🔵 Create new cart
  Future<String> createCart(String name) async {
    final id = await firebase.createCart(name);
    return id;
  }

  // 🔵 Add product to cart
  Future<void> addProductToCart({
    required String cartId,
    required Product product,
  }) async {
    await firebase.addProductToCart(cartId: cartId, product: product);
  }

  // 🔵 Remove product (correct name now)
  Future<void> removeProductFromCart({
    required String cartId,
    required int productId,
  }) async {
    await firebase.removeProductFromCart(
      cartId: cartId,
      productId: productId,
    );
  }

  // 🔵 Update product quantity
  Future<void> updateQuantity({
    required String cartId,
    required Product product,
    required bool increment,
  }) async {
    await firebase.updateQuantity(
      cartId: cartId,
      product: product,
      increment: increment,
    );
  }

  // 🔵 Add collaborator (correct method name)
  Future<void> addCollaborator({
    required String cartId,
    required CartCollaborator collaborator,
  }) async {
    await firebase.addCollaboratorToCart(
      cartId: cartId,
      collaborator: collaborator,
    );
  }

  // 🔵 Remove collaborator (correct method name)
  Future<void> removeCollaborator({
    required String cartId,
    required String collaboratorId,
  }) async {
    await firebase.removeCollaborator(
      cartId: cartId,
      collaboratorId: collaboratorId,
    );
  }

  // 🔵 Delete Cart
  Future<void> deleteCart(String cartId) async {
    await firebase.deleteCart(cartId);
  }
}
