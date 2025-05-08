import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/repository/transaction/transaction_repository.dart';
import 'package:exachanger_get_app/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../../../data/model/transaction_model.dart';

class HistoryController extends BaseController {
  final TransactionRepository transactionRepository =
      Get.find(tag: (TransactionRepository).toString());

  //transactions
  Rx<List<TransactionModel>> transactionList = Rx<List<TransactionModel>>([]);

  List<TransactionModel> get transactions => transactionList.value;

  HomeController homeController = Get.find<HomeController>();

  setInitialData() {
    if (homeController.transactions.isNotEmpty) {
      transactionList.value = homeController.transactions;
    } else {
      getData();
    }
  }

  getData() {
    var transactionService = transactionRepository.getAllTransactions();

    callDataService(transactionService, onSuccess: (data) {
      transactionList.value = data;
    }, onError: (error) {
      showErrorMessage(error.toString());
    });
  }

  @override
  void onInit() {
    super.onInit();

    setInitialData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
