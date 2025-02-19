import 'package:exachanger_get_app/app/data/model/blog_detail_model.dart';

import '../../model/blog_model.dart';

abstract class BlogRemoteDataSource {
  Future<List<BlogModel>> getAll();

  Future<BlogDetailModel> getById(String id);
}
