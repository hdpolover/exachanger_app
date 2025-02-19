import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/model/blog_model.dart';
import 'package:exachanger_get_app/app/data/model/promo_model.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
import 'package:get/get.dart';

import '../../../data/repository/promo/promo_repository.dart';

class HomeController extends BaseController {
  final PromoRepository promoRespository =
      Get.find(tag: (PromoRepository).toString());

  final BlogRepository blogRepository =
      Get.find(tag: (BlogRepository).toString());

  //promos
  Rx<List<PromoModel>> promoList = Rx<List<PromoModel>>([]);
  List<PromoModel> get promos => promoList.value;

  // blogs
  Rx<List<BlogModel>> blogList = Rx<List<BlogModel>>([]);
  List<BlogModel> get blogs => blogList.value;

  getData() {
    var promoService = promoRespository.getAllPromos();

    callDataService(promoService, onSuccess: (data) {
      promoList.value = data;
    }, onError: (error) {
      showErrorMessage(error.toString());
    });

    var blogService = blogRepository.getAllBlogs();

    callDataService(blogService, onSuccess: (data) {
      blogList.value = data;
    }, onError: (error) {
      showErrorMessage(error.toString());
    });
  }

  @override
  void onInit() {
    getData();
    super.onInit();
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
