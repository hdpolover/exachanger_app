import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/remote/product/product_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:get/get.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteSource =
      Get.find(tag: (ProductRemoteDataSource).toString());

  @override
  Future<List<ProductModel>> getAllProducts() {
    return _remoteSource.getAll();
  }

  @override
  Future<ProductModel> getProductById(String id) {
    return _remoteSource.getById(id);
  }
}
