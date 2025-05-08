import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/utils/common_functions.dart';

class RateItem extends StatelessWidget {
  const RateItem({super.key});

  _rateDetailItem() {
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
        Image.asset(
          AppImages.logo,
          width: 30,
          height: 30,
        ),
        SizedBox(width: 5),
        Text(
          'PayPal',
          style: smallBodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          CommonFunctions.formatUSD(0.8),
          style: regularBodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _rateDetailList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: 5,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _rateDetailItem(),
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
            Image.asset(
              AppImages.logo,
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'PayPal',
              style: regularBodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
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
                "Paypal daily rate per ${CommonFunctions.formatUSD(1)}",
                style: smallBodyTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              _rateDetailList(),
            ],
          ),
        ),
      ],
    );
  }
}
