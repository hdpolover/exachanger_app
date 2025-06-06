import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/modules/history/views/widgets/history_item.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/history_controller.dart';

class HistoryView extends BaseView<HistoryController> {
  @override
  PreferredSizeWidget appBar(BuildContext context) {
    // Get the state before building the widget
    bool isFromHome = controller.isFromHome.value;

    return CustomAppBar(
      appBarTitleText: 'Transaction History',
      isBackButtonEnabled: isFromHome,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_list, color: Colors.black),
        ),
      ],
    );
  }

  // Shimmer loading for transaction items
  Widget _buildShimmerTransactionItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 70,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: 8, // Show 8 shimmer items
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildShimmerTransactionItem();
      },
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerList();
      }

      if (controller.error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.error.value),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.getData(),
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.transactions.isEmpty) {
        return Center(child: Text('No transaction history available'));
      }

      return SmartRefresher(
        key: const ValueKey('history_smart_refresher'),
        controller: controller.refreshController,
        onRefresh: controller.onRefresh,
        enablePullDown: true,
        enablePullUp: false,
        physics: const BouncingScrollPhysics(),
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.colorPrimary,
          color: Colors.white,
          distance: 40.0,
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: controller.transactions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return HistoryItem(
              transaction: controller.transactions[index],
              onTap: () {
                // Handle item tap
                // For example, navigate to a detailed view of the transaction
                Get.toNamed(
                  Routes.TRANSACTION_DETAIL,
                  arguments: controller.transactions[index],
                );
              },
            );
          },
        ),
      );
    });
  }
}
