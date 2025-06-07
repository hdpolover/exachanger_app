import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository_impl.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository.dart';
import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository_impl.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository_impl.dart';
import 'package:exachanger_get_app/app/data/repository/promo/promo_repository_impl.dart';
import 'package:get/get.dart';

import '../data/repository/blog/blog_repository_impl.dart';
import '../data/repository/notification/notification_repository.dart';
import '../data/repository/notification/notification_repository_impl.dart';
import '../data/repository/promo/promo_repository.dart';
import '../data/repository/transaction/transaction_repository.dart';
import '../data/repository/transaction/transaction_repository_impl.dart';
import '/app/data/repository/github_repository.dart';
import '/app/data/repository/github_repository_impl.dart';

class RepositoryBindings implements Bindings {
  @override
  void dependencies() {
    print('🔧 REPOSITORY BINDINGS: Initializing repositories...');

    // Use fenix: true and check registration to avoid conflicts

    if (!Get.isRegistered<GithubRepository>(
      tag: (GithubRepository).toString(),
    )) {
      Get.lazyPut<GithubRepository>(
        () => GithubRepositoryImpl(),
        tag: (GithubRepository).toString(),
        fenix: true,
      );
    }

    if (!Get.isRegistered<MetadataRepository>(
      tag: (MetadataRepository).toString(),
    )) {
      Get.lazyPut<MetadataRepository>(
        () => MetadataRepositoryImpl(),
        tag: (MetadataRepository).toString(),
        fenix: true,
      );
    }

    // auth
    if (!Get.isRegistered<AuthRepository>(tag: (AuthRepository).toString())) {
      Get.lazyPut<AuthRepository>(
        () => AuthRepositoryImpl(),
        tag: (AuthRepository).toString(),
        fenix: true,
      );
    }

    // promo
    if (!Get.isRegistered<PromoRepository>(tag: (PromoRepository).toString())) {
      Get.lazyPut<PromoRepository>(
        () => PromoRepositoryImpl(),
        tag: (PromoRepository).toString(),
        fenix: true,
      );
    }

    // blog repository
    if (!Get.isRegistered<BlogRepository>(tag: (BlogRepository).toString())) {
      Get.lazyPut<BlogRepository>(
        () => BlogRepositoryImpl(),
        tag: (BlogRepository).toString(),
        fenix: true,
      );
    }

    // transaction repository
    if (!Get.isRegistered<TransactionRepository>(
      tag: (TransactionRepository).toString(),
    )) {
      Get.lazyPut<TransactionRepository>(
        () => TransactionRepositoryImpl(),
        tag: (TransactionRepository).toString(),
        fenix: true,
      );
    }

    // product repository
    if (!Get.isRegistered<ProductRepository>(
      tag: (ProductRepository).toString(),
    )) {
      Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(),
        tag: (ProductRepository).toString(),
        fenix: true,
      );
    }

    // notification repository
    if (!Get.isRegistered<NotificationRepository>(
      tag: (NotificationRepository).toString(),
    )) {
      Get.lazyPut<NotificationRepository>(
        () => NotificationRepositoryImpl(),
        tag: (NotificationRepository).toString(),
        fenix: true,
      );
    }

    print('🔧 REPOSITORY BINDINGS: All repositories initialized');
  }
}
