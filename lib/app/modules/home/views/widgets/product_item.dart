import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, this.onTap, this.isMore = false, this.product});

  final VoidCallback? onTap;
  final bool isMore;
  final ProductModel? product;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sizes based on available space
        final itemWidth = constraints.maxWidth;
        final imageSize = itemWidth * 0.6; // Image takes 60% of item width
        final fontSize = itemWidth * 0.12; // Font size scales with item width

        return Container(
          constraints: BoxConstraints(
            minWidth: 60,
            maxWidth: constraints.maxWidth,
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(itemWidth * 0.08), // Responsive padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: isMore
                            ? Image.asset(AppImages.more, fit: BoxFit.contain)
                            : (product != null && product!.image != null)
                            ? CachedNetworkImage(
                                imageUrl: product!.image!,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey[200]),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      AppImages.newLogo,
                                      fit: BoxFit.contain,
                                    ),
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                AppImages.newLogo,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      itemWidth * 0.04,
                    ), // Responsive padding
                    child: Text(
                      isMore ? "More" : product?.name ?? 'Product',
                      style: smallBodyTextStyle.copyWith(
                        fontSize: fontSize.clamp(
                          8.0,
                          12.0,
                        ), // Clamp font size between 8-12
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
