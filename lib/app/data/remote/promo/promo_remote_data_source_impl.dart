import 'package:dio/dio.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:exachanger_get_app/app/data/remote/promo/promo_remote_data_source.dart';

import '../../../core/base/base_remote_source.dart';
import '../../../core/values/app_endpoints.dart';
import '../../../network/dio_provider.dart';
import '../../models/api_response_model.dart';
import '../../models/pagination_response_model.dart';

class PromoRemoteDataSourceImpl extends BaseRemoteSource
    implements PromoRemoteDataSource {
  List<PromoModel> _parseData(Response<dynamic> response) {
    ApiResponseModel apiResponseModel =
        ApiResponseModel.fromJson(response.data);

    final paginatedResponse = PaginationResponseModel<PromoModel>.fromJson(
      apiResponseModel.data,
      (json) => PromoModel.fromJson(json as Map<String, dynamic>),
    );

    // Access the list of promos
    final List<PromoModel>? data = paginatedResponse.data;

    return data ?? [];
  }

  @override
  Future<List<PromoModel>> getAll() {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.promo}";
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
  Future<PromoModel> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
