import 'dart:io';
import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_loading_dialog.dart';
import 'package:exachanger_get_app/app/data/models/transaction_model.dart';
import 'package:exachanger_get_app/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmExchangeView extends BaseView<ExchangeController> {
  final ImagePicker _picker = ImagePicker();
  final RxBool _isProofUploaded = false.obs;
  final Rx<File?> _proofImage = Rx<File?>(null);
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => _handleBackPressed(context),
      ),
      title: Text(
        'Exchange',
        style: appBarTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<void> _handleBackPressed(BuildContext context) async {
    final args = Get.arguments as Map<String, dynamic>?;
    final transaction = args?['transaction'] as TransactionModel?;

    // Always show confirmation dialog, regardless of transaction ID
    // Users should be warned before leaving this confirmation page
    final result = await Get.dialog<bool>(
      Dialog(
        backgroundColor: Colors.transparent,
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 420,
              maxHeight: MediaQuery.of(Get.context!).size.height * 0.8,
            ),
            margin: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with icon and title
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(32, 40, 32, 24),
                      child: Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.warning_rounded,
                              color: Colors.red.shade600,
                              size: 36,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Cancel Transaction?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You\'re about to cancel your exchange transaction',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ), // Warning content
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 28),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Colors.red.shade600,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'What happens when you cancel:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildWarningItem(
                            'Transaction will be permanently deleted',
                            Icons.delete_forever_rounded,
                          ),
                          SizedBox(height: 10),
                          _buildWarningItem(
                            'You\'ll need to start over completely',
                            Icons.restart_alt_rounded,
                          ),
                          SizedBox(height: 10),
                          _buildWarningItem(
                            'This action cannot be undone',
                            Icons.block_rounded,
                          ),
                        ],
                      ),
                    ), // Confirmation message
                    Container(
                      padding: EdgeInsets.fromLTRB(32, 24, 32, 28),
                      child: Text(
                        'Are you sure you want to proceed with canceling this transaction?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),

                    // Action buttons - responsive layout
                    Container(
                      padding: EdgeInsets.fromLTRB(28, 0, 28, 32),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Use column layout for very small screens
                          if (constraints.maxWidth < 300) {
                            return Column(
                              children: [
                                _buildGoBackButton(),
                                SizedBox(height: 16),
                                _buildCancelButton(),
                              ],
                            );
                          }
                          // Use row layout for larger screens
                          return Row(
                            children: [
                              Expanded(child: _buildGoBackButton()),
                              SizedBox(width: 16),
                              Expanded(child: _buildCancelButton()),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (result == true) {
      // If transaction has an ID, delete it from the server
      if (transaction?.id != null) {
        // Show loading with enhanced dialog
        Get.dialog(
          CustomLoadingDialog(
            message: 'Canceling transaction...',
            backgroundColor: Colors.white,
            textColor: Colors.black87,
          ),
          barrierDismissible: false,
        );

        // Delete the transaction
        final deleteSuccess = await controller.deleteTransaction(
          transaction!.id!,
        );

        // Close loading dialog
        Get.back();

        if (deleteSuccess) {
          Get.back(); // Go back to previous page
          Get.snackbar(
            'Transaction Canceled',
            'The transaction has been successfully canceled.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to cancel the transaction. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // If no transaction ID, just go back (no server deletion needed)
        Get.back();
        Get.snackbar(
          'Transaction Canceled',
          'You have left the transaction confirmation page.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _pickImage() async {
    // Show bottom sheet to choose camera or gallery
    final result = await Get.bottomSheet<ImageSource>(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: ImageSource.camera),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Theme.of(Get.context!).primaryColor,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Camera',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: ImageSource.gallery),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 40,
                            color: Theme.of(Get.context!).primaryColor,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Gallery',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
    if (result != null) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: result,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 80,
        );
        if (pickedFile != null) {
          // Enhanced file validation
          String filePath = pickedFile.path;
          String fileName = filePath.split('/').last;
          String fileExtension = '';

          if (fileName.contains('.')) {
            fileExtension = fileName.split('.').last.toLowerCase();
          }

          List<String> supportedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

          print('🔍 Image Selection Debug:');
          print('📁 File path: $filePath');
          print('📄 File name: $fileName');
          print('🔖 Extension: $fileExtension');
          print('✅ Is valid: ${supportedExtensions.contains(fileExtension)}');

          if (!supportedExtensions.contains(fileExtension)) {
            Get.snackbar(
              'Invalid File Type',
              'Please select a valid image file (JPG, PNG, JPEG, or WebP)',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }

          _proofImage.value = File(pickedFile.path);
          _isProofUploaded.value = true;

          print('✅ Image selected successfully: $fileName');
        }
      } catch (e) {
        print('Error picking image: $e');
        Get.snackbar(
          'Error',
          'Failed to pick image: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _openWhatsApp({
    required String transactionId,
    required String fromProduct,
    required String toProduct,
    required String name,
    required double amountSent,
    required double fee,
    required double amountReceive,
  }) async {
    final message =
        '''Hello Admin, please process my transaction:

Exchange
Transaction ID: $transactionId
From: $fromProduct
To: $toProduct
Name: $name
Send: \$ ${amountSent.toStringAsFixed(2)}
Fee: \$ ${fee.toStringAsFixed(2)}
Receive: \$ ${amountReceive.toStringAsFixed(2)}

Thank you'''; // Admin's phone number (including country code without +)
    final phoneNumber = '6281234216445'; // Admin number: +62 812-3421-6445
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'https://wa.me/$phoneNumber?text=$encodedMessage';

    try {
      final Uri uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open WhatsApp. Please make sure WhatsApp is installed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error opening WhatsApp: $e');
      Get.snackbar(
        'Error',
        'Failed to open WhatsApp: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _confirmPayment({
    required TransactionModel transaction,
    required dynamic sendProduct,
    required dynamic receiveRate,
    required double sendAmount,
    required double fee,
    required double receiveAmount,
  }) async {
    if (!_isProofUploaded.value || _proofImage.value == null) {
      Get.snackbar(
        'Error',
        'Please upload payment proof first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (transaction.id == null || transaction.id!.isEmpty) {
      Get.snackbar(
        'Error',
        'Transaction ID not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show loading dialog
    Get.dialog(
      CustomLoadingDialog(
        message: 'Uploading payment proof...',
        backgroundColor: Colors.white,
        textColor: Colors.black87,
      ),
      barrierDismissible: false,
    );

    try {
      // Upload payment proof
      final success = await controller.uploadPaymentProof(
        transactionId: transaction.id!,
        proofFile: _proofImage.value!,
      );

      // Close loading dialog
      Get.back();

      if (success) {
        // Show success alert with WhatsApp option
        await Get.dialog(
          AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Container(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Payment Proof Uploaded',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your payment proof has been uploaded successfully. Please contact our admin via WhatsApp to process your transaction.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Transaction will be processed within 24 hours',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          Get.offAllNamed(Routes.MAIN);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          _openWhatsApp(
                            transactionId:
                                transaction.trxCode ?? transaction.id ?? '',
                            fromProduct: sendProduct?.name ?? 'Unknown',
                            toProduct: receiveRate?.product?.name ?? 'Unknown',
                            name: 'User', // You can get this from user profile
                            amountSent: sendAmount,
                            fee: fee,
                            amountReceive: receiveAmount,
                          );
                          Get.offAllNamed(Routes.MAIN);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.chat, size: 18),
                        label: Text(
                          'Contact Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      Get.back();

      Get.snackbar(
        'Error',
        'Failed to upload payment proof. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget body(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final transaction = args != null
        ? args['transaction'] as TransactionModel
        : null;
    final sendProduct = args != null ? args['sendProduct'] : null;
    final receiveRate = args != null ? args['receiveRate'] : null;
    final double sendAmount = args != null ? args['sendAmount'] ?? 0.0 : 0.0;
    final double receiveAmount = args != null
        ? args['receiveAmount'] ?? 0.0
        : 0.0;
    final double fee = args != null ? args['fee'] ?? 1.0 : 1.0;

    if (transaction == null) {
      return Center(child: Text('Transaction data not found'));
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          await _handleBackPressed(context);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction ID Highlight Section - Make it prominent
            if (transaction.trxCode != null && transaction.trxCode!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Transaction Created Successfully',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Transaction Code (User-friendly ID)
                    Text(
                      'Transaction Code',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            transaction.trxCode!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: transaction.trxCode!),
                            );
                            Get.snackbar(
                              'Copied',
                              'Transaction Code copied to clipboard',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 2),
                            );
                          },
                          icon: Icon(
                            Icons.copy,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.all(8),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Ready for payment',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Exchange Information Header
            Row(
              children: [
                Text(
                  'Exchange ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (sendProduct != null) ...[
                  if (sendProduct.image != null &&
                      sendProduct.image!.isNotEmpty)
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
                  Text(
                    sendProduct.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  Text(
                    receiveRate.product.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),

            SizedBox(height: 24), // Transaction Details
            Text(
              'Transaction Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            _buildDetailRow(
              'Transaction Date',
              transaction.createdAt != null
                  ? _formatDate(DateTime.parse(transaction.createdAt!))
                  : _formatDate(DateTime.now()),
            ),
            if (receiveRate != null &&
                receiveRate.product != null &&
                receiveRate.product.name == 'USDT')
              _buildDetailRow(
                'USDT BEP20 Address',
                transaction.transferMeta?.value ?? '',
                canCopy: true,
              ),
            _buildDetailRow(
              'Amount Send',
              '\$${sendAmount.toStringAsFixed(2)}',
            ),
            _buildDetailRow(
              'Amount Receive',
              '\$${receiveAmount.toStringAsFixed(2)}',
            ),
            _buildExchangeRateRow(sendProduct, receiveRate),
            _buildDetailRow('Fee', '\$${fee.toStringAsFixed(2)}'),

            SizedBox(height: 16),

            // Amount to Pay Section
            Text(
              'Amount to Pay',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${sendAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: sendAmount.toStringAsFixed(2)),
                    );
                    Get.snackbar(
                      'Copied',
                      'Amount copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                    );
                  },
                  icon: Icon(Icons.copy, size: 16),
                  label: Text('Copy', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            SizedBox(height: 16), // Pay to Section
            Text(
              'Pay to',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),

            // Instructions for payment
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Payment Instructions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'To complete your transaction, send the exact amount shown above to the account details below. Make sure to use the exact amount to avoid processing delays.',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '⚠️ Important: Send payment to the account below only',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildPayToSection(transaction, sendProduct),

            SizedBox(height: 24),

            // Upload Proof of Payment
            Text(
              'Upload Proof of Payment',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 16),
            Obx(
              () => GestureDetector(
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
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap to upload',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'JPG, PNG, JPEG or WebP (MAX. 800x800px)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(height: 24), // Confirm Payment Button
            Obx(
              () => CustomButton(
                label: _isProofUploaded.value
                    ? 'Confirm Payment'
                    : 'Upload Payment Proof First',
                onPressed: _isProofUploaded.value
                    ? () {
                        _confirmPayment(
                          transaction: transaction,
                          sendProduct: sendProduct,
                          receiveRate: receiveRate,
                          sendAmount: sendAmount,
                          fee: fee,
                          receiveAmount: receiveAmount,
                        );
                      }
                    : () {
                        Get.snackbar(
                          'Upload Required',
                          'Please upload your payment proof before confirming',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                      },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
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
      'December',
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
              Text(
                value,
                style: smallBodyTextStyle.copyWith(fontWeight: FontWeight.w500),
              ),
              if (canCopy)
                IconButton(
                  padding: EdgeInsets.only(left: 4),
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.copy, size: 16),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    Get.snackbar(
                      'Copied',
                      'Copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: Duration(seconds: 2),
                    );
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
            decoration: BoxDecoration(color: Colors.grey[200]),
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
                Text(
                  receiveRate != null ? '${receiveRate.pricing ?? ''} USD' : '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayToSection(TransactionModel transaction, dynamic sendProduct) {
    // Use transfer_data directly from sendProduct passed from the exchange page
    dynamic transferData;

    // Check sendProduct for transfer_data (from exchange page arguments)
    // Try different ways to access transfer_data based on the product structure
    try {
      if (sendProduct != null) {
        // Try accessing as a property first
        if (sendProduct.transferData != null) {
          transferData = sendProduct.transferData;
        }
        // Try accessing via toJson() if it's a model object
        else if (sendProduct.toJson != null) {
          final productJson = sendProduct.toJson();
          if (productJson['transfer_data'] != null) {
            transferData = productJson['transfer_data'];
          }
        }
        // If sendProduct is already a Map (raw JSON)
        else if (sendProduct is Map && sendProduct['transfer_data'] != null) {
          transferData = sendProduct['transfer_data'];
        }
      }
    } catch (e) {
      print('Error accessing transfer_data: $e');
    }

    // If no transfer_data found, show message
    if (transferData == null) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.orange.shade50,
        ),
        child: Column(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700, size: 24),
            SizedBox(width: 8),
            Text(
              'Payment Information Not Available',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Please go back to the exchange page to ensure all payment details are loaded properly.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange.shade600, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // If no transfer data value is available, show a message
    if (transferData is Map &&
        (transferData['value'] == null ||
            transferData['value']?.isEmpty == true)) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.orange.shade50,
        ),
        child: Column(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700, size: 24),
            SizedBox(height: 8),
            Text(
              'Payment Information Not Available',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Our team will provide payment details shortly. Please wait for further instructions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange.shade600, fontSize: 12),
            ),
          ],
        ),
      );
    } // Determine payment method info based on transfer data type and product
    String paymentMethodName = _getPaymentMethodName(transferData, sendProduct);
    Color paymentMethodColor = _getPaymentMethodColor(
      transferData,
      sendProduct,
    );
    String copyLabel = _getCopyLabel(transferData);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            paymentMethodColor.withOpacity(0.1),
            paymentMethodColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: paymentMethodColor.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: paymentMethodColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment method header
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: paymentMethodColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  paymentMethodName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified,
                      color: Colors.green.shade700,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Official Account',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Payment details
          Text(
            copyLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),

          // Payment value with prominent styling
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transferData is Map
                      ? (transferData['value'] ?? '')
                      : transferData.value ?? '',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12),

                // Copy button - more prominent
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      String value = transferData is Map
                          ? (transferData['value'] ?? '')
                          : transferData.value ?? '';
                      Clipboard.setData(ClipboardData(text: value));
                      Get.snackbar(
                        'Copied!',
                        '$copyLabel copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: Duration(seconds: 2),
                        icon: Icon(Icons.check_circle, color: Colors.white),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: paymentMethodColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.content_copy, size: 18),
                    label: Text(
                      'Copy ${copyLabel}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Security notice
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.amber.shade700, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Double-check this account before sending payment',
                    style: TextStyle(
                      color: Colors.amber.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName(dynamic transferData, dynamic sendProduct) {
    // Get the type from transferData (either Map or object)
    String? type = transferData is Map
        ? transferData['type']
        : transferData?.type;

    // Check transfer data type first
    if (type?.toLowerCase() == 'email') {
      return 'PayPal';
    }
    if (type?.toLowerCase() == 'address') {
      // If it's an address, check if the product name suggests a specific method
      String? productName = sendProduct is Map
          ? sendProduct['name']
          : sendProduct?.name;
      if (productName?.toLowerCase().contains('usdt') == true ||
          productName?.toLowerCase().contains('usdc') == true ||
          productName?.toLowerCase().contains('btc') == true) {
        return '$productName Wallet';
      }
      return 'Crypto Wallet';
    }
    if (type?.toLowerCase() == 'phone') {
      return 'Mobile Payment';
    }
    if (type?.toLowerCase() == 'bank') {
      return 'Bank Account';
    }

    // Fallback: try to determine from product name
    String? productName = sendProduct is Map
        ? sendProduct['name']
        : sendProduct?.name;
    if (productName?.toLowerCase().contains('paypal') == true) {
      return 'PayPal';
    }

    return 'Payment Method';
  }

  Color _getPaymentMethodColor(dynamic transferData, dynamic sendProduct) {
    // Get the type from transferData (either Map or object)
    String? type = transferData is Map
        ? transferData['type']
        : transferData?.type;
    String? productName = sendProduct is Map
        ? sendProduct['name']
        : sendProduct?.name;

    // Check transfer data type first
    if (type?.toLowerCase() == 'email') {
      return Colors.blue;
    }
    if (type?.toLowerCase() == 'address') {
      if (productName?.toLowerCase().contains('btc') == true) {
        return Colors.orange;
      }
      if (productName?.toLowerCase().contains('usdt') == true) {
        return Colors.green;
      }
      if (productName?.toLowerCase().contains('usdc') == true) {
        return Colors.blue;
      }
      return Colors.purple;
    }
    if (type?.toLowerCase() == 'phone') {
      return Colors.green;
    }
    if (type?.toLowerCase() == 'bank') {
      return Colors.indigo;
    }

    // Fallback
    return Colors.blue;
  }

  String _getCopyLabel(dynamic transferData) {
    // Get the type from transferData (either Map or object)
    String? type = transferData is Map
        ? transferData['type']
        : transferData?.type;

    // Check transfer data type
    if (type?.toLowerCase() == 'email') {
      return 'Email';
    }
    if (type?.toLowerCase() == 'address') {
      return 'Address';
    }
    if (type?.toLowerCase() == 'phone') {
      return 'Phone number';
    }
    if (type?.toLowerCase() == 'bank') {
      return 'Account details';
    }

    return 'Payment info';
  }

  Widget _buildWarningItem(String text, [IconData? icon]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2),
          child: Icon(
            icon ?? Icons.circle,
            color: Colors.red.shade600,
            size: icon != null ? 18 : 6,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 14,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoBackButton() {
    return Container(
      height: 48,
      child: OutlinedButton(
        onPressed: () => Get.back(result: false),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(
            color: Theme.of(Get.context!).primaryColor,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                size: 16,
                color: Theme.of(Get.context!).primaryColor,
              ),
              SizedBox(width: 4),
              Text(
                'Go Back',
                style: TextStyle(
                  color: Theme.of(Get.context!).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Container(
      height: 48,
      child: ElevatedButton(
        onPressed: () => Get.back(result: true),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cancel_rounded, size: 16),
              SizedBox(width: 6),
              Text(
                'Yes, Cancel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
