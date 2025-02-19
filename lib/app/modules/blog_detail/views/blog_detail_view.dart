import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/blog_detail_controller.dart';

class BlogDetailView extends BaseView<BlogDetailController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      title: Text('BlogDetailView'),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Text(
        'BlogDetailView is working',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
