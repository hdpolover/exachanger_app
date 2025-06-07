import 'package:exachanger_get_app/app/services/connectivity_service.dart';
import 'package:exachanger_get_app/app/services/critical_error_service.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:get/get.dart';

import 'local_source_bindings.dart';
import 'remote_source_bindings.dart';
import 'repository_bindings.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    RepositoryBindings().dependencies();
    RemoteSourceBindings().dependencies();
    LocalSourceBindings().dependencies();

    // Initialize ConnectivityService first
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);

    // Initialize CriticalErrorService to monitor API errors
    Get.put<CriticalErrorService>(CriticalErrorService(), permanent: true);

    // Initialize DataService as a persistent service
    // Using put instead of putAsync to ensure the service is immediately available
    Get.put<DataService>(DataService(), permanent: true);

    // Initialize the service after it's registered
    Get.find<DataService>().init();
  }

  static void reinitializeDependencies() {
    print('🔧 INITIAL BINDING: Re-initializing dependencies...');

    try {
      // Re-initialize in the correct order
      RepositoryBindings().dependencies();
      RemoteSourceBindings().dependencies();
      LocalSourceBindings().dependencies();

      // Re-initialize services if they don't exist
      if (!Get.isRegistered<ConnectivityService>()) {
        Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
      }

      if (!Get.isRegistered<CriticalErrorService>()) {
        Get.put<CriticalErrorService>(CriticalErrorService(), permanent: true);
      }

      if (!Get.isRegistered<DataService>()) {
        Get.put<DataService>(DataService(), permanent: true);
        Get.find<DataService>().init();
      }

      print('🔧 INITIAL BINDING: Dependencies re-initialized successfully');
    } catch (e) {
      print('🔧 INITIAL BINDING: Error during re-initialization: $e');
      rethrow;
    }
  }
}
