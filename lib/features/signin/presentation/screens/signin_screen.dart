import 'package:exachanger_app/features/signin/presentation/widgets/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// lib/features/auth/signin_screen.dart
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isAuthenticated = ref.watch(isAuthenticatedProvider);
    // final authState = ref.watch(authNotifierProvider);

    // // Check if already authenticated
    // if (isAuthenticated) {
    //   return const HomeScreen();
    // }

    // return authState.when(
    //   data: (user) => const SigninForm(),
    //   loading: () => const CircularProgressIndicator(),
    //   error: (error, stack) => Text('Error: $error'),
    // );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SigninForm(),
          ],
        ),
      ),
    );
  }
}
