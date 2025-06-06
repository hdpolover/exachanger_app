import 'dart:io';
import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/models/rate_model.dart';
import 'package:exachanger_get_app/app/data/models/blockchain_model.dart';
import 'package:exachanger_get_app/app/data/models/transaction_model.dart';
import 'package:exachanger_get_app/app/data/remote/transaction/transaction_remote_data_source.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExchangeController extends BaseController {
  // Dependencies
  final TransactionRemoteDataSource _transactionDataSource = Get.find();
  late final DataService _dataService;

  // Products and rates data
  final Rx<List<ProductModel>> productsWithRates = Rx<List<ProductModel>>([]);
  final Rx<ProductModel?> selectedSendProduct = Rx<ProductModel?>(null);
  final Rx<List<RateModel>> availableReceiveOptions = Rx<List<RateModel>>([]);
  final Rx<RateModel?> selectedReceiveRate = Rx<RateModel?>(null);

  // Exchange amounts
  final RxDouble inputAmount = 0.0.obs;
  final RxDouble calculatedAmount = 0.0.obs;

  // Blockchain and wallet
  final Rx<BlockchainModel?> selectedBlockchain = Rx<BlockchainModel?>(null);
  final RxString walletAddress = RxString('');

  // State management
  final RxBool isFixedSendProduct = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingTransaction = false.obs;
  final RxString error = ''.obs;
  final RxString transactionError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _dataService = Get.find<DataService>();
    _resetState();
    _handleNavigationArguments();
    loadProductsWithRates();
  }

  void _handleNavigationArguments() {
    final arguments = Get.arguments;
    print("DEBUG: Navigation arguments received: $arguments");

    if (arguments != null && arguments is Map<String, dynamic>) {
      print("DEBUG: Arguments is a Map with keys: ${arguments.keys}");

      if (arguments['fixedProduct'] != null && arguments['fromHome'] == true) {
        final ProductModel fixedProduct = arguments['fixedProduct'];
        print(
          "DEBUG: Setting fixed product mode - Product: ${fixedProduct.name}",
        );

        isFixedSendProduct.value = true;
        selectedSendProduct.value = fixedProduct;

        print(
          "DEBUG: isFixedSendProduct after setting: ${isFixedSendProduct.value}",
        );
        print(
          "DEBUG: selectedSendProduct after setting: ${selectedSendProduct.value?.name}",
        );

        // Load receive options for the fixed product
        loadReceiveOptionsForProduct(fixedProduct);
      } else {
        print("DEBUG: Not setting fixed product mode - conditions not met");
      }
    } else {
      print("DEBUG: No arguments received or arguments is not a Map");
    }
  }

  void _resetState() {
    // Don't reset selected product and fixed state if we're in fixed mode
    if (!isFixedSendProduct.value) {
      selectedSendProduct.value = null;
    }

    selectedReceiveRate.value = null;
    selectedBlockchain.value = null;
    walletAddress.value = '';
    inputAmount.value = 0.0;
    calculatedAmount.value = 0.0;
    error.value = '';
    transactionError.value = '';
  }

  // Method to reset controller state and handle new navigation arguments
  void resetAndHandleNewNavigation() {
    print("DEBUG: resetAndHandleNewNavigation called");

    // Reset all state first
    selectedSendProduct.value = null;
    selectedReceiveRate.value = null;
    selectedBlockchain.value = null;
    walletAddress.value = '';
    inputAmount.value = 0.0;
    calculatedAmount.value = 0.0;
    isFixedSendProduct.value = false;
    error.value = '';
    transactionError.value = '';

    // Handle new navigation arguments
    _handleNavigationArguments();
  }

  // Amount management methods
  void setInputAmount(double amount) {
    inputAmount.value = amount;
  }

  void setCalculatedAmount(double amount) {
    calculatedAmount.value = amount;
  }

  // Clear input and calculated amounts
  void clearAmounts() {
    inputAmount.value = 0.0;
    calculatedAmount.value = 0.0;
  }

  // Exchange operations
  void setSelectedBlockchain(BlockchainModel? blockchain) {
    selectedBlockchain.value = blockchain;
    // Reset wallet address when blockchain changes
    walletAddress.value = '';
  }

  void setWalletAddress(String address) {
    walletAddress.value = address;
  }

  bool isValidWalletAddress() {
    return walletAddress.value.isNotEmpty && walletAddress.value.length >= 10;
  }

  void loadProductsWithRates() async {
    try {
      error.value = '';

      // Get rates from data service
      final allProducts = await _dataService.productRepository.getAllProducts();

      // Filter products that have active rates
      final filteredProducts = allProducts.where((product) {
        // Check if product has rates and at least one active rate
        return product.rates != null &&
            product.rates!.isNotEmpty &&
            product.rates!.any((rate) => rate.status == 'active');
      }).toList();

      productsWithRates.value = filteredProducts;

      // If we have a fixed product but it's not in the loaded products,
      // we need to make sure it's still properly configured
      if (isFixedSendProduct.value && selectedSendProduct.value != null) {
        // Find the updated product data from the loaded products
        final updatedProduct = filteredProducts.firstWhereOrNull(
          (p) => p.id == selectedSendProduct.value!.id,
        );

        if (updatedProduct != null) {
          selectedSendProduct.value = updatedProduct;
          loadReceiveOptionsForProduct(updatedProduct);
        }
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to load exchange data: ${e.toString()}';

      // Show network error snackbar if it's a connectivity issue
      if (isNetworkError(e)) {
        showNetworkErrorSnackbar();
      }
    }
  }

  void loadReceiveOptionsForProduct(ProductModel product) {
    try {
      if (product.rates != null) {
        availableReceiveOptions.value = product.rates!
            .where((rate) => rate.status == 'active' && rate.product != null)
            .toList();

        selectedReceiveRate.value = availableReceiveOptions.value.isNotEmpty
            ? availableReceiveOptions.value.first
            : null;

        if (availableReceiveOptions.value.isEmpty) {
          error.value = 'No exchange options available for this product';
        }
      } else {
        availableReceiveOptions.value = [];
        selectedReceiveRate.value = null;
        error.value = 'No exchange options available for this product';
      }
    } catch (e) {
      error.value = 'Error loading exchange options: ${e.toString()}';
    }
  }

  void selectSendProduct(ProductModel product) {
    // Don't allow changing the product if it's fixed from home page
    if (isFixedSendProduct.value) {
      return;
    }

    selectedSendProduct.value = product;
    loadReceiveOptionsForProduct(product);
  }

  void selectReceiveRate(RateModel rate) {
    selectedReceiveRate.value = rate;
  }

  Future<TransactionModel?> createTransaction({
    required double amount,
    required double total,
  }) async {
    try {
      isCreatingTransaction.value = true;
      transactionError.value = '';

      if (selectedSendProduct.value == null ||
          selectedReceiveRate.value == null) {
        throw Exception('Please select send and receive products');
      }

      Map<String, String> userAccountTransfer = {
        'rate_id': selectedReceiveRate.value!.id!,
        'amount': amount.toString(),
        'total': total.toString(),
      };

      if (selectedBlockchain.value?.id != null) {
        userAccountTransfer['blockchain_id'] = selectedBlockchain.value!.id!;
      }

      if (walletAddress.value.isNotEmpty) {
        userAccountTransfer['wallet_address'] = walletAddress.value;
      }

      final transaction = await _transactionDataSource.createTransaction(
        rateId: selectedReceiveRate.value!.id!,
        amount: amount,
        total: total,
        blockchainId: selectedBlockchain.value?.id,
        blockchainAddress: walletAddress.value,
        userAccountTransfer: userAccountTransfer,
      );

      isCreatingTransaction.value = false;
      return transaction;
    } catch (e) {
      isCreatingTransaction.value = false;
      transactionError.value = 'Failed to create transaction: ${e.toString()}';

      // Show network error snackbar if it's a connectivity issue
      if (isNetworkError(e)) {
        showNetworkErrorSnackbar(
          customMessage:
              'Failed to create transaction. Please check your internet connection and try again.',
        );
      }

      return null;
    }
  }

  Future<bool> deleteTransaction(String transactionId) async {
    try {
      isLoading.value = true;
      final success = await _transactionDataSource.deleteTransaction(
        transactionId,
      );
      isLoading.value = false;
      return success;
    } catch (e) {
      isLoading.value = false;
      transactionError.value = 'Failed to delete transaction: ${e.toString()}';

      // Show network error snackbar if it's a connectivity issue
      if (isNetworkError(e)) {
        showNetworkErrorSnackbar(
          customMessage:
              'Failed to delete transaction. Please check your internet connection and try again.',
        );
      }

      return false;
    }
  }

  Future<bool> uploadPaymentProof({
    required String transactionId,
    required File proofFile,
  }) async {
    try {
      isLoading.value = true;

      final success = await _transactionDataSource.uploadPaymentProof(
        transactionId: transactionId,
        proofFile: proofFile,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Payment proof uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to upload payment proof',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error uploading payment proof: $e');
      Get.snackbar(
        'Error',
        'Failed to upload payment proof: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Force handle navigation arguments again when the route becomes ready
    // This ensures that if the controller is reused, it still handles new arguments
    print("DEBUG: onReady called, handling navigation arguments again");
    resetAndHandleNewNavigation();
  }

  @override
  void onClose() {
    // Fully reset state when controller is closed
    selectedSendProduct.value = null;
    selectedReceiveRate.value = null;
    selectedBlockchain.value = null;
    walletAddress.value = '';
    inputAmount.value = 0.0;
    calculatedAmount.value = 0.0;
    isFixedSendProduct.value = false;
    error.value = '';
    transactionError.value = '';
    super.onClose();
  }
}
