// lib/core/providers/network_provider.dart
import 'package:dio/dio.dart';
import 'package:exachanger_app/constants/string_constants.dart';
import 'package:exachanger_app/core/services/network_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkServiceProvider = Provider<NetworkService>((ref) {
  // Base options can be customized here if needed.
  return NetworkService(
    options: BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
});
