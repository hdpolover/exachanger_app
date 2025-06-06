import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/utils/common_functions.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../controllers/promo_controller.dart';

class PromoDetailView extends BaseView<PromoController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: controller.selectedPromo.value?.title ?? '',
    );
  }

  Widget useButton() {
    return CustomButton(label: "Use Promotion", onPressed: () {});
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      final promo = controller.selectedPromo.value;
      if (promo == null) {
        return Center(child: Text('No promotion selected'));
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: promo.id!,
              child: CachedNetworkImage(
                imageUrl: promo.image!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              promo.title!,
              style: regularBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Valid until ${CommonFunctions.formatDateTime(DateTime.parse(promo.endDate!), withTime: false)}",
            ),
            SizedBox(height: 10),
            if (promo.content != null && promo.content!.isNotEmpty)
              Html(
                data: promo.content!,
                style: {
                  "body": Style(
                    fontSize: FontSize(16),
                    lineHeight: LineHeight(1.5),
                    color: Colors.black87,
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  "p": Style(margin: Margins.only(bottom: 8)),
                  "h1": Style(
                    fontSize: FontSize(20),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(top: 12, bottom: 8),
                  ),
                  "h2": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(top: 10, bottom: 6),
                  ),
                  "h3": Style(
                    fontSize: FontSize(16),
                    fontWeight: FontWeight.bold,
                    margin: Margins.only(top: 8, bottom: 4),
                  ),
                  "ul": Style(margin: Margins.only(bottom: 8)),
                  "ol": Style(margin: Margins.only(bottom: 8)),
                  "li": Style(margin: Margins.only(bottom: 2)),
                  "a": Style(
                    color: Colors.blue,
                    textDecoration: TextDecoration.underline,
                  ),
                  "strong": Style(fontWeight: FontWeight.bold),
                  "b": Style(fontWeight: FontWeight.bold),
                  "em": Style(fontStyle: FontStyle.italic),
                  "i": Style(fontStyle: FontStyle.italic),
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
          ],
        ),
      );
    });
  }
}
