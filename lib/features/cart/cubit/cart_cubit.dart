import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/firebase_service.dart';
import '../model/cart_model.dart';
import '../../home/model/product_model.dart';
import 'cart_state.dart';

class CartsCubit extends Cubit<CartsState> {
  final FirebaseService firebase;

  CartsCubit(this.firebase) : super(CartsInitial()) {
    _listen();
  }

  // 🔵 Listen to all user carts in real-time
  void _listen() {
    emit(CartsLoading());

    firebase.streamCarts().listen((carts) {
      emit(CartsLoaded(carts));
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
  /*
  Stream<CartModel?> streamCart(String cartId) {
    return FirebaseFirestore.instance
        .collection("carts")
        .doc(cartId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return CartModel.fromMap({...doc.data()!, "id": doc.id});
    });
  }*/
  // carts_cubit.dart

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
}
