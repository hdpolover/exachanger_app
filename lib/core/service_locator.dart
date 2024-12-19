// lib/core/service_locator.dart
import 'package:exachanger_app/core/config/app_config.dart';
import 'package:exachanger_app/core/services/network_service.dart';
import 'package:exachanger_app/core/services/session_service.dart';
import 'package:exachanger_app/core/services/shared_preferences_service.dart';
import 'package:exachanger_app/features/auth/repositories/auth_repository.dart';
import 'package:exachanger_app/features/auth/repositories/fake_auth_repository.dart';
import 'package:exachanger_app/features/auth/repositories/remote_auth_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Services
  final prefsService = SharedPreferencesService();
  await prefsService.init();

  getIt.registerSingleton<SharedPreferencesService>(prefsService);
  getIt.registerSingleton<SessionService>(SessionService(prefsService));
  getIt.registerSingleton<AppConfig>(AppConfig());
  getIt.registerSingleton<NetworkService>(NetworkService());

  registerRepositories();
}

void registerRepositories() {
  // Auth Repository
  getIt.registerFactory<AuthRepository>(() {
    final useFake = getIt<AppConfig>().useFakeRepositories;
    return useFake
        ? FakeAuthRepository()
        : RemoteAuthRepository(getIt<NetworkService>());
  });

  // Add other repositories here...
}

void toggleRepositories(bool useFake) {
  getIt<AppConfig>().useFakeRepositories = useFake;
  getIt.reset(dispose: false);
  registerRepositories();
}
