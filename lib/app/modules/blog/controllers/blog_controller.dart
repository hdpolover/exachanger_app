import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:get/get.dart';

class BlogController extends BaseController {
  List<BlogModel> blogs = [];
  late BlogModel blogModel;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is List<BlogModel>) {
      blogs = Get.arguments;
    } else if (Get.arguments is BlogModel) {
      blogModel = Get.arguments;
    }
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
