import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/transaction_detail_controller.dart';

class TransactionDetailView extends BaseView<TransactionDetailController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: 'Transaction Detail');
  }

  @override
  Widget body(BuildContext context) {
    return Center(
      child: Text(
        'TransactionDetailView is working',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
