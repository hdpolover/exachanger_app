import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:get/get.dart';

class BlogController extends BaseController {
  List<BlogModel> blogs = [];
  BlogModel? _blogModel;

  // Getter for blogModel with null check
  BlogModel get blogModel => _blogModel!;

  // Check if blogModel is initialized
  bool get hasBlogModel => _blogModel != null;

  @override
  void onInit() {
    super.onInit();
    print(
      'BlogController onInit - Arguments type: ${Get.arguments?.runtimeType}',
    );
    print('BlogController onInit - Arguments: ${Get.arguments}');

    if (Get.arguments is List<BlogModel>) {
      blogs = Get.arguments;
      print('BlogController: Loaded ${blogs.length} blogs from arguments');
    } else if (Get.arguments is BlogModel) {
      _blogModel = Get.arguments;
      print('BlogController: Loaded blog model: ${_blogModel?.title}');
    } else {
      print('BlogController: No valid arguments provided');
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
