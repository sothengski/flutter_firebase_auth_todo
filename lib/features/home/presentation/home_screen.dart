import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_todo/core/di/firebase_repository.dart';
import 'package:flutter_firebase_auth_todo/core/di/firestore_repository.dart';
import 'package:flutter_firebase_auth_todo/core/routes/app_router.dart';
import 'package:flutter_firebase_auth_todo/features/todo/domain/category.dart';
import 'package:flutter_firebase_auth_todo/features/todo/presentation/category_list_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Categories'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.delete),
          //   onPressed: () async {
          //     try {
          //       await ref.read(functionsRepositoryProvider).deleteAllUserJobs();
          //     } catch (e) {
          //       if (e is FirebaseFunctionsException) {
          //         showAlertDialog(
          //           context: context,
          //           title: 'An error occurred',
          //           content: e.message,
          //         );
          //       }
          //     }
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => context.goNamed(AppRoute.profile.name),
          ),
        ],
      ),
      body: CategoryListView(),
      floatingActionButton: FloatingActionButton(
        // onPressed: () => context.goNamed(AppRoute.category.name),
        onPressed: () {
          final user = ref.watch(firebaseAuthProvider).currentUser;
          final faker = Faker();
          final category = Category(
            id: user!.uid,
            name: faker.lorem.words(1).join(' '),
            description: faker.lorem.sentence(),
          );
          ref
              .read(firestoreRepositoryProvider)
              .addCategory(user.uid, category.name, category.description);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
