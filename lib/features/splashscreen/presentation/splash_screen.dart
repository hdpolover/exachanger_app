import 'package:exachanger_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isAuthenticated = ref.watch(isAuthenticatedProvider);

    // print('isAuthenticated: $isAuthenticated');

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const HomeScreen()),
    //   );
    // });

    return SafeArea(
      child: const Scaffold(
        body: Stack(
          children: [
            Center(
              child: CircularProgressIndicator(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text('Loading...'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
