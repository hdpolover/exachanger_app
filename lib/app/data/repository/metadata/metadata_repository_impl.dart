import 'package:exachanger_get_app/app/data/models/metadata_model.dart';
import 'package:exachanger_get_app/app/data/remote/metadata/metadata_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/repository/metadata/metadata_repository.dart';
import 'package:get/get.dart';

class MetadataRepositoryImpl implements MetadataRepository {
  final MetaDataRemoteDataSource _remoteSource =
      Get.find(tag: (MetaDataRemoteDataSource).toString());

  @override
  Future<MetaDataModel> getPageContent(String page) {
    return _remoteSource.getPageData(page);
  }
}
