import 'package:exachanger_app/features/home/presentation/screens/home_screen.dart';
import 'package:exachanger_app/features/splashscreen/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

enum Routes {
  splash,
  welcome,
  home,
  signin,
  signup,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: Routes.splash.name,
        builder: (context, state) => SplashScreen(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/welcome',
        name: Routes.welcome.name,
        builder: (context, state) => SplashScreen(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/home',
        name: Routes.home.name,
        builder: (context, state) => HomeScreen(
          key: state.pageKey,
        ),
      ),

      // GoRoute(
      //   path: '/movieDetail',
      //   name: Routes.movieDetail.name,
      //   builder: (context, state) =>
      //       MovieDetailScreen(key: state.pageKey, movieId: state.extra as int),
      // ),
    ],
  );
}
