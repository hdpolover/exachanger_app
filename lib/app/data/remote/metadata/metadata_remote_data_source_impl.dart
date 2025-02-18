import 'package:dio/dio.dart';
import 'package:exachanger_get_app/app/core/values/app_endpoints.dart';
import 'package:exachanger_get_app/app/data/model/api_response_model.dart';
import 'package:exachanger_get_app/app/data/model/metadata_model.dart';
import 'package:exachanger_get_app/app/data/remote/metadata/metadata_remote_data_source.dart';

import '/app/core/base/base_remote_source.dart';
import '/app/network/dio_provider.dart';

class MetadataRemoteDataSourceImpl extends BaseRemoteSource
    implements MetaDataRemoteDataSource {
  // @override
  // Future<GithubProjectSearchResponse> searchGithubProject(
  //     GithubSearchQueryParam queryParam) {
  //   var endpoint = "${DioProvider.baseUrl}/search/repositories";
  //   var dioCall = dioClient.get(endpoint, queryParameters: queryParam.toJson());

  //   try {
  //     return callApiWithErrorParser(dioCall)
  //         .then((response) => _parseGithubProjectSearchResponse(response));
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // @override
  // Future<Item> getGithubProjectDetails(String userName, String repositoryName) {
  //   var endpoint = "${DioProvider.baseUrl}/repos/$userName/$repositoryName";
  //   var dioCall = dioClient.get(endpoint);

  //   try {
  //     return callApiWithErrorParser(dioCall)
  //         .then((response) => _parseGithubProjectResponse(response));
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  MetaDataModel _parseData(Response<dynamic> response) {
    ApiResponseModel apiResponseModel =
        ApiResponseModel.fromJson(response.data);

    return MetaDataModel.fromJson(apiResponseModel.data);
  }

  @override
  Future<MetaDataModel> getPageData(String page) {
    var endpoint =
        "${DioProvider.baseUrl}/${AppEndpoints.metadata}?page=$page&type=1";
    var dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => _parseData(response));
    } catch (e) {
      rethrow;
    }
  }
}
