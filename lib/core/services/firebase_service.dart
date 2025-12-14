import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/cart/model/cart_model.dart';
import '../../features/home/model/product_model.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser!.uid;

  // STREAM CARTS
  Stream<List<CartModel>> streamCarts() {
    return _firestore
        .collection('carts')
        .where('collaboratorsIds', arrayContains: userId)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        return CartModel.fromMap({...doc.data(), "id": doc.id});
      }).toList();
    });
  }

  // STREAM SINGLE CART
  Stream<CartModel?> streamCart(String cartId) {
    return _firestore
        .collection('carts')
        .doc(cartId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return CartModel.fromMap({...doc.data()!, "id": doc.id});
    });
  }

  // CREATE
  Future<String> createCart(String name) async {
    final ref = await _firestore.collection('carts').add({
      "name": name,
      "ownerId": userId,
      "products": [],
      "collaborators": [],
      "collaboratorsIds": [userId],
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    await ref.update({"id": ref.id});
    return ref.id;
  }

  // ADD PRODUCT
  Future<void> addProductToCart({
    required String cartId,
    required Product product,
  }) async {
    await _firestore.collection('carts').doc(cartId).update({
      "products": FieldValue.arrayUnion([product.toJson()])
    });
  }

  // REMOVE PRODUCT
  Future<void> removeProductFromCart({
    required String cartId,
    required int productId,
  }) async {
    final doc = await _firestore.collection('carts').doc(cartId).get();
    final cart = CartModel.fromMap({...doc.data()!, "id": doc.id});

    final updated = cart.products.where((p) => p.id != productId).toList();

    await doc.reference.update({
      "products": updated.map((e) => e.toJson()).toList(),
    });
  }

  // UPDATE QUANTITY
  Future<void> updateQuantity({
    required String cartId,
    required Product product,
    required bool increment,
  }) async {
    final doc = await _firestore.collection('carts').doc(cartId).get();
    final cart = CartModel.fromMap({...doc.data()!, "id": doc.id});

    final updated = cart.products.map((p) {
      if (p.id != product.id) return p;

      final newQty = increment ? p.qty + 1 : (p.qty > 1 ? p.qty - 1 : 1);
      return p.copyWith(qty: newQty);
    }).toList();

    // ❗ VERY IMPORTANT: Always replace full array, not update partial
    await doc.reference.update({
      "products": updated.map((e) => e.toJson()).toList(),
    });
  }

  // ADD COLLABORATOR
  Future<void> addCollaboratorToCart({
    required String cartId,
    required CartCollaborator collaborator,
  }) async {
    await _firestore.collection('carts').doc(cartId).update({
      "collaborators": FieldValue.arrayUnion([collaborator.toMap()]),
      "collaboratorsIds": FieldValue.arrayUnion([collaborator.id]),
    });
  }

  // REMOVE COLLABORATOR
  Future<void> removeCollaborator({
    required String cartId,
    required String collaboratorId,
  }) async {
    final doc = await _firestore.collection('carts').doc(cartId).get();
    final cart = CartModel.fromMap({...doc.data()!, "id": doc.id});

    final updated = cart.collaborators.where((c) => c.id != collaboratorId).toList();

    await doc.reference.update({
      "collaborators": updated.map((e) => e.toMap()).toList(),
      "collaboratorsIds": FieldValue.arrayRemove([collaboratorId]),
    });
  }
}
