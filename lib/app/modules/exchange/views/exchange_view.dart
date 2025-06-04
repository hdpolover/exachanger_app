import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/utils/common_functions.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/models/rate_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/exchange_controller.dart';

class ExchangeView extends BaseView<ExchangeController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    // Get the state before building the widget
    bool isFixedProduct = controller.isFixedSendProduct.value;
    return CustomAppBar(
      appBarTitleText:
          isFixedProduct && controller.selectedSendProduct.value != null
              ? 'Exchange ${controller.selectedSendProduct.value!.name}'
              : 'Exchange',
      // Enable back button when coming from home view with a fixed product
      isBackButtonEnabled: isFixedProduct,
    );
  }

  DropdownMenuItem<ProductModel> _productDropdownItem(ProductModel product) {
    return DropdownMenuItem<ProductModel>(
      value: product,
      child: Row(
        children: [
          product.image != null
              ? CachedNetworkImage(
                  imageUrl: product.image!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 30,
                    height: 30,
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AppImages.noImage,
                    width: 30,
                    height: 30,
                  ),
                )
              : Image.asset(
                  AppImages.logo,
                  width: 30,
                  height: 30,
                ),
          SizedBox(width: 10),
          Text(
            product.name ?? 'Unknown',
            style: extraSmallBodyTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<RateModel> _rateDropdownItem(RateModel rate) {
    return DropdownMenuItem<RateModel>(
      value: rate,
      child: Row(
        children: [
          rate.product?.image != null
              ? CachedNetworkImage(
                  imageUrl: rate.product!.image!,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 30,
                    height: 30,
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AppImages.noImage,
                    width: 30,
                    height: 30,
                  ),
                )
              : Image.asset(
                  AppImages.logo,
                  width: 30,
                  height: 30,
                ),
          SizedBox(width: 10),
          Text(
            rate.product?.name ?? 'Unknown',
            style: extraSmallBodyTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          // SizedBox(width: 5),
          // Text(
          //   "(${CommonFunctions.formatUSD(rate.pricing is int ? (rate.pricing as int).toDouble() : (rate.pricing ?? 0.0))})",
          //   style: extraSmallBodyTextStyle.copyWith(
          //     color: Colors.grey,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _sendDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send',
          style: smallBodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Obx(() {
          // Handle loading state
          if (controller.isLoading.value) {
            return Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // Handle fixed product mode (when coming from home page)
          if (controller.isFixedSendProduct.value &&
              controller.selectedSendProduct.value != null) {
            final product = controller.selectedSendProduct.value!;
            return Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300),
                color:
                    Colors.grey.shade50, // Light gray to indicate non-editable
              ),
              child: Row(
                children: [
                  product.image != null
                      ? CachedNetworkImage(
                          imageUrl: product.image!,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 30,
                            height: 30,
                            color: Colors.grey[200],
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            AppImages.noImage,
                            width: 30,
                            height: 30,
                          ),
                        )
                      : Image.asset(
                          AppImages.logo,
                          width: 30,
                          height: 30,
                        ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      product.name ?? 'Unknown',
                      style: extraSmallBodyTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Add an indicator to show this selection is fixed
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            );
          }

          // Handle empty products case
          if (controller.productsWithRates.value.isEmpty) {
            return Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No products available',
                  style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
                ),
              ),
            );
          }

          // Show dropdown with products (standard mode)
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<ProductModel>(
              dropdownColor: Colors.white,
              isExpanded: true,
              underline: Container(),
              items: controller.productsWithRates.value
                  .map((product) => _productDropdownItem(product))
                  .toList(),
              hint: Text(
                'Select Send Product',
                style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
              ),
              value: controller.selectedSendProduct.value,
              onChanged: (value) {
                if (value != null) {
                  controller.selectSendProduct(value);
                }
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _receiveDropdown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receive',
          style: smallBodyTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Obx(() {
          // Check if a send product is selected first
          if (controller.selectedSendProduct.value == null) {
            return Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select a send product first',
                  style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
                ),
              ),
            );
          }

          // Handle empty rates
          if (controller.availableReceiveOptions.value.isEmpty) {
            return Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'No exchange options available',
                  style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
                ),
              ),
            );
          }

          // Show dropdown with rates
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<RateModel>(
              dropdownColor: Colors.white,
              isExpanded: true,
              underline: Container(),
              items: controller.availableReceiveOptions.value
                  .map((rate) => _rateDropdownItem(rate))
                  .toList(),
              hint: Text(
                'Select Receive Product',
                style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
              ),
              value: controller.selectedReceiveRate.value,
              onChanged: (value) {
                if (value != null) {
                  controller.selectReceiveRate(value);
                }
              },
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    print(
        "Building Exchange view body - fixed product mode: ${controller.isFixedSendProduct.value}");
    print(
        "Selected send product: ${controller.selectedSendProduct.value?.name}");

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
            Obx(() {
              if (controller.isFixedSendProduct.value &&
                  controller.selectedSendProduct.value != null) {
                return Text(
                  'Exchange ${controller.selectedSendProduct.value!.name}',
                  style: regularBodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                return Text(
                  'Exchange Here!',
                  style: regularBodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            }),
            SizedBox(height: 20),
            _sendDropdown(),
            SizedBox(height: 10),
            Center(
              child: Icon(
                Icons.swap_horiz,
                size: 30,
              ),
            ),
            SizedBox(height: 10),
            _receiveDropdown(),
            SizedBox(height: 20),
            Obx(() {
              bool canExchange = controller.selectedSendProduct.value != null &&
                  controller.selectedReceiveRate.value != null;
              return CustomButton(
                label: "Exchange",
                onPressed: canExchange
                    ? () {
                        // Navigate to proceed exchange screen, passing selected product and rate as arguments
                        Get.toNamed('/proceed-exchange', arguments: {
                          'sendProduct': controller.selectedSendProduct.value,
                          'receiveRate': controller.selectedReceiveRate.value,
                        });
                      }
                    : () {},
                isSmallBtn: true,
              );
            }),
          ],
        ),
      ),
    );
  }
}
