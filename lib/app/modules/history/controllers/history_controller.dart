import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/repository/transaction/transaction_repository.dart';
import 'package:exachanger_get_app/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/models/transaction_model.dart';

class HistoryController extends BaseController {
  final TransactionRepository transactionRepository = Get.find(
    tag: (TransactionRepository).toString(),
  );

  //transactions
  Rx<List<TransactionModel>> transactionList = Rx<List<TransactionModel>>([]);
  final isLoading = false.obs;
  final error = ''.obs;

  List<TransactionModel> get transactions => transactionList.value;

  HomeController homeController = Get.find<HomeController>();

  // Check if navigated from home view
  final RxBool isFromHome = false.obs;

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
