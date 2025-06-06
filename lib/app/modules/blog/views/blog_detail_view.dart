import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../controllers/blog_controller.dart';

class BlogDetailView extends BaseView<BlogController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: controller.hasBlogModel
          ? controller.blogModel.title ?? 'Blog Detail'
          : 'Blog Detail',
    );
  }

  @override
  Widget body(BuildContext context) {
    if (!controller.hasBlogModel) {
      return Center(child: Text('Blog not found', style: titleTextStyle));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            if (controller.blogModel.featuredImage != null &&
                controller.blogModel.featuredImage!.isNotEmpty)
              Hero(
                tag: controller.blogModel.id ?? 'blog_image',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    imageUrl: controller.blogModel.featuredImage!,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Blog title
            Text(
              controller.blogModel.title ?? '',
              style: titleTextStyle.copyWith(fontSize: 24),
            ),
            SizedBox(height: 16),

            // Blog metadata
            Row(
              children: [
                if (controller.blogModel.category != null &&
                    controller.blogModel.category!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      controller.blogModel.category!,
                      style: smallBodyTextStyle.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
                if (controller.blogModel.createdAt != null &&
                    controller.blogModel.createdAt!.isNotEmpty)
                  Text(
                    controller.blogModel.createdAt!,
                    style: smallBodyTextStyle.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),

            // Blog content with HTML rendering
            if (controller.blogModel.content != null &&
                controller.blogModel.content!.isNotEmpty)
              Html(
                data: controller.blogModel.content!,
                style: {
                  "body": Style(
                    fontSize: FontSize(16),
                    lineHeight: LineHeight(1.5),
                    color: Colors.black87,
                    fontFamily: 'Roboto',
                  ),
                  "p": Style(margin: Margins.only(bottom: 16)),
                  "h1": Style(
                    fontSize: FontSize(24),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(top: 20, bottom: 12),
                  ),
                  "h2": Style(
                    fontSize: FontSize(20),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(top: 18, bottom: 10),
                  ),
                  "h3": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(top: 16, bottom: 8),
                  ),
                  "ul": Style(margin: Margins.only(bottom: 16)),
                  "ol": Style(margin: Margins.only(bottom: 16)),
                  "li": Style(margin: Margins.only(bottom: 4)),
                  "a": Style(
                    color: Colors.blue,
                    textDecoration: TextDecoration.underline,
                  ),
                  "blockquote": Style(
                    border: Border(
                      left: BorderSide(color: Colors.grey.shade400, width: 4),
                    ),
                    padding: HtmlPaddings.only(left: 16),
                    margin: Margins.only(top: 16, bottom: 16),
                    backgroundColor: Colors.grey.shade50,
                  ),
                  "code": Style(
                    backgroundColor: Colors.grey.shade200,
                    padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2),
                    fontFamily: 'monospace',
                  ),
                  "pre": Style(
                    backgroundColor: Colors.grey.shade100,
                    padding: HtmlPaddings.all(12),
                    margin: Margins.only(top: 16, bottom: 16),
                    fontFamily: 'monospace',
                  ),
                },
                onLinkTap: (url, attributes, element) {
                  // Handle link taps if needed
                  print('Link tapped: $url');
                },
              )
            else
              Text(
                'No content available',
                style: regularBodyTextStyle.copyWith(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),

            SizedBox(height: 40), // Extra padding at bottom
          ],
        ),
      ),
    );
  }
}
