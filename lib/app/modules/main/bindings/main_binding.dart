import 'package:exachanger_get_app/app/data/remote/transaction/transaction_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/remote/transaction/transaction_remote_data_source_impl.dart';
import 'package:exachanger_get_app/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:exachanger_get_app/app/modules/history/controllers/history_controller.dart';
import 'package:exachanger_get_app/app/modules/home/controllers/home_controller.dart';
import 'package:exachanger_get_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:exachanger_get_app/app/modules/rate/controllers/rate_controller.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Main dependencies
    Get.lazyPut<MainController>(() => MainController());

    // Register services needed by nested views
    Get.put<TransactionRemoteDataSource>(
      TransactionRemoteDataSourceImpl(),
      permanent: true,
    );

    // Register controllers for nested views
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<HistoryController>(HistoryController(), permanent: true);
    Get.lazyPut<RateController>(() => RateController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    // Use lazyPut for ExchangeController to ensure fresh instance when needed
    Get.lazyPut<ExchangeController>(() => ExchangeController(), fenix: true);
  }
}
