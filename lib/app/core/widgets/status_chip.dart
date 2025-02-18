// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
  });

  final int status;

  _getText() {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Success';
      case 2:
        return 'Failed';
      default:
        return 'Unknown';
    }
  }

  _getColor() {
    switch (status) {
      case 0:
        return Colors.orange.shade400;
      case 1:
        return Colors.green.shade400;
      case 2:
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _getText(),
        style: extraSmallBodyTextStyle.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
