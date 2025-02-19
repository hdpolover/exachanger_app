import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  final _currentIndex = 0.obs;

  void changeIndex(int index) {
    _currentIndex.value = index;
  }

  int get currentIndex => _currentIndex.value;
}
