import 'package:exachanger_get_app/app/data/repository/auth/auth_repository.dart';
import 'package:exachanger_get_app/app/data/repository/auth/auth_repository_impl.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository.dart';
import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository_impl.dart';
import 'package:exachanger_get_app/app/data/repository/promo/promo_repository_impl.dart';
import 'package:get/get.dart';

import '../data/repository/blog/blog_repository_impl.dart';
import '../data/repository/promo/promo_repository.dart';
import '/app/data/repository/github_repository.dart';
import '/app/data/repository/github_repository_impl.dart';

class RepositoryBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GithubRepository>(
      () => GithubRepositoryImpl(),
      tag: (GithubRepository).toString(),
    );
    Get.lazyPut<MetadataRepository>(
      () => MetadataRepositoryImpl(),
      tag: (MetadataRepository).toString(),
    );
    // auth
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(),
      tag: (AuthRepository).toString(),
    );
    // promo
    Get.lazyPut<PromoRepository>(
      () => PromoRepositoryImpl(),
      tag: (PromoRepository).toString(),
    );
    // blog repository
    Get.lazyPut<BlogRepository>(
      () => BlogRepositoryImpl(),
      tag: (BlogRepository).toString(),
    );
  }
}
