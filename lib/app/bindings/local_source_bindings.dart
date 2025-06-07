import 'package:get/get.dart';

import '/app/data/local/preference/preference_manager_impl.dart';

class LocalSourceBindings implements Bindings {
  @override
  void dependencies() {
    print('🔧 LOCAL SOURCE BINDINGS: Initializing local data sources...');

    if (!Get.isRegistered<PreferenceManagerImpl>()) {
      Get.put<PreferenceManagerImpl>(PreferenceManagerImpl(), permanent: true);
    }

    print('🔧 LOCAL SOURCE BINDINGS: All local data sources initialized');
  }
}
