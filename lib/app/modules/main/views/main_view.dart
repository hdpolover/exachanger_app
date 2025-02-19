import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/modules/exchange/views/exchange_view.dart';
import 'package:exachanger_get_app/app/modules/history/views/history_view.dart';
import 'package:exachanger_get_app/app/modules/home/views/home_view.dart';
import 'package:exachanger_get_app/app/modules/main/views/bottom_nav_bar.dart';
import 'package:exachanger_get_app/app/modules/profile/views/profile_view.dart';
import 'package:exachanger_get_app/app/modules/rate/views/rate_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/main_controller.dart';

class MainView extends BaseView<MainController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) => null;

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
      tooltip: 'Exchange',
      shape: CircleBorder(),
      child: Icon(
        FontAwesomeIcons.moneyBillTransfer,
        color: Colors.white,
        size: 25,
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
        return ExchangeView();
    }
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() => _tabsShown());
  }
}
