import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/carousel_view.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:exachanger_get_app/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:exachanger_get_app/app/modules/promo/bindings/promo_binding.dart';
import 'package:exachanger_get_app/app/modules/promo/views/promo_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:get/get.dart';

import '../../history/views/widgets/history_item.dart';
import '../controllers/home_controller.dart';
import 'widgets/news_item.dart';
import 'widgets/product_item.dart';
import 'widgets/promo_item.dart';

class HomeView extends BaseView<HomeController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColors.colorWhite,
      backgroundColor: AppColors.colorWhite,
      automaticallyImplyLeading: false,
      title: Image.asset(AppImages.logoText, height: 25),
      centerTitle: true,
    );
  }

  // Shimmer loading for product grid
  Widget _buildShimmerProductGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          childAspectRatio: 0.8,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: 8, // Show 8 shimmer items
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Shimmer loading for transaction history
  Widget _buildShimmerTransactionItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
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
                    height: 10,
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

  // Shimmer loading for news items
  Widget _buildShimmerNewsItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.only(right: 15, bottom: 5),
        width: 280,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            // Content placeholder
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: 100,
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

  // Shimmer loading for carousel
  Widget _buildShimmerCarousel() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: Get.height * 0.2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildShimmerTopSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 150,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        if (controller.isClosed) {
          return const Center(child: CircularProgressIndicator());
        }

        return Obx(
          () => SmartRefresher(
            key: const ValueKey('home_smart_refresher'),
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
            child: ListView(
              children: [
                _topSection(),
                _exchangeSection(),
                // Show the transaction section when loading or if there are transactions
                if (controller.isLoading.value ||
                    controller.transactions.isNotEmpty)
                  _transactionSection(),
                _whatsnewSection(),
                _newsSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  getGreetingTimeText() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  Widget _notifSection() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.NOTIFICATION);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          Icons.notifications_none_outlined,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _topSection() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerTopSection();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?background=random&name=${controller.userData.value?.name ?? "User"}&size=200',
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getGreetingTimeText() + ',', style: smallBodyTextStyle),
                  Text(
                    controller.userData.value?.name?.toUpperCase() ?? 'USER',
                    style: regularBodyTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            _notifSection(),
          ],
        ),
      );
    });
  }

  Widget _exchangeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Exchange',
                style: regularBodyTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Obx(() {
              // Show loading while fetching products OR if products are empty and we're in initial load
              if (controller.isLoading.value) {
                return _buildShimmerProductGrid();
              }

              // Error state
              if (controller.error.value.isNotEmpty) {
                return Container(
                  height: 150,
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load products',
                          style: smallBodyTextStyle.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: controller.refreshAll,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Empty state - only show if we're definitely not loading and have no products
              if (controller.products.isEmpty && !controller.isLoading.value) {
                return Container(
                  height: 150,
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No exchange products available',
                      style: smallBodyTextStyle.copyWith(color: Colors.grey),
                    ),
                  ),
                );
              }

              // Products grid
              return GridView.builder(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100, // Maximum width per item
                  childAspectRatio: 0.8, // Adjust based on content
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: controller.products.length > 7
                    ? 8 // Show 7 products + "More" button
                    : controller.products.length +
                          1, // All products + "More" button
                itemBuilder: (context, index) {
                  // If this is the last item and we have 7 or more products, or if we have fewer products and this is the last one
                  bool isLastItem =
                      (controller.products.length > 7 && index == 7) ||
                      (controller.products.length <= 7 &&
                          index == controller.products.length);

                  if (isLastItem) {
                    return ProductItem(
                      onTap: () {
                        // Navigate to all products page using named route
                        Get.toNamed(Routes.HOME_MORE);
                      },
                      isMore: true,
                    );
                  }

                  return ProductItem(
                    product: controller.products[index],
                    onTap: () {
                      // Navigate to exchange page with the product data in a map with a flag
                      print(
                        "Navigating to exchange with product: ${controller.products[index].name}",
                      );
                      // Force delete any existing controller before navigating to ensure a fresh state
                      if (Get.isRegistered<ExchangeController>()) {
                        Get.delete<ExchangeController>(force: true);
                      }

                      // Navigate to exchange with the selected product
                      Get.toNamed(
                        Routes.EXCHANGE,
                        arguments: {
                          'fixedProduct': controller.products[index],
                          'fromHome': true,
                        },
                      );
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _transactionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Transaction History',
                    style: regularBodyTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(
                        Routes.HISTORY,
                        arguments: {'fromHome': true},
                      );
                    },
                    child: Text(
                      'View All',
                      style: smallBodyTextStyle.copyWith(
                        color: AppColors.colorPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return Column(
                    children: List.generate(
                      3,
                      (_) => _buildShimmerTransactionItem(),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.transactions.length > 3
                      ? 3
                      : controller.transactions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: HistoryItem(
                        transaction: controller.transactions[index],
                        onTap: () {
                          Get.toNamed(
                            Routes.TRANSACTION_DETAIL,
                            arguments: controller.transactions[index],
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _whatsnewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'What\'s New',
                style: regularBodyTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.PROMO, arguments: controller.promos);
                },
                child: Text(
                  'View All',
                  style: smallBodyTextStyle.copyWith(
                    color: AppColors.colorPrimary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          // carousel view
          Obx(() {
            if (controller.isLoading.value) {
              return _buildShimmerCarousel();
            }

            return SizedBox(
              height: Get.height * 0.2,
              child: CustomCarouselView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                itemSnapping: true,
                itemExtent: Get.width * 0.8,
                spacing: 5, // Add spacing between items
                onTap: (index) {
                  print('Promo $index tapped');

                  PromoModel promo = controller.promos[index];

                  print(promo);

                  Get.to(
                    () => PromoDetailView(),
                    binding: PromoBinding(),
                    arguments: promo,
                  );
                },
                children: controller.promos
                    .map((promo) => PromoItem(promo: promo))
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _newsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'News',
                    style: regularBodyTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.BLOG, arguments: controller.blogs);
                    },
                    child: Text(
                      'View All',
                      style: smallBodyTextStyle.copyWith(
                        color: AppColors.colorPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (controller.isLoading.value) {
                  return Column(
                    children: List.generate(3, (_) => _buildShimmerNewsItem()),
                  );
                }

                return SizedBox(
                  width: Get.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.blogs.length,
                    itemBuilder: (context, index) {
                      BlogModel blogModel = controller.blogs[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: NewsItem(blogModel: blogModel),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
