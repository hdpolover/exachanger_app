import 'package:dio/dio.dart';

import '../../../core/base/base_remote_source.dart';
import '../../../core/values/app_endpoints.dart';
import '../../../network/dio_provider.dart';
import '../../models/api_response_model.dart';
import '../../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl extends BaseRemoteSource
    implements ProductRemoteDataSource {
  List<ProductModel> _parseData(Response<dynamic> response) {
    ApiResponseModel apiResponseModel = ApiResponseModel.fromJson(
      response.data,
    );

    // Handle different response structures
    dynamic data;
    if (apiResponseModel.data is Map<String, dynamic> &&
        (apiResponseModel.data as Map<String, dynamic>).containsKey('data')) {
      // Nested structure: { "data": { "data": [...] } }
      data = apiResponseModel.data['data'];
    } else if (apiResponseModel.data is List) {
      // Direct list: { "data": [...] }
      data = apiResponseModel.data;
    } else {
      // Fallback: treat as direct data
      data = apiResponseModel.data;
    }

    // Ensure data is a List
    if (data is! List) {
      print("ERROR: Expected List but got ${data.runtimeType}: $data");
      return [];
    } // Parse products
    final List<ProductModel> products = data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return products;
  }

  ProductModel _parseProductData(Response<dynamic> response) {
    ApiResponseModel apiResponseModel = ApiResponseModel.fromJson(
      response.data,
    );

    return ProductModel.fromJson(apiResponseModel.data as Map<String, dynamic>);
  }

  @override
  Future<List<ProductModel>> getAll() {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.products}";

    var dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((response) => _parseData(response));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> getById(String id) {
    var endpoint = "${DioProvider.baseUrl}/${AppEndpoints.products}/$id";

    var dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((response) => _parseProductData(response));
    } catch (e) {
      rethrow;
    }
  }
}
