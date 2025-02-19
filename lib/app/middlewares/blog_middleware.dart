import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  // on page load, get parameter from route and print it
  @override
  RouteSettings? redirect(String? route) {
    final parameter = Get.parameters['id'];
    print('Parameter: $parameter');
    return null;
  }
}
