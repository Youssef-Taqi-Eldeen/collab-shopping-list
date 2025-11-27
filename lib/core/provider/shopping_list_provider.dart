import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/shopping_list_model.dart';
import '../models/item_model.dart';
import '../../features/home/model/product_model.dart';

class ShoppingListProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ShoppingListModel>> get myLists {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('lists')
        .where(
          Filter.or(
            Filter('ownerId', isEqualTo: user.uid),
            Filter('collaborators', arrayContains: user.uid),
          ),
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ShoppingListModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<ShoppingListModel> getListStream(String listId) {
    return _firestore.collection('lists').doc(listId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception("List not found");
      }
      return ShoppingListModel.fromFirestore(doc.data()!, doc.id);
    });
  }

  Future<void> createList(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newList = ShoppingListModel(
      id: '', // Will be set by Firestore
      ownerId: user.uid,
      name: name,
      collaborators: [],
      items: [],
      createdAt: Timestamp.now(),
    );

    await _firestore.collection('lists').add(newList.toFirestore());
  }

  Future<void> deleteList(String listId) async {
    await _firestore.collection('lists').doc(listId).delete();
  }



  Future<void> addItem(String listId, String itemName) async {
    final newItem = ItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: itemName,
      isChecked: false,
      quantity: 1,
    );

    await _firestore.collection('lists').doc(listId).update({
      'items': FieldValue.arrayUnion([newItem.toMap()]),
    });
  }

  Future<void> addProductToList(String listId, Product product, {int quantity = 1}) async {
    final newItem = ItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: product.title,
      isChecked: false,
      productId: product.id.toString(),
      price: product.price.toDouble(),
      quantity: quantity,
      imageUrl: product.thumbnail,
    );

    await _firestore.collection('lists').doc(listId).update({
      'items': FieldValue.arrayUnion([newItem.toMap()]),
    });
  }

  Future<void> toggleItem(String listId, ItemModel item) async {
    // To update an item in an array, we typically need to remove the old one and add the new one
    // OR read the list, modify it, and write it back.
    // Since we want to be safe, let's read, modify, write.
    // Ideally, we would use a subcollection for items to make this atomic and easier,
    // but the requirement says "items array OR subcollection".
    // Array is easier for small lists. Let's stick to array as per user request example.
    
    final docRef = _firestore.collection('lists').doc(listId);
    
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> itemsData = data['items'] ?? [];
      final items = itemsData.map((i) => ItemModel.fromMap(i)).toList();

      final index = items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        items[index] = item.copyWith(isChecked: !item.isChecked);
        transaction.update(docRef, {
          'items': items.map((i) => i.toMap()).toList(),
        });
      }
    });
  }

  Future<String> shareList(String listId, String email) async {
    try {
      final userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        return "No user found with this email.";
      }

      final collaboratorUid = userSnapshot.docs.first.id;
      
      // Check if already a collaborator or owner
      // We can do this check on the client side or just let arrayUnion handle duplicates.
      // But we should check if it's the owner.
      // We'll just add it. arrayUnion handles unique.
      
      await _firestore.collection('lists').doc(listId).update({
        'collaborators': FieldValue.arrayUnion([collaboratorUid]),
      });

      return "User added successfully.";
    } catch (e) {
      return "Error sharing list: $e";
    }
  }
}
