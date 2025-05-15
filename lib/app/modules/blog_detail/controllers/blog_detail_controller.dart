import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';

class BlogDetailController extends BaseController {
  // get home controller

  BlogModel blogModel = Get.arguments;

  @override
  void onInit() {
    super.onInit();

    // print('BlogDetailController onInit');
    // print('Blog ID: $blogId');

    // // Use parameter
    // if (blogId != null) {
    //   PromoModel? promo = homeController.promos.firstWhere(
    //     (element) => element.id == blogId,
    //     orElse: () => PromoModel(),
    //   );

    //   print(promo);

    //   setPromoModel(promo);
    // }
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
