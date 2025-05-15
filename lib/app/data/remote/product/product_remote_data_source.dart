import '../../models/product_model.dart';

abstract class ProductRemoteDataSource {
  /// Get all products
  Future<List<ProductModel>> getAll();

  /// Get product by id
  Future<ProductModel> getById(String id);
}
