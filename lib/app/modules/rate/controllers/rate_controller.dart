import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RateController extends BaseController {
  final ProductRepository _productRepository = Get.find<ProductRepository>(
    tag: (ProductRepository).toString(),
  );
  final products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  late DataService _dataService;

  // Refresh controller for pull-to-refresh
  RefreshController? _refreshController;

  RefreshController get refreshController {
    _refreshController ??= RefreshController(initialRefresh: false);
    return _refreshController!;
  }

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
        // Small delay to ensure shimmer is visible even on fast loads
        Future.delayed(Duration(milliseconds: 300), () {
          isLoading.value = false;
        });
      } else {
        // If for some reason products aren't in DataService, load them directly
        fetchProducts();
        print("Products not found in DataService, fetching directly");
      }
    } catch (e) {
      error.value = 'Error loading products: ${e.toString()}';
      isLoading.value = false;
      print("Error loading products from DataService: $e");
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _refreshController?.dispose();
    super.onClose();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    error.value = '';

    try {
      final fetchedProducts = await _productRepository.getAllProducts();
      // Filter only products with active status and active rates
      final activeProducts = fetchedProducts
          .where(
            (p) =>
                (p.status == "1" ||
                    p.status == "active" ||
                    p.status == 1.toString()) &&
                p.rates != null &&
                p.rates!.isNotEmpty &&
                p.rates!.any((rate) => rate.status == 'active'),
          )
          .toList();
      products.value = activeProducts;

      // Also update the DataService with the new products
      _dataService.setData(products: activeProducts);
      print("Rate products fetched and updated: ${activeProducts.length}");
    } catch (e) {
      error.value = 'Failed to load products: ${e.toString()}';
      print("Error fetching rate products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    // When user explicitly refreshes, fetch new data from API
    fetchProducts();
  }

  // Method for pull-to-refresh
  Future<void> onRefresh() async {
    print("DEBUG - Pull to refresh triggered in Rate tab!");
    try {
      await fetchProducts();
      print("DEBUG - Rate refresh completed successfully");
      refreshController.refreshCompleted();
    } catch (error) {
      print("DEBUG - Rate refresh failed: $error");
      refreshController.refreshFailed();
    }
  }
}
