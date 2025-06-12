// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? Function() onTap;
  final bool isSignOutBtn;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isSignOutBtn = false,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSignOutBtn ? Colors.red : Colors.grey.shade400,
          width: 1,
        ),
      ),
      child: ListTile(
        minVerticalPadding: 20,
        dense: false,
        visualDensity: VisualDensity.comfortable,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(96),
          ),
          child: Icon(icon, size: 20),
        ),
        title: Text(
          title,
          style: regularBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: smallBodyTextStyle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ), // iOS style arrow
        onTap: onTap(),
      ),
    );
  }
}
