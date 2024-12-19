import 'package:exachanger_app/features/auth/signin_screen.dart';
import 'package:exachanger_app/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exachanger_app/core/providers/session_provider.dart';

class Splashscreen extends ConsumerWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    print('isAuthenticated: $isAuthenticated');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
