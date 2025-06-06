import 'package:exachanger_get_app/app/services/connectivity_service.dart';
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

    // Initialize DataService as a persistent service
    // Using put instead of putAsync to ensure the service is immediately available
    Get.put<DataService>(DataService(), permanent: true);

    // Initialize the service after it's registered
    Get.find<DataService>().init();
  }

  static void reinitializeDependencies() {
    InitialBinding().dependencies();
  }
}
