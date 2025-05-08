import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

//Default appbar customized with the design of our app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitleText;
  final List<Widget>? actions;
  final bool isBackButtonEnabled;

  const CustomAppBar({
    super.key,
    required this.appBarTitleText,
    this.actions,
    this.isBackButtonEnabled = true,
  });

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: isBackButtonEnabled,
      actions: actions,
      title: Text(
        appBarTitleText,
        style: appBarTextStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
