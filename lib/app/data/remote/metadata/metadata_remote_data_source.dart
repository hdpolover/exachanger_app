import 'package:exachanger_get_app/app/data/model/metadata_model.dart';

abstract class MetaDataRemoteDataSource {
  Future<MetaDataModel> getPageData(String page);
}
