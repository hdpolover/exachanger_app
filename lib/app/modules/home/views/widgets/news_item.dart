import 'package:exachanger_get_app/app/core/values/app_images.dart';
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
    return GestureDetector(
      onTap: () {
        print(blogModel);
        Get.toNamed(Routes.BLOG_DETAIL, parameters: {'id': blogModel.id!});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      children: [
                        Text(blogModel.createdAt ?? '',
                            style: smallBodyTextStyle.copyWith(
                                color: Colors.grey)),
                        const SizedBox(width: 10),
                        Text(blogModel.category ?? '',
                            style: smallBodyTextStyle.copyWith(
                                color: AppColors.colorPrimary)),
                        SizedBox(width: 10),
                        Text(blogModel.category ?? '',
                            style: smallBodyTextStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Hero(
              tag: 'news',
              child: Image.asset(
                AppImages.welcome,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
