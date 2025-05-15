import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/models/rate_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/utils/common_functions.dart';

class RateItem extends StatelessWidget {
  final ProductModel product;

  const RateItem({
    super.key,
    required this.product,
  });

  Widget _rateDetailItem(RateModel rate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.arrowRightLong,
          size: 12,
          color: Colors.black,
        ),
        SizedBox(width: 5),
        rate.product?.image != null
            ? CachedNetworkImage(
                imageUrl: rate.product!.image!,
                width: 15,
                height: 15,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 15,
                  height: 15,
                  color: Colors.grey[200],
                ),
                errorWidget: (context, url, error) => Image.asset(
                  AppImages.noImage,
                  width: 15,
                  height: 15,
                ),
              )
            : Image.asset(
                AppImages.logo,
                width: 15,
                height: 15,
              ),
        SizedBox(width: 5),
        Text(
          rate.product?.name ?? 'Unknown',
          style: smallBodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          CommonFunctions.formatUSD(
            rate.pricing is int
                ? (rate.pricing as int).toDouble()
                : (rate.pricing ?? 0.0),
          ),
          style: regularBodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _rateDetailList() {
    final activeRates =
        product.rates?.where((r) => r.status == 'active').toList() ?? [];

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: activeRates.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _rateDetailItem(activeRates[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            product.image != null
                ? CachedNetworkImage(
                    imageUrl: product.image!,
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 25,
                      height: 25,
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AppImages.noImage,
                      width: 25,
                      height: 25,
                    ),
                  )
                : Image.asset(
                    AppImages.logo,
                    width: 25,
                    height: 25,
                  ),
            SizedBox(width: 10),
            Text(
              product.name ?? 'Unknown',
              style: regularBodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // if (product.category != null)
            //   Padding(
            //     padding: const EdgeInsets.only(left: 8.0),
            //     child: Chip(
            //       label: Text(
            //         product.category!,
            //         style: TextStyle(fontSize: 10),
            //       ),
            //       backgroundColor: Colors.grey.shade200,
            //       padding: EdgeInsets.zero,
            //       labelPadding: EdgeInsets.symmetric(horizontal: 8),
            //     ),
            //   ),
          ],
        ),
        SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${product.name} daily rate per ${CommonFunctions.formatUSD(1.0)}",
                style: smallBodyTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              if (product.rates == null || product.rates!.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(child: Text('No rates available')),
                )
              else
                _rateDetailList(),
            ],
          ),
        ),
      ],
    );
  }
}
