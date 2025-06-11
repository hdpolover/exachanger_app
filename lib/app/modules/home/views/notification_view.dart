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
      controller.loadNotifications();
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
                      onPressed: () => controller.loadNotifications(),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                itemCount: groupedNotifications.keys.length,
                itemBuilder: (context, index) {
                  final date = groupedNotifications.keys.elementAt(index);
                  final notifications = groupedNotifications[date]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header with improved styling
                      Container(
                        margin: const EdgeInsets.only(bottom: 8, top: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.colorPrimary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: AppColors.colorPrimary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              date,
                              style: regularBodyTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.colorPrimary,
                              ),
                            ),
                          ],
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
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search notifications...',
              hintStyle: smallBodyTextStyle.copyWith(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: AppColors.colorPrimary),
              suffixIcon: Obx(
                () => controller.notificationTitleFilter.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          controller.applyNotificationFilters(titleFilter: '');
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: AppColors.colorPrimary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
            ),
            style: regularBodyTextStyle,
            onSubmitted: (value) {
              controller.applyNotificationFilters(titleFilter: value);
            },
            onChanged: (value) {
              // Update will be handled automatically by Obx
            },
          ),
          const SizedBox(height: 16),

          // Filters section header
          Row(
            children: [
              Icon(Icons.filter_list, size: 18, color: AppColors.colorPrimary),
              const SizedBox(width: 8),
              Text(
                'Filters & Sorting',
                style: regularBodyTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sort options in a more organized layout
          Row(
            children: [
              // Sort by dropdown
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sort by',
                      style: smallBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Obx(
                        () => DropdownButton<String>(
                          value: controller.notificationSortField.value.isEmpty
                              ? null
                              : controller.notificationSortField.value,
                          isExpanded: true,
                          underline: Container(),
                          hint: Text(
                            'Select field',
                            style: smallBodyTextStyle.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          style: regularBodyTextStyle,
                          items: [
                            DropdownMenuItem(
                              value: 'created_at',
                              child: Text('Date', style: regularBodyTextStyle),
                            ),
                            DropdownMenuItem(
                              value: 'title',
                              child: Text('Title', style: regularBodyTextStyle),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.applyNotificationFilters(
                                sortField: value,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Sort order dropdown
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order',
                      style: smallBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Obx(
                        () => DropdownButton<String>(
                          value: controller.notificationSortOrder.value.isEmpty
                              ? null
                              : controller.notificationSortOrder.value,
                          isExpanded: true,
                          underline: Container(),
                          hint: Text(
                            'Select order',
                            style: smallBodyTextStyle.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          style: regularBodyTextStyle,
                          items: [
                            DropdownMenuItem(
                              value: 'ASC',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ascending',
                                    style: regularBodyTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'DESC',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Descending',
                                    style: regularBodyTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.applyNotificationFilters(
                                sortOrder: value,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Reset button
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actions',
                      style: smallBodyTextStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          controller.clearNotificationFilters();
                          _searchController.clear();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.colorPrimary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 16,
                              color: AppColors.colorPrimary,
                            ),
                            Text(
                              'Reset',
                              style: extraSmallBodyTextStyle.copyWith(
                                color: AppColors.colorPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(dynamic notification) {
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade50, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon with enhanced styling
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Center(child: Icon(iconData, color: iconColor, size: 22)),
            ),
            const SizedBox(width: 16),
            // Notification content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? 'Notification',
                          style: regularBodyTextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          displayTime,
                          style: extraSmallBodyTextStyle.copyWith(
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.notification ?? '',
                    style: smallBodyTextStyle.copyWith(
                      height: 1.4,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 3,
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

  // Shimmer loading for notification items
  Widget _buildShimmerNotificationItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon shimmer
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            // Notification content shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 180,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 200,
                    height: 12,
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
