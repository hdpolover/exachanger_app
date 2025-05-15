import 'package:dio/dio.dart';

import '../../../core/base/base_remote_source.dart';
import '../../../core/values/app_endpoints.dart';
import '../../../network/dio_provider.dart';
import '../../models/api_response_model.dart';
import '../../models/pagination_response_model.dart';
import '../../models/transaction_model.dart';
import 'transaction_remote_data_source.dart';

class TransactionRemoteDataSourceImpl extends BaseRemoteSource
    implements TransactionRemoteDataSource {
  List<TransactionModel> _parseData(Response<dynamic> response) {
    ApiResponseModel apiResponseModel =
        ApiResponseModel.fromJson(response.data);

    final paginatedResponse =
        PaginationResponseModel<TransactionModel>.fromJson(
      apiResponseModel.data,
      (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
    );

    // Access the list of transactions
    final List<TransactionModel>? data = paginatedResponse.data;

    return data ?? [];
  }

  @override
  Future<List<TransactionModel>> getAll() {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.transactions}";

    var dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => _parseData(response));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TransactionModel> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
