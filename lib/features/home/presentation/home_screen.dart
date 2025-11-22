import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_todo/core/routes/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Jobs'),
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
      body: Center(child: Text('Home')),
    );
  }
}
