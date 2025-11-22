import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_todo/features/auth/presentation/ui_auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: SignInScreen(
        providers: authProviders,
        // actions: [
        //   AuthStateChangeAction<SignedIn>((context, state) {
        //     context.goNamed(AppRoute.profile.name);
        //   }),
        //   AuthStateChangeAction<UserCreated>((context, state) {
        //     context.goNamed(AppRoute.profile.name);
        //   }),
        // ],
      ),
    );
  }
}
