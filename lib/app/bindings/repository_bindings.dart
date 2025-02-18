import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository.dart';
import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository_impl.dart';
import 'package:get/get.dart';

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
  }
}
