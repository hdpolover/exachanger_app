import 'package:exachanger_get_app/app/data/remote/metadata/metadata_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/remote/metadata/metadata_remote_data_source_impl.dart';
import 'package:exachanger_get_app/app/data/remote/product/product_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/remote/product/product_remote_data_source_impl.dart';
import 'package:get/get.dart';

import '../data/remote/auth/auth_remote_data_source.dart';
import '../data/remote/auth/auth_remote_data_source_impl.dart';
import '../data/remote/blog/blog_remote_data_source.dart';
import '../data/remote/blog/blog_remote_data_source_impl.dart';
import '../data/remote/promo/promo_remote_data_source.dart';
import '../data/remote/promo/promo_remote_data_source_impl.dart';
import '../data/remote/transaction/transaction_remote_data_source.dart';
import '../data/remote/transaction/transaction_remote_data_source_impl.dart';
import '/app/data/remote/github_remote_data_source.dart';
import '/app/data/remote/github_remote_data_source_impl.dart';
import '../data/remote/notification/notification_remote_data_source.dart';
import '../data/remote/notification/notification_remote_data_source_impl.dart';

class RemoteSourceBindings implements Bindings {
  @override
  void dependencies() {
    print('🔧 REMOTE SOURCE BINDINGS: Initializing remote data sources...');

    // Use fenix: true to allow re-creation if instances are deleted
    // Check if already registered to avoid conflicts

    if (!Get.isRegistered<GithubRemoteDataSource>(
      tag: (GithubRemoteDataSource).toString(),
    )) {
      Get.lazyPut<GithubRemoteDataSource>(
        () => GithubRemoteDataSourceImpl(),
        tag: (GithubRemoteDataSource).toString(),
        fenix: true,
      );
    }

    // metadata
    if (!Get.isRegistered<MetaDataRemoteDataSource>(
      tag: (MetaDataRemoteDataSource).toString(),
    )) {
      Get.lazyPut<MetaDataRemoteDataSource>(
        () => MetadataRemoteDataSourceImpl(),
        tag: (MetaDataRemoteDataSource).toString(),
        fenix: true,
      );
    }

    // auth remote data source
    if (!Get.isRegistered<AuthRemoteDataSource>(
      tag: (AuthRemoteDataSource).toString(),
    )) {
      Get.lazyPut<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(),
        tag: (AuthRemoteDataSource).toString(),
        fenix: true,
      );
    }

    // promo remote data source
    if (!Get.isRegistered<PromoRemoteDataSource>(
      tag: (PromoRemoteDataSource).toString(),
    )) {
      Get.lazyPut<PromoRemoteDataSource>(
        () => PromoRemoteDataSourceImpl(),
        tag: (PromoRemoteDataSource).toString(),
        fenix: true,
      );
    }

    // blog remote data source
    if (!Get.isRegistered<BlogRemoteDataSource>(
      tag: (BlogRemoteDataSource).toString(),
    )) {
      Get.lazyPut<BlogRemoteDataSource>(
        () => BlogRemoteDataSourceImpl(),
        tag: (BlogRemoteDataSource).toString(),
        fenix: true,
      );
    }

    // transaction remote data source
    if (!Get.isRegistered<TransactionRemoteDataSource>(
      tag: (TransactionRemoteDataSource).toString(),
    )) {
      Get.lazyPut<TransactionRemoteDataSource>(
        () => TransactionRemoteDataSourceImpl(),
        tag: (TransactionRemoteDataSource).toString(),
        fenix: true,
      );
    }

    // product remote data source
    if (!Get.isRegistered<ProductRemoteDataSource>(
      tag: (ProductRemoteDataSource).toString(),
    )) {
      Get.lazyPut<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(),
        tag: (ProductRemoteDataSource).toString(),
        fenix: true,
      );
    }

    // notification remote data source
    if (!Get.isRegistered<NotificationRemoteDataSource>(
      tag: (NotificationRemoteDataSource).toString(),
    )) {
      Get.lazyPut<NotificationRemoteDataSource>(
        () => NotificationRemoteDataSourceImpl(),
        tag: (NotificationRemoteDataSource).toString(),
        fenix: true,
      );
    }

    print('🔧 REMOTE SOURCE BINDINGS: All remote data sources initialized');
  }
}
