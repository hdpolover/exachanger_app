import 'dart:io';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:exachanger_get_app/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmExchangeView extends BaseView<ExchangeController> {
  final ImagePicker _picker = ImagePicker();
  final RxBool _isProofUploaded = false.obs;
  final Rx<File?> _proofImage = Rx<File?>(null);

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Exchange',
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        _proofImage.value = File(pickedFile.path);
        _isProofUploaded.value = true;
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget body(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final sendProduct = args != null ? args['sendProduct'] : null;
    final receiveRate = args != null ? args['receiveRate'] : null;
    final double sendAmount = args != null ? args['sendAmount'] ?? 0.0 : 0.0;
    final double receiveAmount =
        args != null ? args['receiveAmount'] ?? 0.0 : 0.0;
    final double fee = args != null ? args['fee'] ?? 1.0 : 1.0;

    // Get a unique transaction ID
    final String transactionId =
        'EXA-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    // Format the date
    final DateTime transactionDate = DateTime.now();
    final String formattedDate =
        '${_getMonthName(transactionDate.month)} ${transactionDate.day}, ${transactionDate.year}';

    // Demo USDT address (this should come from API or database in production)
    final String usdtAddress = '0x4f9778b95ad945adf8e2fdbcfdce38ca754a295e970';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exchange Information Header
          Row(
            children: [
              Text('Exchange ', style: TextStyle(fontWeight: FontWeight.bold)),
              if (sendProduct != null) ...[
                if (sendProduct.image != null && sendProduct.image!.isNotEmpty)
                  Image.network(
                    sendProduct.image!,
                    width: 18,
                    height: 18,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.currency_exchange, size: 18);
                    },
                  )
                else
                  Icon(Icons.currency_exchange, size: 18),
                SizedBox(width: 4),
                Text(sendProduct.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(' → '),
              ],
              if (receiveRate != null && receiveRate.product != null) ...[
                if (receiveRate.product!.image != null &&
                    receiveRate.product!.image!.isNotEmpty)
                  Image.network(
                    receiveRate.product!.image!,
                    width: 18,
                    height: 18,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.currency_exchange, size: 18);
                    },
                  )
                else
                  Icon(Icons.currency_exchange, size: 18),
                SizedBox(width: 4),
                Text(receiveRate.product.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ],
          ),

          SizedBox(height: 24),

          // Payment Step Indicator
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Text('Payment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),

          SizedBox(height: 20),

          // Transaction Details
          Text('Transaction Details',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _buildDetailRow('Transaction ID', transactionId),
          _buildDetailRow('Transaction Date', formattedDate),
          if (receiveRate != null &&
              receiveRate.product != null &&
              receiveRate.product.name == 'USDT')
            _buildDetailRow(
              'USDT BEP20 Address',
              usdtAddress,
              canCopy: true,
            ),
          _buildDetailRow('Amount Send', '\$${sendAmount.toStringAsFixed(2)}'),
          _buildDetailRow(
              'Amount Recieve', '\$${receiveAmount.toStringAsFixed(2)}'),
          _buildExchangeRateRow(sendProduct, receiveRate),
          _buildDetailRow('Fee', '\$${fee.toStringAsFixed(2)}'),

          SizedBox(height: 16),

          // Amount to Pay Section
          Text('Amount to Pay',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${sendAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  )),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: sendAmount.toStringAsFixed(2)));
                  showToast('Amount copied to clipboard');
                },
                icon: Icon(Icons.copy, size: 16),
                label: Text('Copy', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Pay to Section
          Text('Pay to',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 40,
                height: 40,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            title: Text('Paypal'),
            subtitle: Text('vebryexa@gmail.com'),
            trailing: TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: 'vebryexa@gmail.com'));
                showToast('Email copied to clipboard');
              },
              icon: Icon(Icons.copy, size: 16),
              label: Text('Copy', style: TextStyle(fontSize: 12)),
            ),
          ),

          SizedBox(height: 24),

          // Upload Proof of Payment
          Text('Upload Proof of Payment',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 16),
          Obx(() => GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isProofUploaded.value && _proofImage.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _proofImage.value!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined,
                                size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Click to upload or drag and drop',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'SVG, PNG, JPG or GIF (MAX. 800x400px)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ),
              )),

          SizedBox(height: 24),

          // Confirm Payment Button
          Obx(() => CustomButton(
                label: 'Confirm Payment',
                onPressed: _isProofUploaded.value
                    ? () {
                        // Handle payment confirmation
                        Get.offAllNamed(Routes.MAIN, arguments: {
                          'showSuccess': true,
                          'message':
                              'Your exchange has been successfully submitted. Our team will process it shortly.',
                          'transactionId': transactionId
                        });
                      }
                    : () {}, // Disable button if proof is not uploaded
              )),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  Widget _buildDetailRow(String label, String value, {bool canCopy = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: smallBodyTextStyle),
          Row(
            children: [
              Text(value,
                  style:
                      smallBodyTextStyle.copyWith(fontWeight: FontWeight.w500)),
              if (canCopy)
                IconButton(
                  padding: EdgeInsets.only(left: 4),
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.copy, size: 16),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    showToast('Copied to clipboard');
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateRow(dynamic sendProduct, dynamic receiveRate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Exchange Rate', style: smallBodyTextStyle),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                if (sendProduct != null && sendProduct.image != null)
                  Image.network(
                    sendProduct.image!,
                    width: 18,
                    height: 18,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.currency_exchange, size: 18);
                    },
                  )
                else
                  Icon(Icons.currency_exchange, size: 18),
                SizedBox(width: 4),
                Text('1 USD = '),
                if (receiveRate != null && receiveRate.product != null)
                  Image.network(
                    receiveRate.product!.image!,
                    width: 18,
                    height: 18,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.currency_exchange, size: 18);
                    },
                  )
                else
                  Icon(Icons.currency_exchange, size: 18),
                SizedBox(width: 4),
                Text(receiveRate != null
                    ? '${receiveRate.pricing ?? ''} USD'
                    : ''),
              ],
            ),
          )
        ],
      ),
    );
  }
}
