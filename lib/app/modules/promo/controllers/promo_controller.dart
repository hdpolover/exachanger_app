import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:get/get.dart';

class PromoController extends BaseController {
  List<PromoModel> promos = [];
  Rx<PromoModel?> selectedPromo = Rx<PromoModel?>(null);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is List<PromoModel>) {
      promos = Get.arguments;
    } else if (Get.arguments is PromoModel) {
      selectedPromo.value = Get.arguments;
    }
  }

  void selectPromo(PromoModel promo) {
    selectedPromo.value = promo;
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
