import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/data/model/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../routes/app_pages.dart';

class NewsItem extends StatelessWidget {
  final BlogModel blogModel;

  const NewsItem({super.key, required this.blogModel});

  @override
  Widget build(BuildContext context) {
    String date = blogModel.createdAt!;

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.BLOG_DETAIL, arguments: blogModel);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          // add border just the bottom
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    blogModel.title ?? '',
                    style: regularBodyTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: smallBodyTextStyle.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        blogModel.category ?? '',
                        style: smallBodyTextStyle.copyWith(
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Hero(
              tag: blogModel.id!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: blogModel.featuredImage!,
                  fit: BoxFit.cover,
                  height: 70,
                  width: 70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
