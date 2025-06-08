import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/animated_custom_button.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_loading_dialog.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
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

  // Helper method to build breakdown rows
  Widget _buildBreakdownRow(
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isTotal ? Colors.blue.shade800 : Colors.blue.shade600,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              color: isTotal ? Colors.blue.shade800 : Colors.blue.shade700,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: 'Proceed Exchange');
  }

  double calculateFee(dynamic feeValue, int feeType, double amount) {
    if (feeValue == null) return 0.0;

    double fee = double.tryParse(feeValue.toString()) ?? 0.0;

    // fee_type 0 = flat amount in USD, fee_type 2 = percentage
    // This fee comes from the receive product (receiveRate.fee and receiveRate.feeType)
    if (feeType == 2) {
      return (amount * fee) / 100; // percentage fee
    } else {
      return fee; // flat fee
    }
  }

  // Helper method to get the correct fee values based on receive product type
  Map<String, dynamic> getFeeValues(
    dynamic receiveRate,
    dynamic selectedBlockchain,
  ) {
    if (receiveRate == null) {
      return {'feeValue': null, 'feeType': 0};
    }

    // Check if receive product is a blockchain type
    bool isBlockchainReceiveProduct = _isBlockchainReceiveProduct(
      receiveRate,
      selectedBlockchain,
    );

    if (isBlockchainReceiveProduct) {
      // For blockchain receive products, prioritize selected blockchain fee
      if (selectedBlockchain != null && selectedBlockchain.fee != null) {
        print(
          'Using selected blockchain fee: ${selectedBlockchain.fee}, type: ${selectedBlockchain.feeType}',
        ); // Debug
        return {
          'feeValue': selectedBlockchain.fee,
          'feeType': selectedBlockchain.feeType ?? 0,
        };
      } else {
        // Fallback to receive rate fee if no blockchain selected or no blockchain fee
        print(
          'Using receive rate fee fallback: ${receiveRate.fee}, type: ${receiveRate.feeType}',
        ); // Debug
        return {
          'feeValue': receiveRate.fee,
          'feeType': receiveRate.feeType ?? 0,
        };
      }
    } else {
      // For non-blockchain receive products, use receive rate fee
      print(
        'Using receive rate fee for non-blockchain: ${receiveRate.fee}, type: ${receiveRate.feeType}',
      ); // Debug
      return {'feeValue': receiveRate.fee, 'feeType': receiveRate.feeType ?? 0};
    }
  }

  void updateCalculations(String amountStr, {dynamic receiveRate}) {
    print('updateCalculations called with: $amountStr'); // Debug

    // Use passed receiveRate or try to get from arguments
    var currentReceiveRate = receiveRate;
    if (currentReceiveRate == null) {
      final productData = Get.arguments as Map<String, dynamic>?;
      print('Get.arguments: $productData'); // Debug
      print('Keys in arguments: ${productData?.keys}'); // Debug
      currentReceiveRate = productData?['receiveRate'];
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

    // Check maximum amount limit
    const double maxAmount = 99999.99;
    if (amount != null && amount > maxAmount) {
      Get.snackbar(
        'Amount Too High',
        'Maximum amount is ${maxAmount.toStringAsFixed(2)} USD.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (amount != null && amount > 0 && exchangeRate > 0) {
      print('Valid amount: $amount'); // Debug
      controller.setInputAmount(amount);

      // Get the correct fee values based on receive product type and selected blockchain
      final selectedBlockchain = controller.selectedBlockchain.value;
      final feeValues = getFeeValues(currentReceiveRate, selectedBlockchain);

      // Calculate fee using the appropriate fee structure
      double fee = calculateFee(
        feeValues['feeValue'],
        feeValues['feeType'],
        amount,
      );
      print(
        'Fee calculated: $fee (from ${feeValues['feeValue']}, type: ${feeValues['feeType']})',
      ); // Debug

      // For blockchain receive products, ensure we're using blockchain fee
      bool isBlockchainReceiveProduct = _isBlockchainReceiveProduct(
        currentReceiveRate,
        selectedBlockchain,
      );
      if (isBlockchainReceiveProduct) {
        print('Using blockchain fee calculation for receive product'); // Debug
      }

      // Calculate received amount after fee deduction from send amount
      double amountAfterFee = amount - fee;
      double receivedAmount = amountAfterFee * exchangeRate;
      print(
        'Received amount: $receivedAmount (after fee: $amountAfterFee × rate: $exchangeRate)',
      ); // Debug

      controller.setCalculatedAmount(receivedAmount);
    } else {
      print('Invalid amount or exchange rate'); // Debug
      controller.setInputAmount(0.0);
      controller.setCalculatedAmount(0.0);
    }
  }

  // Helper method to determine if receive product is blockchain-based
  bool _isBlockchainReceiveProduct(
    dynamic receiveRate,
    dynamic selectedBlockchain,
  ) {
    if (receiveRate?.product?.category?.toLowerCase() == 'blockchain')
      return true;
    if (receiveRate?.product?.name?.toLowerCase().contains('blockchain') ==
        true)
      return true;
    if (selectedBlockchain != null) return true;
    return false;
  }

  @override
  Widget body(BuildContext context) {
    final arguments = Get.arguments;
    if (arguments == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Error: Missing required data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please go back and try again',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: () => Get.back(), child: Text('Go Back')),
          ],
        ),
      );
    }

    final productData = arguments as Map<String, dynamic>;
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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 120,
        ),
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
                    'Max Amount: 99,999.99 USD',
                    style: smallBodyTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Section 2: Blockchain Selection moved here
            if (sendProduct?.blockchains != null &&
                sendProduct!.blockchains!.isNotEmpty) ...[
              SizedBox(height: 24),
              NumberedSectionHeader(
                number: 2,
                title: 'Select Blockchain & Address',
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  BlockchainSelector(
                    blockchains: sendProduct.blockchains!,
                    controller: controller,
                    onBlockchainChanged: (blockchain) {
                      // Trigger recalculation when blockchain changes
                      if (controller.inputAmount.value > 0) {
                        updateCalculations(
                          controller.inputAmount.value.toString(),
                          receiveRate: receiveRate,
                        );
                      }
                    },
                  ),
                  WalletAddressInput(controller: controller),
                ],
              ),
            ], // Rate and Fee Section (without header)
            SizedBox(height: 10),
            // Exchange Rate section
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
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

            // Fee Information Section
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.orange.shade700,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Transaction Fee',
                            style: smallBodyTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Obx(() {
                          final inputAmount = controller.inputAmount.value;
                          final selectedBlockchain =
                              controller.selectedBlockchain.value;
                          double currentFee = 0.0;
                          String feeText = '\$1.00';
                          String feeDescription = '';
                          // Determine which fee to use based on receive product type
                          dynamic feeValue;
                          int feeType = 0;
                          if (receiveRate != null && inputAmount > 0) {
                            // Get the correct fee values based on receive product type
                            final feeValues = getFeeValues(
                              receiveRate,
                              selectedBlockchain,
                            );
                            feeValue = feeValues['feeValue'];
                            feeType = feeValues['feeType'];

                            currentFee = calculateFee(
                              feeValue,
                              feeType,
                              inputAmount,
                            );

                            if (currentFee > 0) {
                              if (feeType == 2) {
                                feeText =
                                    '${feeValue}% (\$${currentFee.toStringAsFixed(2)})';
                                feeDescription = 'Percentage fee applied';
                              } else {
                                feeText = '\$${currentFee.toStringAsFixed(2)}';
                                feeDescription = 'Fixed fee applied';
                              }
                            }
                          } else if (receiveRate != null) {
                            // Show default fee when no input amount
                            final feeValues = getFeeValues(
                              receiveRate,
                              selectedBlockchain,
                            );
                            feeValue = feeValues['feeValue'];
                            feeType = feeValues['feeType'];

                            if (feeType == 2) {
                              feeText = '${feeValue}%';
                              feeDescription = 'Percentage fee will be applied';
                            } else {
                              double defaultFee =
                                  double.tryParse(
                                    feeValue?.toString() ?? '1.0',
                                  ) ??
                                  1.0;
                              feeText = '\$${defaultFee.toStringAsFixed(2)}';
                              feeDescription = 'Fixed fee will be applied';
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                feeText,
                                style: smallBodyTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (feeDescription.isNotEmpty && inputAmount > 0)
                                Text(
                                  feeDescription,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange.shade600,
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                  Obx(() {
                    final selectedBlockchain =
                        controller.selectedBlockchain.value;
                    String feeSourceText = '';
                    if (receiveRate != null) {
                      bool isBlockchainReceiveProduct =
                          _isBlockchainReceiveProduct(
                            receiveRate,
                            selectedBlockchain,
                          );

                      if (isBlockchainReceiveProduct &&
                          selectedBlockchain != null) {
                        feeSourceText =
                            'This fee is charged by ${selectedBlockchain.name ?? 'the selected blockchain'} and will be deducted from your send amount.';
                      } else {
                        feeSourceText =
                            'This fee is charged by ${receiveRate.product?.name ?? 'the receive product'} and will be deducted from your send amount.';
                      }
                    }

                    return Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        feeSourceText,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Receive Amount Section with Breakdown
            SizedBox(height: 12),
            Text('The recipient will receive'),
            SizedBox(height: 8),
            Obx(() {
              final calculatedAmount = controller.calculatedAmount.value;
              final inputAmount = controller.inputAmount.value;
              print(
                'Obx rebuilding - calculatedAmount: $calculatedAmount',
              ); // Debug

              return Column(
                children: [
                  // Main receive amount display
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ),
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
                              color: Colors.grey.shade700,
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
                        Container(
                          padding: EdgeInsets.all(6.0),
                          child: receiveRate?.product?.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    receiveRate!.product!.image!,
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.currency_exchange,
                                        size: 20,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.currency_exchange,
                                  size: 20,
                                  color: Colors.grey.shade600,
                                ),
                        ),
                      ],
                    ),
                  ), // Calculation breakdown (show when there's an input amount)
                  if (inputAmount > 0 && receiveRate != null) ...[
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Obx(() {
                        final selectedBlockchain =
                            controller.selectedBlockchain.value;
                        final feeValues = getFeeValues(
                          receiveRate,
                          selectedBlockchain,
                        );
                        final feeValue = feeValues['feeValue'];
                        final feeType = feeValues['feeType'];

                        return Column(
                          children: [
                            Text(
                              'Calculation Breakdown',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            SizedBox(height: 6),
                            _buildBreakdownRow(
                              'Send Amount:',
                              '\$${inputAmount.toStringAsFixed(2)}',
                            ),
                            _buildBreakdownRow(
                              'Fee Deducted:',
                              '-\$${calculateFee(feeValue, feeType, inputAmount).toStringAsFixed(2)}',
                            ),
                            Divider(height: 8, color: Colors.blue.shade300),
                            _buildBreakdownRow(
                              'Amount After Fee:',
                              '\$${(inputAmount - calculateFee(feeValue, feeType, inputAmount)).toStringAsFixed(2)}',
                            ),
                            _buildBreakdownRow(
                              'Exchange Rate:',
                              '× ${receiveRate.pricing?.toString() ?? '0.99'}',
                            ),
                            Divider(height: 8, color: Colors.blue.shade300),
                            _buildBreakdownRow(
                              'Final Amount:',
                              '\$${calculatedAmount.toStringAsFixed(2)}',
                              isTotal: true,
                            ),
                          ],
                        );
                      }),
                    ),
                  ] else if (inputAmount > 0) ...[
                    // Debug info when receiveRate is null
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        'Debug: receiveRate is null, cannot show breakdown',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Show message when no amount entered
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        'Enter an amount to see calculation breakdown',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              );
            }),

            // Continue Button
            SizedBox(height: 24),
            Container(
              width: double.infinity,
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

                    // Validate maximum amount
                    const double maxAmount = 99999.99;

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

                    if (controller.inputAmount.value > maxAmount) {
                      Get.snackbar(
                        'Amount Too High',
                        'Maximum amount is ${maxAmount.toStringAsFixed(2)} USD.',
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
                      // Calculate current fee based on receive product type and selected blockchain
                      double currentFee = 0.0;
                      if (receiveRate != null) {
                        final selectedBlockchain =
                            controller.selectedBlockchain.value;
                        final feeValues = getFeeValues(
                          receiveRate,
                          selectedBlockchain,
                        );

                        currentFee = calculateFee(
                          feeValues['feeValue'],
                          feeValues['feeType'],
                          controller.inputAmount.value,
                        );
                      }

                      // Create transaction with total including the original amount
                      // Note: The fee is deducted before exchange rate calculation,
                      // but the total sent by user remains the same
                      final transaction = await controller.createTransaction(
                        amount: controller.inputAmount.value,
                        total: controller
                            .inputAmount
                            .value, // Total amount user sends
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
                        // Check if it's an authentication error
                        if (controller.transactionError.value
                                .toLowerCase()
                                .contains('authentication') ||
                            controller.transactionError.value
                                .toLowerCase()
                                .contains('invalid token') ||
                            controller.transactionError.value
                                .toLowerCase()
                                .contains('unauthorized')) {
                          Get.snackbar(
                            'Session Expired',
                            'Your session has expired. Please sign in again to continue.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                            duration: Duration(seconds: 4),
                            onTap: (_) {
                              // Clear user data and tokens
                              try {
                                final preferenceManager =
                                    PreferenceManagerImpl();
                                preferenceManager.logout();
                              } catch (e) {}
                              // Navigate to sign-in page
                              Get.offAllNamed(Routes.SIGN_IN);
                            },
                            mainButton: TextButton(
                              onPressed: () {
                                Get.back(); // Close snackbar
                                // Clear user data and tokens
                                try {
                                  final preferenceManager =
                                      PreferenceManagerImpl();
                                  preferenceManager.logout();
                                } catch (e) {}
                                // Navigate to sign-in page
                                Get.offAllNamed(Routes.SIGN_IN);
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        } else {
                          Get.snackbar(
                            'Error',
                            controller.transactionError.value.isNotEmpty
                                ? controller.transactionError.value
                                : 'Failed to create transaction. Please try again.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      }
                    } catch (e) {
                      // Close loading dialog
                      Get.back();

                      // Better error handling for different types of errors
                      String errorMessage =
                          'Failed to create transaction. Please try again.';
                      Color backgroundColor = Colors.red;
                      String title = 'Error';

                      // Check if it's an authentication error
                      String errorString = e.toString().toLowerCase();
                      if (errorString.contains('authentication') ||
                          errorString.contains('invalid token') ||
                          errorString.contains('unauthorized') ||
                          errorString.contains('401')) {
                        title = 'Session Expired';
                        errorMessage =
                            'Your session has expired. Please sign in again to continue.';
                        backgroundColor = Colors.orange;
                        Get.snackbar(
                          title,
                          errorMessage,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: backgroundColor,
                          colorText: Colors.white,
                          duration: Duration(seconds: 4),
                          onTap: (_) {
                            // Clear user data and tokens
                            try {
                              final preferenceManager = PreferenceManagerImpl();
                              preferenceManager.logout();
                            } catch (e) {}
                            // Navigate to sign-in page
                            Get.offAllNamed(Routes.SIGN_IN);
                          },
                          mainButton: TextButton(
                            onPressed: () {
                              Get.back(); // Close snackbar
                              // Clear user data and tokens
                              try {
                                final preferenceManager =
                                    PreferenceManagerImpl();
                                preferenceManager.logout();
                              } catch (e) {}
                              // Navigate to sign-in page
                              Get.offAllNamed(Routes.SIGN_IN);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                        return;
                      }

                      // Check if it's a network error
                      if (errorString.contains('network') ||
                          errorString.contains('connection') ||
                          errorString.contains('timeout')) {
                        errorMessage =
                            'Please check your internet connection and try again.';
                        backgroundColor = Colors.orange;
                        title = 'Connection Error';
                      }

                      Get.snackbar(
                        title,
                        errorMessage,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: backgroundColor,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
