import 'package:get/get.dart';

import '/app/data/local/preference/preference_manager_impl.dart';

class LocalSourceBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<PreferenceManagerImpl>(
      PreferenceManagerImpl(),
      permanent: true,
    );
  }
}
