import 'package:dio/dio.dart';
import 'package:exachanger_get_app/app/data/model/blog_detail_model.dart';
import 'package:exachanger_get_app/app/data/model/blog_model.dart';
import 'package:exachanger_get_app/app/data/remote/blog/blog_remote_data_source.dart';

import '../../../core/base/base_remote_source.dart';
import '../../../core/values/app_endpoints.dart';
import '../../../network/dio_provider.dart';
import '../../model/api_response_model.dart';
import '../../model/pagination_response_model.dart';

class BlogRemoteDataSourceImpl extends BaseRemoteSource
    implements BlogRemoteDataSource {
  List<BlogModel> _parseData(Response<dynamic> response) {
    ApiResponseModel apiResponseModel =
        ApiResponseModel.fromJson(response.data);

    final paginatedResponse = PaginationResponseModel<BlogModel>.fromJson(
      apiResponseModel.data,
      (json) => BlogModel.fromJson(json as Map<String, dynamic>),
    );

    // Access the list of promos
    final List<BlogModel>? data = paginatedResponse.data;

    return data ?? [];
  }

  @override
  Future<List<BlogModel>> getAll() {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.blog}";
    // add token

    var dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => _parseData(response));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BlogDetailModel> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
