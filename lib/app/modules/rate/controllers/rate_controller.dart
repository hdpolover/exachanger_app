import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:get/get.dart';

class RateController extends BaseController {
  final ProductRepository _productRepository =
      Get.find<ProductRepository>(tag: (ProductRepository).toString());
  final products = <ProductModel>[].obs;
  final isLoading = true.obs;
  final error = ''.obs;
  late DataService _dataService;

  @override
  void onInit() {
    super.onInit();
    _dataService = Get.find<DataService>();
    _getProductsFromDataService();
  }

  // Get products from DataService (loaded during splash screen)
  void _getProductsFromDataService() {
    isLoading.value = true;
    error.value = '';

    try {
      // First check if products are already loaded in DataService
      if (_dataService.productList.value.isNotEmpty) {
        products.value = _dataService.productList.value;
        print("Products loaded from DataService: ${products.length}");
      } else {
        // If for some reason products aren't in DataService, load them directly
        fetchProducts();
        print("Products not found in DataService, fetching directly");
      }
    } catch (e) {
      error.value = 'Error loading products: ${e.toString()}';
      print("Error loading products from DataService: $e");
    } finally {
      isLoading.value = false;
    }
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
      final activeProducts =
          fetchedProducts.where((p) => p.status == 1).toList();
      products.value = activeProducts;

      // Also update the DataService with the new products
      _dataService.setData(products: activeProducts);
    } catch (e) {
      error.value = 'Failed to load products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    // When user explicitly refreshes, fetch new data from API
    fetchProducts();
  }
}
