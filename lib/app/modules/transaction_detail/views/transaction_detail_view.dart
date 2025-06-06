import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/utils/common_functions.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:exachanger_get_app/app/core/widgets/status_chip.dart';
import 'package:exachanger_get_app/app/data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/transaction_detail_controller.dart';

class TransactionDetailView extends BaseView<TransactionDetailController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: 'Transaction Detail');
  }

  @override
  Widget body(BuildContext context) {
    final transaction = controller.transaction;
    // Safely get products - handle the case where products list might be null or empty
    final products =
        transaction.products != null && transaction.products!.isNotEmpty
        ? transaction.products!.first
        : null;

    // Extract from and to objects for exchange details
    final From? from = products?.productMeta?.from;
    final To? to = products?.productMeta?.to;

    // Check if wallet address exists for conditional display
    String? walletAddress = transaction.transferMeta?.walletAddress;
    bool hasWalletAddress =
        walletAddress != null && walletAddress.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction Info Section
          _buildSectionHeader('Transaction Info'),
          _buildInfoItem(
            'Transaction ID',
            transaction.trxCode ?? 'EXA-001928191',
          ),
          _buildInfoItem(
            'Transaction Date',
            _formatTransactionDate(transaction.createdAt),
          ),
          _buildInfoItem(
            'Transaction Status',
            StatusChip(status: transaction.status ?? 1),
            isWidget: true,
          ),

          const SizedBox(height: 20),

          // Exchange Transaction Section
          _buildSectionHeader('Exchange Transaction'),
          _buildExchangeDetails(from, to, products),

          const SizedBox(height: 20),

          // Blockchain Address Section (conditional)
          if (hasWalletAddress) ...[
            _buildSectionHeader(_getBlockchainAddressLabel(from)),
            _buildAddressField(walletAddress),
            const SizedBox(height: 20),
          ],

          // Payment Section
          _buildSectionHeader('Payment'),
          _buildPaymentDetails(from, to, transaction),

          const SizedBox(height: 24),

          // Payment Proof Button (conditional)
          if (transaction.paymentProof != null &&
              transaction.paymentProof!.isNotEmpty) ...[
            CustomButton(
              label: 'View Payment Proof',
              onPressed: () {
                // Open payment proof image or document
                print('View payment proof: ${transaction.paymentProof}');
              },
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: regularBodyTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, dynamic value, {bool isWidget = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: smallBodyTextStyle.copyWith(color: Colors.grey)),
          isWidget
              ? value
              : Text(
                  '$value',
                  style: regularBodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildExchangeDetails(From? from, To? to, Products? products) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // From side
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: smallBodyTextStyle.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: from?.image ?? '',
                          width: 24,
                          height: 24,
                          errorWidget: (context, url, error) => Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _safeSubstring(from?.name, 0, 1, 'P'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          from?.name ?? 'Paypal',
                          style: regularBodyTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CommonFunctions.formatUSD(products?.amount ?? 500.00),
                      style: regularBodyTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Icons.arrow_forward, color: Colors.grey),

              // To side
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'To',
                      style: smallBodyTextStyle.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CachedNetworkImage(
                          imageUrl: to?.product?.image ?? '',
                          width: 24,
                          height: 24,
                          errorWidget: (context, url, error) => Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _safeSubstring(to?.product?.name, 0, 1, 'U'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          to?.product?.name ?? 'USDT',
                          style: regularBodyTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CommonFunctions.formatUSD(products?.subTotal ?? 494.00),
                      style: regularBodyTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Exchange Rate section
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
                    ),
                    child: Text(
                      _safeSubstring(from?.name, 0, 1, 'P'),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  Text(' 1 USD = ', style: smallBodyTextStyle),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.rectangle,
                    ),
                    child: Text(
                      _safeSubstring(to?.product?.name, 0, 1, 'U'),
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  Text(
                    ' ${_getExchangeRate(to)} USD',
                    style: smallBodyTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Get exchange rate from transaction data
  String _getExchangeRate(To? to) {
    if (to?.pricing != null) {
      return to!.pricing!.toStringAsFixed(2);
    }
    return '0.99'; // Default fallback
  }

  // Safely extracts a substring from a potentially null or empty string
  String _safeSubstring(String? text, int start, int end, String fallback) {
    if (text == null || text.isEmpty || text.length <= start) {
      return fallback;
    }
    return text.substring(start, text.length < end ? text.length : end);
  }

  // Safely formats the transaction date
  String _formatTransactionDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'December 12, 2024'; // Default fallback date
    }

    try {
      // Try parsing with standard ISO format
      final date = DateTime.parse(dateStr);
      return CommonFunctions.formatDateTime(date);
    } catch (e) {
      // If standard parsing fails, try different format or return the raw string
      try {
        // Some APIs return dates in different formats
        if (dateStr.contains('/')) {
          final parts = dateStr.split('/');
          if (parts.length == 3) {
            final date = DateTime(
              int.parse(parts[2]), // year
              int.parse(parts[1]), // month
              int.parse(parts[0]), // day
            );
            return CommonFunctions.formatDateTime(date);
          }
        }
      } catch (_) {
        // Fall through to return the raw string
      }

      // Return the original string if all parsing attempts fail
      return dateStr;
    }
  }

  Widget _buildAddressField(String address) {
    // Handle empty or null address gracefully
    if (address.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'No address provided',
          style: smallBodyTextStyle.copyWith(color: Colors.grey),
        ),
      );
    }

    // Format the address for better readability (if it's a typical blockchain address)
    String displayAddress = address;
    if (address.startsWith('0x') && address.length > 20) {
      displayAddress =
          '${address.substring(0, 10)}...${address.substring(address.length - 10)}';
    } else if (address.length > 20) {
      // For other long addresses, also truncate for display
      displayAddress =
          '${address.substring(0, 10)}...${address.substring(address.length - 10)}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayAddress,
                  style: smallBodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tap to copy full address',
                  style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: address));
              Get.snackbar(
                'Copied!',
                'Address copied to clipboard',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
    );
  }

  // Get appropriate blockchain address label based on the transaction data
  String _getBlockchainAddressLabel(From? from) {
    if (from == null) return 'Wallet Address';

    String label = from.code ?? 'Wallet';

    // If there are blockchains, use the first one's name
    if (from.blockchains != null && from.blockchains!.isNotEmpty) {
      String blockchainName =
          from.blockchains![0].name ?? from.blockchains![0].code ?? '';
      if (blockchainName.isNotEmpty) {
        label = '$label $blockchainName';
      }
    }

    return '$label Address';
  }

  // Build payment details section with actual transaction data
  Widget _buildPaymentDetails(
    From? from,
    To? to,
    TransactionModel transaction,
  ) {
    // Determine payment method based on transaction data
    String paymentMethod = 'Bank Transfer'; // Default
    if (from?.name != null) {
      paymentMethod = from!.name!;
    }

    // Calculate or get fees
    double fees = 0.0;
    if (from?.price?.fee != null) {
      fees = from!.price!.fee!;
    }

    // Get amounts from transfer meta if available
    String receivedAmount = CommonFunctions.formatUSD(transaction.total ?? 0.0);
    if (transaction.transferMeta?.amount != null) {
      try {
        double amount = double.parse(transaction.transferMeta!.amount!);
        receivedAmount = CommonFunctions.formatUSD(amount);
      } catch (e) {
        // Keep default if parsing fails
      }
    }

    return Column(
      children: [
        _buildInfoItem('Payment Method', paymentMethod),
        if (fees > 0) _buildInfoItem('Fees', CommonFunctions.formatUSD(fees)),
        _buildInfoItem('Amount Received', receivedAmount),
        if (transaction.total != null)
          _buildInfoItem(
            'Total Transaction',
            CommonFunctions.formatUSD(transaction.total!),
          ),
      ],
    );
  }
}
