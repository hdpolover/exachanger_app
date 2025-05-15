import 'package:exachanger_get_app/app/data/models/blog_detail_model.dart';

import '../../models/blog_model.dart';

abstract class BlogRemoteDataSource {
  Future<List<BlogModel>> getAll();

  Future<BlogDetailModel> getById(String id);
}
