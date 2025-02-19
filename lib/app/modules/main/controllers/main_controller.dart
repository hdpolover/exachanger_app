import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:get/get.dart';

class MainController extends BaseController {
  final _selectedMenu = 0.obs;

  int get selectedMenu => _selectedMenu.value;

  onMenuSelected(int index) async {
    _selectedMenu.value = index;
  }

  @override
  void onInit() {
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
