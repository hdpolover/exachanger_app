import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/blog_model.dart';
import '../routes/app_pages.dart';

class BlogMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;
  @override
  RouteSettings? redirect(String? route) {
    print('BlogMiddleware: Checking route: $route');
    print('BlogMiddleware: Arguments type: ${Get.arguments?.runtimeType}');
    print('BlogMiddleware: Arguments: ${Get.arguments}');

    // Check if arguments are provided and are of the correct type
    if (Get.arguments == null) {
      // If no arguments at all, redirect to the blogs list
      print('No arguments provided for blog detail');
      return const RouteSettings(name: Routes.BLOG);
    }

    // Check if it's a BlogModel directly
    if (Get.arguments is BlogModel) {
      print('Valid BlogModel found, allowing navigation');
      return null; // Allow navigation
    }

    // Check if it's a Map containing blog data (for flexibility)
    if (Get.arguments is Map<String, dynamic>) {
      try {
        // Try to create a BlogModel from the map
        BlogModel.fromJson(Get.arguments as Map<String, dynamic>);
        print('Valid blog data map found, allowing navigation');
        return null; // Allow navigation if valid
      } catch (e) {
        print('Invalid blog data in arguments: $e');
      }
    }

    // If we get here, the arguments are invalid
    print(
      'Invalid blog model provided in arguments: ${Get.arguments?.runtimeType}',
    );
    return const RouteSettings(name: Routes.BLOG);
  }
}
