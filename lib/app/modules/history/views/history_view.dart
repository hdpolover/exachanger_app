import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/modules/history/views/widgets/history_item.dart';
import 'package:flutter/material.dart';

import '../controllers/history_controller.dart';

class HistoryView extends BaseView<HistoryController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Transaction History',
      isBackButtonEnabled: false,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.filter_list,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: controller.transactions.length,
      itemBuilder: (context, index) {
        return HistoryItem(
          transaction: controller.transactions[index],
        );
      },
    );
  }
}
