import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth_todo/features/todo/domain/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

String categoryCollectionPath(String uid) => 'users/$uid/categories';
String categoryDocumentPath(String uid, String categoryId) =>
    'users/$uid/categories/$categoryId';

class FirestoreRepository {
  FirestoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  /// Category Collection
  ///
  /// Get categories from the collection
  // Future<QuerySnapshot<Map<String, dynamic>>> getCategories(String uid) async {
  //   return await _firestore.collection(categoryCollectionPath(uid)).get();
  // }
  Query<Category> getCategories(String uid) {
    return _firestore
        .collection(categoryCollectionPath(uid))
        .withConverter(
          fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
          toFirestore: (category, _) => category.toJson(),
        )
        .orderBy('createdAt', descending: true);
  }

  /// Get category from the collection
  Future<DocumentSnapshot<Category>> getCategory(
    String uid,
    String categoryId,
  ) {
    return _firestore
        .collection(categoryCollectionPath(uid))
        .doc(categoryId)
        .withConverter(
          fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
          toFirestore: (category, _) => category.toJson(),
        )
        .get();
  }

  /// Add category to the collection
  Future<void> addCategory(String uid, String name, String description) async {
    final categoryData = Category(
      id: DateFormat('yyMMddHHmmss').format(DateTime.now()),
      name: name,
      description: description,
      status: true,
    ).toJson();

    // Add server timestamps directly to the document data
    categoryData['createdAt'] = FieldValue.serverTimestamp();
    categoryData['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore.collection(categoryCollectionPath(uid)).add(categoryData);
  }

  /// Update category in the collection
  Future<void> updateCategory(
    String uid,
    String categoryId,
    String name,
    String description,
    bool status,
  ) async {
    final categoryData = Category(
      id: categoryId,
      name: name,
      description: description,
      status: status,
    ).toJson();

    // Add server timestamp for updatedAt
    categoryData['updatedAt'] = FieldValue.serverTimestamp();
    categoryData['createdAt'] = FieldValue.serverTimestamp();

    // debugPrint('updateCategory: ${categoryData.toString()}');
    await _firestore
        .collection(categoryCollectionPath(uid))
        .doc(categoryId)
        .update(categoryData);
  }

  /// Delete category from the collection
  Future<void> deleteCategory(String uid, String categoryId) async {
    // debugPrint('deleteCategory: ${categoryDocumentPath(uid, categoryId)}');
    await _firestore.doc(categoryDocumentPath(uid, categoryId)).delete();
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});
