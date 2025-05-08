import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

class BlogMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  // on page load, get parameter from route and print it
  @override
  RouteSettings? redirect(String? route) {
    final blogId = Get.parameters['id'];
    if (blogId == null) {
      print('no blog id');
    }
    return null;
  }
}
