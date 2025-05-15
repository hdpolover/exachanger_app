import '../../models/product_model.dart';

abstract class ProductRepository {
  /// Get all products
  Future<List<ProductModel>> getAllProducts();

  /// Get product by id
  Future<ProductModel> getProductById(String id);
}
