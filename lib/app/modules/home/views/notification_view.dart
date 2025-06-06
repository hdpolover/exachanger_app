import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/utils/date_formatter.dart';
import 'package:exachanger_get_app/app/utils/notification_type_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/home_controller.dart';

class NotificationView extends BaseView<HomeController> {
  // Search text controller
  final TextEditingController _searchController = TextEditingController();

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Notifications',
      isBackButtonEnabled: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    // Load notifications when view is opened
    if (controller.notifications.isEmpty &&
        !controller.isLoadingNotifications.value) {
      controller.fetchNotifications();
    }

    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingNotifications.value &&
                controller.notifications.isEmpty) {
              return _buildShimmerList();
            }
            if (controller.notificationError.value.isNotEmpty &&
                controller.notifications.isEmpty) {
              final bool isNetworkError =
                  controller.notificationError.value.contains(
                    'NetworkException',
                  ) ||
                  controller.notificationError.value.contains('no internet') ||
                  controller.notificationError.value.contains(
                    'Failed host lookup',
                  );

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isNetworkError ? Icons.wifi_off : Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      isNetworkError
                          ? 'No internet connection'
                          : controller.notificationError.value,
                      style: titleTextStyle.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    if (isNetworkError)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Please check your network settings and try again',
                          style: regularBodyTextStyle.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          controller.fetchNotifications(refresh: true),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (controller.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: titleTextStyle.copyWith(color: Colors.grey),
                    ),
                    if (controller.notificationTitleFilter.value.isNotEmpty ||
                        controller.notificationType.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            controller.clearNotificationFilters();
                          },
                          child: Text('Clear Filters'),
                        ),
                      ),
                  ],
                ),
              );
            } // Group notifications by date
            final groupedNotifications = _groupNotificationsByDate(
              controller.notifications,
            );

            return SmartRefresher(
              controller: controller.notificationRefreshController,
              onRefresh: controller.onNotificationRefresh,
              enablePullDown: true,
              enablePullUp: controller.hasMoreNotifications.value,
              onLoading: controller.loadMoreNotifications,
              header: WaterDropMaterialHeader(
                backgroundColor: AppColors.colorPrimary,
                color: Colors.white,
                distance: 40.0,
              ),
              footer: ClassicFooter(
                loadingText: 'Loading more notifications...',
                noDataText: 'No more notifications',
                idleText: 'Pull up to load more',
                canLoadingText: 'Release to load more',
                failedText: 'Failed to load more notifications',
                loadStyle: LoadStyle.ShowWhenLoading,
                textStyle: smallBodyTextStyle.copyWith(color: Colors.grey),
              ),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                itemCount: groupedNotifications.keys.length,
                itemBuilder: (context, index) {
                  final date = groupedNotifications.keys.elementAt(index);
                  final notifications = groupedNotifications[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          date,
                          style: regularBodyTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorPrimary,
                          ),
                        ),
                      ),
                      ...notifications
                          .map(
                            (notification) =>
                                _buildNotificationItem(notification),
                          )
                          .toList(),
                    ],
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  // Build search and filter bar
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search notifications',
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  controller.applyNotificationFilters(titleFilter: '');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0.0),
            ),
            onSubmitted: (value) {
              controller.applyNotificationFilters(titleFilter: value);
            },
          ),
          SizedBox(height: 8),
          // Sort options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => DropdownButton<String>(
                  value: controller.notificationSortField.value,
                  items: [
                    DropdownMenuItem(value: 'created_at', child: Text('Date')),
                    DropdownMenuItem(value: 'title', child: Text('Title')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.applyNotificationFilters(sortField: value);
                    }
                  },
                  hint: Text('Sort by'),
                ),
              ),
              Obx(
                () => DropdownButton<String>(
                  value: controller.notificationSortOrder.value,
                  items: [
                    DropdownMenuItem(value: 'ASC', child: Text('Ascending')),
                    DropdownMenuItem(value: 'DESC', child: Text('Descending')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.applyNotificationFilters(sortOrder: value);
                    }
                  },
                  hint: Text('Order'),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  controller.clearNotificationFilters();
                  _searchController.clear();
                },
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(notification) {
    // Parse date string to DateTime
    DateTime? dateTime = DateFormatter.parseDate(notification.createdAt);

    // Get notification type and display time
    final notificationType = NotificationTypeHelper.getTypeFromContent(
      notification.title,
      notification.notification,
    );
    final iconData = NotificationTypeHelper.getIconForType(notificationType);
    final iconColor = NotificationTypeHelper.getColorForType(notificationType);
    final displayTime = DateFormatter.formatTime(dateTime);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Icon(iconData, color: iconColor, size: 20)),
            ),
            SizedBox(width: 12),
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? 'Notification',
                          style: regularBodyTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        displayTime,
                        style: smallBodyTextStyle.copyWith(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.notification ?? '',
                    style: smallBodyTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods moved to DateFormatter utility class
  // Shimmer loading for notification items
  Widget _buildShimmerNotificationItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon shimmer
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(width: 12),
            // Notification content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
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
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 150,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      itemCount: 8, // Show 8 shimmer items
      itemBuilder: (context, index) {
        return _buildShimmerNotificationItem();
      },
    );
  }

  // Group notifications by date category
  Map<String, List<dynamic>> _groupNotificationsByDate(
    List<dynamic> notifications,
  ) {
    final Map<String, List<dynamic>> grouped = {};

    for (final notification in notifications) {
      final dateTime = DateFormatter.parseDate(notification.createdAt);
      final dateCategory = DateFormatter.getDateCategory(dateTime);

      if (!grouped.containsKey(dateCategory)) {
        grouped[dateCategory] = [];
      }

      grouped[dateCategory]!.add(notification);
    }

    // Sort by priority: Today, Yesterday, This Week, This Month, Earlier
    final result = Map.fromEntries(
      grouped.entries.toList()..sort((a, b) {
        final priorities = {
          'Today': 0,
          'Yesterday': 1,
          'This Week': 2,
          'This Month': 3,
          'Earlier': 4,
        };
        return (priorities[a.key] ?? 5).compareTo(priorities[b.key] ?? 5);
      }),
    );

    return result;
  }
}
