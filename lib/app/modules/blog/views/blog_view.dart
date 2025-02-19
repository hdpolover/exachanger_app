import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/blog_controller.dart';

class BlogView extends BaseView<BlogController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: Text('BlogView'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Text(
        'BlogView is working',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
