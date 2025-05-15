import 'package:exachanger_get_app/app/data/models/metadata_model.dart';

abstract class MetadataRepository {
  Future<MetaDataModel> getPageContent(String page);
}
