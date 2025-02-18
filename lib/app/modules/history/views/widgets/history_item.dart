// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/widgets/status_chip.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  _productView() {
    return Row(
      children: [
        Image.asset(
          AppImages.logo,
          width: 40,
          height: 40,
        ),
        Text(
          'PayPal',
          style: extraSmallBodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  _topSection() {
    int status = Random().nextInt(3);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: StatusChip(status: status),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _productView(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                ),
                _productView()
              ],
            ),
            Text(
              CommonFunctions.formatDateTime(DateTime.now()),
              style: extraSmallBodyTextStyle.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  _bottomSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'USDT BEP20 Address',
              style: extraSmallBodyTextStyle.copyWith(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '0x4f9778b95ad9454df8e2fed fce38ca754295e970',
              style: regularBodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Total',
              style: extraSmallBodyTextStyle.copyWith(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 5),
            Text(
              CommonFunctions.formatUSD(1000),
              style: bigBodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // decoration for the card
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            _topSection(),
            SizedBox(height: 10),
            _bottomSection(),
          ],
        ),
      ),
    );
  }
}
