import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/models/rate_model.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:get/get.dart';

class ExchangeController extends BaseController {
  // Products and rates data
  final Rx<List<ProductModel>> productsWithRates = Rx<List<ProductModel>>([]);
  final Rx<ProductModel?> selectedSendProduct = Rx<ProductModel?>(null);
  final Rx<List<RateModel>> availableReceiveOptions = Rx<List<RateModel>>([]);
  final Rx<RateModel?> selectedReceiveRate = Rx<RateModel?>(null);

  final isLoading = true.obs;
  final error = ''.obs;
  late DataService _dataService;

  @override
  void onInit() {
    super.onInit();
    _dataService = Get.find<DataService>();
    loadProductsWithRates();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Load products that have rates from DataService
  void loadProductsWithRates() {
    isLoading.value = true;
    error.value = '';

    try {
      if (_dataService.productList.value.isNotEmpty) {
        // Filter products that have at least one active rate
        final products = _dataService.productList.value
            .where((product) =>
                product.rates != null &&
                product.rates!.isNotEmpty &&
                product.rates!.any((rate) => rate.status == 'active'))
            .toList();

        productsWithRates.value = products;

        // Set default selected product if available
        if (products.isNotEmpty) {
          selectSendProduct(products.first);
        }

        print("Products with rates loaded: ${productsWithRates.value.length}");
      } else {
        error.value = 'No products available';
        print("No products found in DataService");
      }
    } catch (e) {
      error.value = 'Error loading products: ${e.toString()}';
      print("Error loading products from DataService: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Select send product and update available receive options
  void selectSendProduct(ProductModel product) {
    selectedSendProduct.value = product;

    // Update available receive options based on the selected product's rates
    if (product.rates != null) {
      availableReceiveOptions.value = product.rates!
          .where((rate) => rate.status == 'active' && rate.product != null)
          .toList();

      // Set default selected rate if available
      if (availableReceiveOptions.value.isNotEmpty) {
        selectedReceiveRate.value = availableReceiveOptions.value.first;
      } else {
        selectedReceiveRate.value = null;
      }
    } else {
      availableReceiveOptions.value = [];
      selectedReceiveRate.value = null;
    }
  }

  /// Select receive rate
  void selectReceiveRate(RateModel rate) {
    selectedReceiveRate.value = rate;
  }
}
