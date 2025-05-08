import 'package:get/get.dart';

import '../controllers/promo_detail_controller.dart';

class PromoDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoDetailController>(
      () => PromoDetailController(),
    );
  }
}
