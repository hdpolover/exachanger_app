import 'package:exachanger_get_app/app/data/model/blog_detail_model.dart';
import 'package:exachanger_get_app/app/data/model/blog_model.dart';

abstract class BlogRepository {
  Future<List<BlogModel>> getAllBlogs();

  Future<BlogDetailModel> getBlogDetail(String id);
}
