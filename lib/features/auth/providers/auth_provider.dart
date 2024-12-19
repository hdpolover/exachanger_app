// lib/features/auth/providers/auth_provider.dart
import 'package:exachanger_app/core/providers/session_provider.dart';
import 'package:exachanger_app/core/service_locator.dart';
import 'package:exachanger_app/features/auth/models/signin_request.dart';
import 'package:exachanger_app/features/auth/models/signin_response.dart';
import 'package:exachanger_app/features/auth/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return getIt<AuthRepository>();
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<SignInResponse?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signIn(SignInRequest request) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signIn(request);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (response) {
        // Save session on successful login
        ref.read(sessionServiceProvider).saveSession(response);
        return AsyncValue.data(response);
      },
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signOut();

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        // Clear session on signout
        ref.read(sessionServiceProvider).clearSession();
        return const AsyncValue.data(null);
      },
    );
  }
}
