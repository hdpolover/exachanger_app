// lib/core/providers/session_provider.dart
import 'package:exachanger_app/core/service_locator.dart';
import 'package:exachanger_app/core/services/session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_provider.g.dart';

@riverpod
SessionService sessionService(Ref ref) {
  return getIt<SessionService>();
}

@riverpod
bool isAuthenticated(Ref ref) {
  return ref.read(sessionServiceProvider).isAuthenticated;
}
