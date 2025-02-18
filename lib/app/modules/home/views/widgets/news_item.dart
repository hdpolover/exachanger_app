import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/values/app_colors.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.pushNamed(Routes.newsDetail.name);
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
                      'Bitcoin Analyst Explain Why Price is Rallying Again',
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
                        Text('5 hours',
                            style: smallBodyTextStyle.copyWith(
                                color: Colors.grey)),
                        const SizedBox(width: 10),
                        Text('by Author',
                            style: smallBodyTextStyle.copyWith(
                                color: AppColors.colorPrimary)),
                        SizedBox(width: 10),
                        Text('in Category', style: smallBodyTextStyle),
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
