// lib/app/middleware/auth_middleware.dart
import 'package:exachanger_get_app/app/data/local/preference/preference_manager.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Authentication logic
    Get.find<PreferenceManagerImpl>().getBool("is_signed_in").then((value) {
      if (value && route != Routes.SIGN_IN) {
        if (value) {
          return RouteSettings(name: Routes.HOME);
        } else {
          return RouteSettings(name: Routes.SIGN_IN);
        }
      }
    });

    return null;
  }
}
