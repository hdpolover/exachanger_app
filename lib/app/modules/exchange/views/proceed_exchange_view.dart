import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/animated_custom_button.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_loading_dialog.dart';
import 'package:exachanger_get_app/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/amount_text_field.dart';
import 'widgets/blockchain_selector.dart';
import 'widgets/exchange_header.dart';
import 'widgets/numbered_section_header.dart';
import 'widgets/wallet_address_input.dart';

class ProceedExchangeView extends BaseView<ExchangeController> {
  // Utility function to safely extract substring from product names
  String _safeSubstring(String? text, int start, int end, String fallback) {
    if (text == null || text.isEmpty) return fallback;
    if (start >= text.length) return fallback;
    int actualEnd = end > text.length ? text.length : end;
    return text.substring(start, actualEnd).toUpperCase();
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: 'Proceed Exchange');
  }

  double calculateFee(dynamic feeValue, int feeType, double amount) {
    if (feeValue == null) return 0.0;

    double fee = double.tryParse(feeValue.toString()) ?? 0.0;

    // fee_type 0 = flat amount in USD, fee_type 2 = percentage
    if (feeType == 2) {
      return (amount * fee) / 100; // percentage fee
    } else {
      return fee; // flat fee
    }
  }

  void updateCalculations(String amountStr, {dynamic receiveRate}) {
    print(
      'updateCalculations called with: $amountStr',
    ); // Debug    // Use passed receiveRate or try to get from arguments
    var currentReceiveRate = receiveRate;
    if (currentReceiveRate == null) {
      final productData = Get.arguments as Map<String, dynamic>?;
      print('Get.arguments: $productData'); // Debug
      print('Keys in arguments: ${productData?.keys}'); // Debug
      currentReceiveRate =
          productData?['receiveRate']; // Fixed: was 'rate', should banye 'receiveRate'
    }

    print('currentReceiveRate: $currentReceiveRate'); // Debug
    if (currentReceiveRate == null) {
      print('receiveRate is null'); // Debug
      controller.setInputAmount(0.0);
      controller.setCalculatedAmount(0.0);
      return;
    }

    final double exchangeRate = currentReceiveRate.pricing != null
        ? double.tryParse(currentReceiveRate.pricing.toString()) ?? 0.0
        : 0.0;
    print('Exchange rate: $exchangeRate'); // Debug
    double? amount = double.tryParse(amountStr);
    if (amount != null && amount > 0 && exchangeRate > 0) {
      print('Valid amount: $amount'); // Debug
      controller.setInputAmount(amount);

      // Calculate fee
      double fee = calculateFee(
        currentReceiveRate.fee,
        currentReceiveRate.feeType ?? 0,
        amount,
      );
      print('Fee calculated: $fee'); // Debug

      // Calculate received amount after fee deduction
      double amountAfterFee = amount - fee;
      double receivedAmount = amountAfterFee * exchangeRate;
      print('Received amount: $receivedAmount'); // Debug

      controller.setCalculatedAmount(receivedAmount);
    } else {
      print('Invalid amount or exchange rate'); // Debug
      controller.setInputAmount(0.0);
      controller.setCalculatedAmount(0.0);
    }
  }

  @override
  Widget body(BuildContext context) {
    final productData = Get.arguments as Map<String, dynamic>;
    final sendProduct =
        productData['sendProduct']; // Fixed: was 'product', should be 'sendProduct'
    final receiveRate =
        productData['receiveRate']; // Fixed: was 'rate', should be 'receiveRate'

    // Initialize blockchain selection if product has blockchains
    if (sendProduct?.blockchains != null &&
        sendProduct.blockchains!.isNotEmpty &&
        controller.selectedBlockchain.value == null) {
      controller.setSelectedBlockchain(sendProduct.blockchains!.first);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExchangeHeader(sendProduct: sendProduct, receiveRate: receiveRate),
          SizedBox(height: 24),

          // Send Amount Section
          NumberedSectionHeader(number: 1, title: 'Enter Amount'),
          SizedBox(height: 16),
          Text('The money you will send'),
          SizedBox(height: 8),
          AmountTextField(
            product: sendProduct,
            onAmountChanged: (amount) =>
                updateCalculations(amount, receiveRate: receiveRate),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  receiveRate?.minimumAmount != null
                      ? 'Min Amount: ${receiveRate!.minimumAmount} USD'
                      : 'Min Amount: 1 USD',
                  style: smallBodyTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  'Max Amount: 5000 USD',
                  style: smallBodyTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ), // Receive Amount Section
          SizedBox(height: 16),
          Text('The recipient will receive'),
          SizedBox(height: 8),
          Obx(() {
            final calculatedAmount = controller.calculatedAmount.value;
            print(
              'Obx rebuilding - calculatedAmount: $calculatedAmount',
            ); // Debug

            return Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  // Prefix $ icon
                  if (calculatedAmount > 0)
                    Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  SizedBox(width: calculatedAmount > 0 ? 4 : 0),

                  // Amount text or placeholder
                  Expanded(
                    child: Text(
                      calculatedAmount > 0
                          ? calculatedAmount.toStringAsFixed(2)
                          : 'Calculated amount',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: calculatedAmount > 0
                            ? Colors.black
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),

                  // Currency icon
                  if (receiveRate?.product?.image != null)
                    Container(
                      padding: EdgeInsets.all(6.0),
                      child: Image.network(
                        receiveRate!.product!.image!,
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.currency_exchange, size: 20);
                        },
                      ),
                    )
                  else
                    Icon(
                      Icons.currency_exchange,
                      size: 20,
                      color: Colors.grey.shade600,
                    ),
                ],
              ),
            );
          }), // Exchange Rate section
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exchange Rate', style: smallBodyTextStyle),
                SizedBox(width: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _safeSubstring(sendProduct?.name, 0, 1, 'P'),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    Text(' 1 USD = ', style: smallBodyTextStyle),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _safeSubstring(receiveRate?.product?.name, 0, 1, 'U'),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    Text(
                      ' ${receiveRate?.pricing?.toString() ?? '0.99'} USD',
                      style: smallBodyTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Fee', style: smallBodyTextStyle),
              Flexible(
                child: Obx(() {
                  final inputAmount = controller.inputAmount.value;
                  double currentFee = 0.0;
                  String feeText = '\$1.00';

                  if (receiveRate != null && inputAmount > 0) {
                    currentFee = calculateFee(
                      receiveRate.fee,
                      receiveRate.feeType ?? 0,
                      inputAmount,
                    );

                    if (currentFee > 0) {
                      if (receiveRate.feeType == 2) {
                        feeText = '${receiveRate.fee}%';
                      } else {
                        feeText = '\$${currentFee.toStringAsFixed(2)}';
                      }
                    }
                  } else if (receiveRate != null) {
                    // Show default fee when no input amount
                    if (receiveRate.feeType == 2) {
                      feeText = '${receiveRate.fee}%';
                    } else {
                      double defaultFee =
                          double.tryParse(
                            receiveRate.fee?.toString() ?? '1.0',
                          ) ??
                          1.0;
                      feeText = '\$${defaultFee.toStringAsFixed(2)}';
                    }
                  }

                  return Text(
                    feeText,
                    style: smallBodyTextStyle,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),
            ],
          ), // Blockchain Selection Section
          SizedBox(height: 24),
          if (sendProduct?.blockchains != null &&
              sendProduct!.blockchains!.isNotEmpty) ...[
            NumberedSectionHeader(
              number: 2,
              title: 'Select Blockchain & Address',
            ),
            SizedBox(height: 16),
            BlockchainSelector(
              blockchains: sendProduct.blockchains!,
              controller: controller,
            ),
            SizedBox(height: 16),
            WalletAddressInput(controller: controller),
          ], // Continue Button
          SizedBox(height: 24),
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () => AnimatedCustomButton(
                label: 'Continue',
                isLoading: controller.isCreatingTransaction.value,
                loadingText: 'Creating...',
                onPressed: () async {
                  // Validate minimum amount
                  double minimumAmount = receiveRate?.minimumAmount != null
                      ? double.tryParse(
                              receiveRate!.minimumAmount.toString(),
                            ) ??
                            1.0
                      : 1.0;

                  if (controller.inputAmount.value <= 0) {
                    Get.snackbar(
                      'Invalid Amount',
                      'Please enter a valid amount greater than 0.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  if (controller.inputAmount.value < minimumAmount) {
                    Get.snackbar(
                      'Amount Too Low',
                      'Minimum amount is ${minimumAmount.toStringAsFixed(2)} USD.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  if (sendProduct?.blockchains != null &&
                      sendProduct!.blockchains!.isNotEmpty) {
                    bool hasValidBlockchain =
                        controller.selectedBlockchain.value != null;
                    bool hasValidAddress = controller.isValidWalletAddress();
                    if (!hasValidBlockchain || !hasValidAddress) {
                      Get.snackbar(
                        'Required Fields',
                        'Please select a blockchain network and enter a valid wallet address.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                  }

                  // Show loading with custom animated dialog
                  Get.dialog(
                    CustomLoadingDialog(
                      message: 'Creating transaction...',
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                    ),
                    barrierDismissible: false,
                  );
                  try {
                    // Calculate current fee
                    double currentFee = 0.0;
                    if (receiveRate != null) {
                      currentFee = calculateFee(
                        receiveRate.fee,
                        receiveRate.feeType ?? 0,
                        controller.inputAmount.value,
                      );
                    } // Create transaction
                    final transaction = await controller.createTransaction(
                      amount: controller.inputAmount.value,
                      total: controller.inputAmount.value + currentFee,
                    );

                    // Close loading dialog
                    Get.back();

                    if (transaction != null) {
                      // Store current values before clearing
                      final sendAmount = controller.inputAmount.value;
                      final receiveAmount = controller.calculatedAmount.value;

                      // Clear amount values after successful transaction creation
                      controller.clearAmounts();

                      // Navigate to confirm page
                      Get.toNamed(
                        Routes.CONFIRM_EXCHANGE,
                        arguments: {
                          'transaction': transaction,
                          'sendProduct': sendProduct,
                          'receiveRate': receiveRate,
                          'sendAmount': sendAmount,
                          'receiveAmount': receiveAmount,
                          'fee': currentFee,
                          'blockchain': controller.selectedBlockchain.value,
                          'walletAddress': controller.walletAddress.value,
                        },
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        controller.transactionError.value,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } catch (e) {
                    // Close loading dialog
                    Get.back();

                    Get.snackbar(
                      'Error',
                      'Failed to create transaction. Please try again.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
