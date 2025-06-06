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
    Get.lazyPut<GithubRemoteDataSource>(
      () => GithubRemoteDataSourceImpl(),
      tag: (GithubRemoteDataSource).toString(),
    );
    // metadata
    Get.lazyPut<MetaDataRemoteDataSource>(
      () => MetadataRemoteDataSourceImpl(),
      tag: (MetaDataRemoteDataSource).toString(),
    );
    // auth remote data source
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
      tag: (AuthRemoteDataSource).toString(),
    );
    // promo remote data source
    Get.lazyPut<PromoRemoteDataSource>(
      () => PromoRemoteDataSourceImpl(),
      tag: (PromoRemoteDataSource).toString(),
    );
    // blog remote data source
    Get.lazyPut<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(),
      tag: (BlogRemoteDataSource).toString(),
    );
    // transaction remote data source
    Get.lazyPut<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(),
      tag: (TransactionRemoteDataSource).toString(),
    );
    // product remote data source
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(),
      tag: (ProductRemoteDataSource).toString(),
    );
    
    // notification remote data source
    Get.lazyPut<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(),
      tag: (NotificationRemoteDataSource).toString(),
    );
  }
}
