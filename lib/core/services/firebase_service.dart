import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/shopping_list_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current user's UID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Stream of lists that the current user owns or is a collaborator on
  /// This implements the filtering logic to ensure users only see their own lists
  /// or lists they've been invited to collaborate on
  Stream<List<ShoppingListModel>> getUserLists() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    // Use compound OR query to get lists where user is owner OR collaborator
    // Note: Firestore doesn't support OR queries in older versions,
    // so we need to use the newer Filter API or merge two queries
    
    // If using Firebase SDK that supports Filter.or:
    try {
      return _firestore
          .collection('lists')
          .where(
            Filter.or(
              Filter('ownerId', isEqualTo: currentUserId),
              Filter('collaborators', arrayContains: currentUserId),
            ),
          )
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ShoppingListModel.fromFirestore(doc.data(), doc.id))
                .toList();
          });
    } catch (e) {
      // Fallback: If Filter.or is not available, we need to merge two streams
      // This is a workaround for older Firebase versions
      return _mergeListStreams();
    }
  }

  /// Fallback method: Merge two separate queries
  /// One for owned lists, one for collaborated lists
  Stream<List<ShoppingListModel>> _mergeListStreams() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    // Get lists owned by user
    final ownedStream = _firestore
        .collection('lists')
        .where('ownerId', isEqualTo: currentUserId)
        .snapshots();

    // Get lists where user is a collaborator
    final collaboratedStream = _firestore
        .collection('lists')
        .where('collaborators', arrayContains: currentUserId)
        .snapshots();

    // Combine both streams
    return ownedStream.asyncMap((ownedSnapshot) async {
      final collaboratedSnapshot = await collaboratedStream.first;
      
      // Create a set to avoid duplicates (in case user is both owner and collaborator)
      final listIds = <String>{};
      final lists = <ShoppingListModel>[];

      for (var doc in ownedSnapshot.docs) {
        if (!listIds.contains(doc.id)) {
          listIds.add(doc.id);
          lists.add(ShoppingListModel.fromFirestore(doc.data(), doc.id));
        }
      }

      for (var doc in collaboratedSnapshot.docs) {
        if (!listIds.contains(doc.id)) {
          listIds.add(doc.id);
          lists.add(ShoppingListModel.fromFirestore(doc.data(), doc.id));
        }
      }

      return lists;
    });
  }

  /// Get lists owned by the current user only
  Stream<List<ShoppingListModel>> getOwnedLists() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('lists')
        .where('ownerId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ShoppingListModel.fromFirestore(doc.data(), doc.id))
              .toList();
        });
  }

  /// Get lists where the current user is a collaborator (but not the owner)
  Stream<List<ShoppingListModel>> getCollaboratedLists() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('lists')
        .where('collaborators', arrayContains: currentUserId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ShoppingListModel.fromFirestore(doc.data(), doc.id))
              .where((list) => list.ownerId != currentUserId) // Exclude if also owner
              .toList();
        });
  }

  /// Stream of carts that the current user owns or is a collaborator on
  Stream<List<Map<String, dynamic>>> getUserCarts() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    try {
      return _firestore
          .collection('carts')
          .where(
            Filter.or(
              Filter('ownerId', isEqualTo: currentUserId),
              Filter('collaborators', arrayContains: currentUserId),
            ),
          )
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList();
          });
    } catch (e) {
      // Fallback for older Firebase versions
      return _mergeCartStreams();
    }
  }

  /// Fallback method for carts: Merge two separate queries
  Stream<List<Map<String, dynamic>>> _mergeCartStreams() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    final ownedStream = _firestore
        .collection('carts')
        .where('ownerId', isEqualTo: currentUserId)
        .snapshots();

    final collaboratedStream = _firestore
        .collection('carts')
        .where('collaborators', arrayContains: currentUserId)
        .snapshots();

    return ownedStream.asyncMap((ownedSnapshot) async {
      final collaboratedSnapshot = await collaboratedStream.first;
      
      final cartIds = <String>{};
      final carts = <Map<String, dynamic>>[];

      for (var doc in ownedSnapshot.docs) {
        if (!cartIds.contains(doc.id)) {
          cartIds.add(doc.id);
          final data = doc.data();
          data['id'] = doc.id;
          carts.add(data);
        }
      }

      for (var doc in collaboratedSnapshot.docs) {
        if (!cartIds.contains(doc.id)) {
          cartIds.add(doc.id);
          final data = doc.data();
          data['id'] = doc.id;
          carts.add(data);
        }
      }

      return carts;
    });
  }

  /// Create a new shopping list
  Future<String> createList({
    required String name,
    List<String>? initialCollaborators,
  }) async {
    if (currentUserId == null) {
      throw Exception('User must be logged in to create a list');
    }

    final docRef = await _firestore.collection('lists').add({
      'name': name,
      'ownerId': currentUserId,
      'collaborators': initialCollaborators ?? [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  /// Add a collaborator to a list
  Future<void> addCollaboratorToList({
    required String listId,
    required String collaboratorUid,
  }) async {
    await _firestore.collection('lists').doc(listId).update({
      'collaborators': FieldValue.arrayUnion([collaboratorUid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove a collaborator from a list
  Future<void> removeCollaboratorFromList({
    required String listId,
    required String collaboratorUid,
  }) async {
    await _firestore.collection('lists').doc(listId).update({
      'collaborators': FieldValue.arrayRemove([collaboratorUid]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete a list (only if user is the owner)
  Future<void> deleteList(String listId) async {
    final doc = await _firestore.collection('lists').doc(listId).get();
    
    if (!doc.exists) {
      throw Exception('List not found');
    }

    final ownerId = doc.data()?['ownerId'];
    if (ownerId != currentUserId) {
      throw Exception('Only the owner can delete this list');
    }

    await _firestore.collection('lists').doc(listId).delete();
  }

  /// Get a single list by ID
  Future<ShoppingListModel?> getList(String listId) async {
    final doc = await _firestore.collection('lists').doc(listId).get();
    
    if (!doc.exists) {
      return null;
    }

    final list = ShoppingListModel.fromFirestore(doc.data()!, doc.id);
    
    // Verify user has access to this list
    if (list.ownerId != currentUserId && 
        !list.collaborators.contains(currentUserId)) {
      throw Exception('You do not have access to this list');
    }

    return list;
  }

  /// Check if user has access to a list
  Future<bool> hasAccessToList(String listId) async {
    if (currentUserId == null) return false;

    final doc = await _firestore.collection('lists').doc(listId).get();
    
    if (!doc.exists) {
      return false;
    }

    final data = doc.data()!;
    final ownerId = data['ownerId'] as String?;
    final collaborators = List<String>.from(data['collaborators'] ?? []);

    return ownerId == currentUserId || collaborators.contains(currentUserId);
  }
}
