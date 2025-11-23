import 'package:faker/faker.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_todo/core/di/firebase_repository.dart';
import 'package:flutter_firebase_auth_todo/core/di/firestore_repository.dart';
import 'package:flutter_firebase_auth_todo/features/todo/domain/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryListView extends ConsumerWidget {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final currentUser = ref.watch(firebaseAuthProvider).currentUser;

    return FirestoreListView<Category>(
      errorBuilder: (context, error, stackTrace) {
        return Center(child: Text(error.toString()));
      },
      loadingBuilder: (context) {
        return Center(child: CircularProgressIndicator());
      },
      emptyBuilder: (context) {
        return Center(child: Text('No categories found'));
      },
      query: firestoreRepository.getCategories(currentUser?.uid ?? ''),
      itemBuilder: (context, categoryDocument) {
        final categoryData = categoryDocument.data();
        return Dismissible(
          key: Key(categoryData.id),
          onDismissed: (direction) {
            final user = ref.read(firebaseAuthProvider).currentUser;
            ref
                .read(firestoreRepositoryProvider)
                .deleteCategory(user!.uid, categoryDocument.id);
          },
          background: Container(color: Colors.red),
          // secondaryBackground: Container(color: Colors.green),
          direction: DismissDirection.endToStart,
          child: ListTile(
            title: Text('ID: ${categoryData.id}\nName: ${categoryData.name}'),
            subtitle: Text(categoryData.description),
            trailing: Text(categoryData.createdAt?.toIso8601String() ?? ''),
            // leading: Text(categoryDocument.id),
            onTap: () {
              final user = ref.watch(firebaseAuthProvider).currentUser;
              final faker = Faker();
              final category = Category(
                id: user!.uid,
                name: faker.lorem.words(1).join(' '),
                description: faker.lorem.sentence(),
                status: true,
              );
              ref
                  .read(firestoreRepositoryProvider)
                  .updateCategory(
                    user.uid,
                    categoryDocument.id,
                    category.name,
                    category.description,
                    category.status,
                  );
            },
            // leading: IconButton(
            //   onPressed: () {
            //     ref
            //         .read(firestoreRepositoryProvider)
            //         .deleteCategory(currentUser?.uid ?? '', categoryData.id);
            //   },
            //   icon: Icon(Icons.delete),
            // ),
          ),
        );
      },
    );
  }
}
