import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/modules/home/views/widgets/news_item.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/blog_controller.dart';

class BlogView extends BaseView<BlogController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: "Blog");
  }

  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: controller.blogs.length,
      itemBuilder: (context, index) {
        return NewsItem(blogModel: controller.blogs[index]);
      },
    );
  }
}
