import 'package:exachanger_get_app/app/data/model/metadata_model.dart';

abstract class MetadataRepository {
  Future<MetaDataModel> getPageContent(String page);
}
