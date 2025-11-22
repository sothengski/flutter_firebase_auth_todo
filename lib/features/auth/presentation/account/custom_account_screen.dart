import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_todo/features/auth/presentation/ui_auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return ProfileScreen(
      appBar: AppBar(title: const Text('Profile')),
      providers: authProviders,
      avatarSize: 100,
      // showMFATile: true,
      // actions: [
      //   SignedOutAction((context) {
      //     context.goNamed(AppRoute.signIn.name);
      //   }),
      // ],
    );
  }
}
