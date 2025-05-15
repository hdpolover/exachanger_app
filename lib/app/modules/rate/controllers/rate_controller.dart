import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:get/get.dart';

class RateController extends BaseController {
  final ProductRepository _productRepository =
      Get.find<ProductRepository>(tag: (ProductRepository).toString());
  final products = <ProductModel>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    error.value = '';

    try {
      final fetchedProducts = await _productRepository.getAllProducts();
      // Filter only products with status 1 (active)
      products.value = fetchedProducts.where((p) => p.status == 1).toList();
    } catch (e) {
      error.value = 'Failed to load products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    fetchProducts();
  }
}
