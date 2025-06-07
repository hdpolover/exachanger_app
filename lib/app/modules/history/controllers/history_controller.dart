import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/repository/transaction/transaction_repository.dart';
import 'package:exachanger_get_app/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/models/transaction_model.dart';
import '../../../data/models/product_model.dart';

class HistoryController extends BaseController {
  final TransactionRepository transactionRepository = Get.find(
    tag: (TransactionRepository).toString(),
  );

  //transactions
  Rx<List<TransactionModel>> transactionList = Rx<List<TransactionModel>>([]);
  Rx<List<TransactionModel>> filteredTransactionList =
      Rx<List<TransactionModel>>([]);
  final isLoading = false.obs;
  final error = ''.obs;

  List<TransactionModel> get transactions => filteredTransactionList.value;

  HomeController homeController = Get.find<HomeController>();

  // Check if navigated from home view
  final RxBool isFromHome = false.obs;

  // Filter states
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxList<String> selectedProductIds = <String>[].obs;
  final RxBool hasActiveFilters = false.obs;

  // Available products for filtering
  final RxList<ProductModel> availableProducts = <ProductModel>[].obs;

  // Loading state for products
  final RxBool isLoadingProducts = false.obs;

  // Refresh controller for pull-to-refresh
  RefreshController? _refreshController;

  RefreshController get refreshController {
    _refreshController ??= RefreshController(initialRefresh: false);
    return _refreshController!;
  }

  setInitialData() {
    isLoading.value = true;

    if (homeController.transactions.isNotEmpty) {
      transactionList.value = homeController.transactions;
      filteredTransactionList.value = List.from(transactionList.value);
      initializeAvailableProducts();
      // Small delay to ensure shimmer is visible even on fast loads
      Future.delayed(Duration(milliseconds: 300), () {
        isLoading.value = false;
      });
    } else {
      getData();
    }
  }

  getData() {
    isLoading.value = true;
    error.value = '';

    var transactionService = transactionRepository.getAllTransactions();

    callDataService(
      transactionService,
      onSuccess: (data) {
        transactionList.value = data;
        filteredTransactionList.value = List.from(data);
        initializeAvailableProducts();
        isLoading.value = false;
      },
      onError: (error) {
        showErrorMessage(error.toString());
        this.error.value = error.toString();
        isLoading.value = false;
      },
    );
  }

  // Method for pull-to-refresh
  Future<void> onRefresh() async {
    print("DEBUG - Pull to refresh triggered in History tab!");
    try {
      await refreshData();
      print("DEBUG - History refresh completed successfully");
      refreshController.refreshCompleted();
    } catch (error) {
      print("DEBUG - History refresh failed: $error");
      refreshController.refreshFailed();
    }
  }

  // Refresh data from API
  Future<void> refreshData() async {
    error.value = '';

    try {
      final data = await transactionRepository.getAllTransactions();
      transactionList.value = data;
      filteredTransactionList.value = List.from(data);
      initializeAvailableProducts();
      applyFilters(); // Reapply current filters to new data

      // Also update the HomeController with new transaction data
      if (Get.isRegistered<HomeController>()) {
        homeController.transactionList.value = data;
      }
    } catch (e) {
      error.value = 'Failed to load transactions: ${e.toString()}';
      print("Error refreshing transactions: $e");
      throw e;
    }
  }

  // Initialize available products for filtering
  void initializeAvailableProducts() {
    isLoadingProducts.value = true; // Start loading

    // Get unique products from all transactions using a Map to avoid duplicates
    Map<String, ProductModel> uniqueProductsMap = {};

    for (var transaction in transactionList.value) {
      if (transaction.products != null) {
        for (var product in transaction.products!) {
          if (product.productMeta?.from != null) {
            final fromId = product.productMeta!.from!.id;
            if (fromId != null && !uniqueProductsMap.containsKey(fromId)) {
              uniqueProductsMap[fromId] = ProductModel(
                id: product.productMeta!.from!.id,
                name: product.productMeta!.from!.name,
                code: product.productMeta!.from!.code,
                image: product.productMeta!.from!.image,
              );
            }
          }
          if (product.productMeta?.to?.product != null) {
            final toId = product.productMeta!.to!.product!.id;
            if (toId != null && !uniqueProductsMap.containsKey(toId)) {
              uniqueProductsMap[toId] = ProductModel(
                id: product.productMeta!.to!.product!.id,
                name: product.productMeta!.to!.product!.name,
                code: product.productMeta!.to!.product!.code,
                image: product.productMeta!.to!.product!.image,
              );
            }
          }
        }
      }
    }

    // Also include products from HomeController if available
    if (homeController.productList.value.isNotEmpty) {
      for (var product in homeController.productList.value) {
        if (product.id != null && !uniqueProductsMap.containsKey(product.id)) {
          uniqueProductsMap[product.id!] = product;
        }
      }
    }

    availableProducts.value = uniqueProductsMap.values.toList();
    isLoadingProducts.value = false; // End loading
  }

  // Apply filters to transactions
  void applyFilters() {
    List<TransactionModel> filtered = List.from(transactionList.value);

    // Filter by date range
    if (startDate.value != null || endDate.value != null) {
      filtered = filtered.where((transaction) {
        if (transaction.createdAt == null) return false;

        try {
          DateTime transactionDate = DateTime.parse(transaction.createdAt!);

          bool isAfterStart =
              startDate.value == null ||
              transactionDate.isAfter(startDate.value!) ||
              transactionDate.isAtSameMomentAs(startDate.value!);
          bool isBeforeEnd =
              endDate.value == null ||
              transactionDate.isBefore(endDate.value!.add(Duration(days: 1))) ||
              transactionDate.isAtSameMomentAs(endDate.value!);

          return isAfterStart && isBeforeEnd;
        } catch (e) {
          print('Error parsing date: ${transaction.createdAt}');
          return false;
        }
      }).toList();
    }

    // Filter by selected products
    if (selectedProductIds.isNotEmpty) {
      filtered = filtered.where((transaction) {
        if (transaction.products == null || transaction.products!.isEmpty) {
          return false;
        }

        // Check if any product in the transaction matches selected products
        return transaction.products!.any((product) {
          bool fromMatches =
              product.productMeta?.from?.id != null &&
              selectedProductIds.contains(product.productMeta!.from!.id);
          bool toMatches =
              product.productMeta?.to?.product?.id != null &&
              selectedProductIds.contains(product.productMeta!.to!.product!.id);
          return fromMatches || toMatches;
        });
      }).toList();
    }

    filteredTransactionList.value = filtered;
    updateFilterStatus();
  }

  // Update filter status
  void updateFilterStatus() {
    hasActiveFilters.value =
        startDate.value != null ||
        endDate.value != null ||
        selectedProductIds.isNotEmpty;
  }

  // Clear all filters
  void clearFilters() {
    startDate.value = null;
    endDate.value = null;
    selectedProductIds.clear();
    filteredTransactionList.value = List.from(transactionList.value);
    updateFilterStatus();
  }

  // Set date filter
  void setDateFilter(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    applyFilters();
  }

  // Toggle product selection
  void toggleProductSelection(String productId) {
    if (selectedProductIds.contains(productId)) {
      selectedProductIds.remove(productId);
    } else {
      selectedProductIds.add(productId);
    }
    applyFilters();
  }

  // Check if product is selected
  bool isProductSelected(String productId) {
    return selectedProductIds.contains(productId);
  }

  // Save filter state (optional - for persistence)
  void saveFilterState() {
    // You can implement this with SharedPreferences if needed
    // For now, we'll keep the filters in memory during the session
  }

  // Load filter state (optional - for persistence)
  void loadFilterState() {
    // You can implement this with SharedPreferences if needed
    // For now, we'll start with empty filters
  }

  // Debug method to print filter state
  void debugFilterState() {
    print('=== Filter Debug Info ===');
    print('Total transactions: ${transactionList.value.length}');
    print('Filtered transactions: ${filteredTransactionList.value.length}');
    print('Available products: ${availableProducts.length}');
    print('Selected products: ${selectedProductIds.length}');
    print('Start date: ${startDate.value}');
    print('End date: ${endDate.value}');
    print('Has active filters: ${hasActiveFilters.value}');
    print('=========================');
  }

  @override
  void onInit() {
    super.onInit();

    // Check if navigated from home view
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic> && arguments['fromHome'] == true) {
      isFromHome.value = true;
    }

    setInitialData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _refreshController?.dispose();
    super.onClose();
  }
}
