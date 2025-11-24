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

  /// Get type-safe Category collection reference
  CollectionReference<Category> _categoryCollection(String uid) {
    return _firestore
        .collection(categoryCollectionPath(uid))
        .withConverter<Category>(
          fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
          toFirestore: (category, _) => category.toJson(),
        );
  }

  /// Category Collection
  ///
  /// Get categories from the collection
  Query<Category> getCategories(String uid) {
    return _categoryCollection(uid).orderBy('createdAt', descending: true);
  }

  /// Get category from the collection
  Future<DocumentSnapshot<Category>> getCategory(
    String uid,
    String categoryId,
  ) {
    return _categoryCollection(uid).doc(categoryId).get();
  }

  /// Add category to the collection
  Future<DocumentReference<Category>> addCategory(
    String uid,
    String name,
    String description,
  ) async {
    final categoryId = DateFormat('yyMMddHHmmss').format(DateTime.now());
    final category = Category(
      id: categoryId,
      name: name,
      description: description,
      status: true,
    );

    // Get type-safe document reference
    final docRef = _categoryCollection(uid).doc(categoryId);

    // Use type-safe set() to write the category
    await docRef.set(category);

    // Then update with server timestamps using type-safe reference
    await docRef.update({
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef;
  }

  /// Update category in the collection
  ///
  /// Don't update the createdAt and id fields, only update the name, description and status fields
  ///
  Future<void> updateCategory(
    String uid,
    String categoryId,
    String name,
    String description,
    bool status,
    DateTime? createdAt,
    // DateTime? updatedAt,
  ) async {
    final category = Category(
      id: categoryId,
      name: name,
      description: description,
      status: status,
      createdAt: createdAt,
    );

    // Get type-safe document reference
    final docRef = _categoryCollection(uid).doc(categoryId);

    // Use type-safe set() with merge to update the category
    await docRef.set(category, SetOptions(merge: true));

    // Then update the timestamp using type-safe reference
    await docRef.update({'updatedAt': FieldValue.serverTimestamp()});
  }

  /// Delete category from the collection
  Future<void> deleteCategory(String uid, String categoryId) async {
    await _categoryCollection(uid).doc(categoryId).delete();
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});
