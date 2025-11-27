import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_model.dart';

class ShoppingListModel {
  final String id;
  final String ownerId;
  final String name;
  final List<String> collaborators;
  final List<ItemModel> items;
  final Timestamp? createdAt;

  ShoppingListModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.collaborators,
    this.items = const [],
    this.createdAt,
  });

  factory ShoppingListModel.fromFirestore(Map<String, dynamic> json, String id) {
    return ShoppingListModel(
      id: id,
      ownerId: json['ownerId'] ?? '',
      name: json['name'] ?? '',
      collaborators: List<String>.from(json['collaborators'] ?? []),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ItemModel.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'name': name,
      'collaborators': collaborators,
      'items': items.map((item) => item.toMap()).toList(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}

