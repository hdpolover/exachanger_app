import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/modules/exchange/views/exchange_view.dart';
import 'package:exachanger_get_app/app/modules/history/views/history_view.dart';
import 'package:exachanger_get_app/app/modules/home/views/home_view.dart';
import 'package:exachanger_get_app/app/modules/main/views/bottom_nav_bar.dart';
import 'package:exachanger_get_app/app/modules/profile/views/pages/profile_view.dart';
import 'package:exachanger_get_app/app/modules/rate/views/rate_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class MainView extends BaseView<MainController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

  Future<bool> _onWillPop() async {
    if (Get.keys[0]?.currentState?.canPop() ?? false) {
      return true; // Allow back navigation if there are routes to pop
    }

    // Show confirmation dialog when there's nothing else to pop
    return await Get.dialog<bool>(
          AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () => Get.back(result: false),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () => Get.back(result: true),
              ),
            ],
          ),
        ) ??
        false; // Default to false if dialog is dismissed
  }

  @override
  Widget? bottomNavigationBar() {
    return BottomNavBar(
      onMenuSelected: controller.onMenuSelected,
    );
  }

  // floating action button
  @override
  Widget? floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.colorPrimary,
      shape: CircleBorder(),
      child: Icon(
        FontAwesomeIcons.arrowsRotate,
        color: Colors.white,
      ),
      onPressed: () {
        // _fabAnimationController.reset();
        // _borderRadiusAnimationController.reset();
        // _borderRadiusAnimationController.forward();
        // _fabAnimationController.forward();

        // // set the bottom nav index to the first screen
        // setState(() {
        //   _bottomNavIndex = 4;
        // });

        controller.onMenuSelected(4);
      },
    );
  }

  _tabsShown() {
    switch (controller.selectedMenu) {
      case 0:
        return HomeView();
      case 1:
        return HistoryView();
      case 2:
        return RateView();
      case 3:
        return ProfileView();
      default:
        // Return the Exchange view directly - the binding will handle the controller
        return ExchangeView();
    }
  }

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(() => _tabsShown()),
    );
  }
}
