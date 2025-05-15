import 'package:exachanger_get_app/app/data/models/blog_detail_model.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:exachanger_get_app/app/data/remote/blog/blog_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
import 'package:get/get.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource _remoteSource =
      Get.find(tag: (BlogRemoteDataSource).toString());

  @override
  Future<List<BlogModel>> getAllBlogs() {
    return _remoteSource.getAll();
  }

  @override
  Future<BlogDetailModel> getBlogDetail(String id) {
    return _remoteSource.getById(id);
  }
}
