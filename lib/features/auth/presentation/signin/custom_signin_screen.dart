import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_todo/core/routes/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = <AuthProvider>[
      EmailAuthProvider(),
      // PhoneAuthProvider(),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: SignInScreen(
        providers: authProvider,
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            context.goNamed(AppRoute.profile.name);
          }),
          AuthStateChangeAction<UserCreated>((context, state) {
            context.goNamed(AppRoute.profile.name);
          }),
        ],
      ),
    );
  }
}
