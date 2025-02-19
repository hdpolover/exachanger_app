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
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(),
    );
    Get.lazyPut<RateController>(
      () => RateController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<ExchangeController>(
      () => ExchangeController(),
    );
  }
}
