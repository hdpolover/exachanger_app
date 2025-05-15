import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:exachanger_get_app/app/core/base/base_widget_mixin.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/modules/main/controllers/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

typedef OnBottomNavItemSelected = Function(int index);

class BottomNavBar extends StatelessWidget with BaseWidgetMixin {
  BottomNavBar({super.key, required this.onMenuSelected});

  final OnBottomNavItemSelected onMenuSelected;

  Map<String, IconData> iconList = {
    "Home": FontAwesomeIcons.house,
    "History": FontAwesomeIcons.clockRotateLeft,
    "Rate": FontAwesomeIcons.chartSimple,
    "Profile": FontAwesomeIcons.userLarge,
  };

  final bottomNavBarController = BottomNavBarController();

  @override
  Widget body(BuildContext context) {
    return Obx(
      () => AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? AppColors.colorPrimary : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList.values.toList()[index],
                size: 16,
                color: color,
              ),
              SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  iconList.keys.toList()[index],
                  maxLines: 1,
                  style: smallBodyTextStyle,
                ),
              )
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: bottomNavBarController.currentIndex,
        splashColor: Theme.of(context).colorScheme.primary,
        // notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        onTap: (index) {
          bottomNavBarController.changeIndex(index);
          onMenuSelected(index);
        },
        // hideAnimationController: _hideBottomBarAnimationController,
        shadow: BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0.5,
          color: Colors.black.withValues(),
        ),
      ),
    );
  }
}
