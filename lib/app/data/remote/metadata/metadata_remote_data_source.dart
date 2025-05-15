import 'package:exachanger_get_app/app/data/models/metadata_model.dart';

abstract class MetaDataRemoteDataSource {
  Future<MetaDataModel> getPageData(String page);
}
