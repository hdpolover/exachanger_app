import 'package:exachanger_app/core/providers/session_provider.dart';
import 'package:exachanger_app/features/auth/providers/auth_provider.dart';
import 'package:exachanger_app/features/auth/widgets/signin_form.dart';
import 'package:exachanger_app/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// lib/features/auth/signin_screen.dart
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final authState = ref.watch(authNotifierProvider);

    // Check if already authenticated
    if (isAuthenticated) {
      return const HomeScreen();
    }

    return authState.when(
      data: (user) => const SigninForm(),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
