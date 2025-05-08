import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/exchange_controller.dart';

class DropdownExchangeItem {
  final String? value;
  final String? title;
  final String? imageUrl;

  DropdownExchangeItem({
    this.value,
    this.title,
    this.imageUrl,
  });
}

class ExchangeView extends BaseView<ExchangeController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: 'Exchange');
  }

  List<DropdownExchangeItem> dropdownItems = [
    DropdownExchangeItem(
      value: 'item1',
      title: 'Item 1',
      imageUrl: AppImages.logo,
    ),
    DropdownExchangeItem(
      value: 'item2',
      title: 'Item 2',
      imageUrl: AppImages.logo,
    ),
    DropdownExchangeItem(
      value: 'item3',
      title: 'Item 3',
      imageUrl: AppImages.logo,
    ),
  ];

  _dropdownItem(DropdownExchangeItem item) {
    return DropdownMenuItem<DropdownExchangeItem>(
      value: item,
      child: Row(
        children: [
          Image.asset(
            item.imageUrl!,
            width: 30,
            height: 30,
          ),
          SizedBox(width: 10),
          Text(
            item.title!,
            style: extraSmallBodyTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _dropdownMenu(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: smallBodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        // create a dropdown button
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: DropdownButton<DropdownExchangeItem>(
            dropdownColor: Colors.white,
            isExpanded: true,
            underline: Container(),
            // add a dropdown button item
            items: [
              ...dropdownItems.map((item) {
                return _dropdownItem(item);
              }),
            ],
            // add a hint text
            hint: Text(
              'Select Item',
              style: extraSmallBodyTextStyle.copyWith(
                color: Colors.grey,
              ),
            ),
            // add a value
            value: dropdownItems[0],
            // add a onChanged function
            onChanged: (value) {
              print(value);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        width: double.infinity,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exchange Here!',
              style: regularBodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _dropdownMenu('Send'),
            SizedBox(height: 10),
            Center(
              child: Icon(
                Icons.swap_horiz,
                size: 30,
              ),
            ),
            SizedBox(height: 10),
            _dropdownMenu('Receive'),
            SizedBox(height: 20),
            CustomButton(
              label: "Exchange",
              onPressed: () {},
              isSmallBtn: true,
            ),
          ],
        ),
      ),
    );
  }
}
