import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/blog_detail_controller.dart';

class BlogDetailView extends BaseView<BlogDetailController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: controller.blogModel.title!);
  }

  @override
  Widget body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: controller.blogModel.id!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: controller.blogModel.featuredImage!),
              ),
            ),
            SizedBox(height: 20),
            Text(
              controller.blogModel.title!,
              style: titleTextStyle,
            ),
            SizedBox(height: 10),
            Text(
              controller.blogModel.content!,
              style: regularBodyTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
