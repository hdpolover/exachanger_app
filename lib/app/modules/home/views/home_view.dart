import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/data/model/blog_model.dart';
import 'package:exachanger_get_app/app/data/model/promo_model.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

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
      title: Image.asset(
        AppImages.logoText,
        height: 25,
      ),
      centerTitle: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            _topSection(),
            _exchangeSection(),
            if (controller.transactions.isNotEmpty) _transactionSection(),
            _whatsnewSection(),
            _newsSection(),
          ],
        ),
      ),
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
        // context.pushNamed(Routes.notifications.name);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(AppImages.logo),
            child: Text('U'),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreetingTimeText() + ',',
                  style: smallBodyTextStyle,
                ),
                Text(
                  'User',
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
  }

  Widget _exchangeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
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
            GridView.builder(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100, // Maximum width per item
                childAspectRatio: 0.8, // Adjust based on content
                // crossAxisSpacing: 10,
                // mainAxisSpacing: 10,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                if (index == 7) {
                  return ProductItem(
                    onTap: () {
                      // context.pushNamed(Routes.allServices.name);
                    },
                    isMore: true,
                  );
                }

                return ProductItem(
                  onTap: () => print('Product $index tapped'),
                );
              },
            ),
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
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
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
                      // context.pushNamed(Routes.history.name);
                    },
                    child: Text(
                      'View All',
                      style: smallBodyTextStyle.copyWith(
                        color: AppColors.colorPrimary,
                        // undeline
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HistoryItem(
                      transaction: controller.transactions[index],
                      onTap: () {
                        Get.toNamed(Routes.TRANSACTION_DETAIL,
                            arguments: controller.transactions[index]);
                      },
                    ),
                  );
                },
              ),
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
                    // undeline
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          // carousel view
          SizedBox(
            height: Get.height * 0.2,
            child: CarouselView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              itemSnapping: true,
              itemExtent: Get.width * 0.8,
              onTap: (index) {
                print('Promo $index tapped');

                PromoModel promo = controller.promos[index];

                print(promo);

                Get.toNamed(Routes.PROMO_DETAIL, arguments: promo);
              },
              children: controller.promos
                  .map(
                    (promo) => PromoItem(promo: promo),
                  )
                  .toList(),
            ),
          )
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
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
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
                        // undeline
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: Get.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.blogs.length,
                  itemBuilder: (context, index) {
                    BlogModel blogModel = controller.blogs[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: NewsItem(
                        blogModel: blogModel,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
