import 'package:exachanger_get_app/app/data/remote/metadata/metadata_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/remote/metadata/metadata_remote_data_source_impl.dart';
import 'package:get/get.dart';

import '/app/data/remote/github_remote_data_source.dart';
import '/app/data/remote/github_remote_data_source_impl.dart';

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
  }
}
