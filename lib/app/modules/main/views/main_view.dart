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

    // Show beautiful confirmation dialog when there's nothing else to pop
    return await Get.dialog<bool>(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(32),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with background circle
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.exit_to_app_rounded,
                      color: AppColors.colorPrimary,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Exit App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Are you sure you want to exit?\nWe have more great features waiting for you!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  // Buttons with better spacing
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(result: false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorPrimary,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Stay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: Colors.grey[700],
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            'Exit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false; // Default to false if dialog is dismissed
  }

  @override
  Widget? bottomNavigationBar() {
    return BottomNavBar(onMenuSelected: controller.onMenuSelected);
  }

  // floating action button
  @override
  Widget? floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.colorPrimary,
      shape: CircleBorder(),
      child: Icon(FontAwesomeIcons.arrowsRotate, color: Colors.white),
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
    return WillPopScope(onWillPop: _onWillPop, child: Obx(() => _tabsShown()));
  }
}
