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

  // Flag to indicate if we are in "fixed product" mode (coming from home page)
  final isFixedSendProduct = false.obs;

  final isLoading = true.obs;
  final error = ''.obs;
  late DataService _dataService;

  @override
  void onInit() {
    super.onInit();
    _dataService = Get.find<DataService>();

    // Clear previous selections when the controller is initialized
    selectedSendProduct.value = null;
    selectedReceiveRate.value = null;
    isFixedSendProduct.value = false;

    // Load all products by default
    loadProductsWithRates();

    // Process arguments if available
    processArguments();
  }

  /// Process navigation arguments to handle fixed product mode
  void processArguments() {
    final args = Get.arguments;
    print("ExchangeController processing arguments: $args");

    if (args != null && args is Map) {
      // Check if this is a fixed product from home
      if (args.containsKey('fixedProduct') &&
          args.containsKey('fromHome') &&
          args['fromHome'] == true) {
        final product = args['fixedProduct'] as ProductModel;

        // Reset previous state
        isFixedSendProduct.value = true;
        selectedSendProduct.value = product;
        print("Fixed product mode enabled: ${product.name}");

        // Only load available receive options for this product
        loadReceiveOptionsForProduct(product);
      }
    } else if (args != null && args is ProductModel) {
      // Legacy handling (just in case)
      isFixedSendProduct.value = true;
      selectedSendProduct.value = args;
      print("Fixed product mode (legacy): ${args.name}");
      loadReceiveOptionsForProduct(args);
    }
  }

  // New method to load only receive options for a single product
  void loadReceiveOptionsForProduct(ProductModel product) {
    isLoading.value = true;
    error.value = '';

    try {
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
          error.value = 'No exchange options available for this product';
        }
      } else {
        availableReceiveOptions.value = [];
        selectedReceiveRate.value = null;
        error.value = 'No exchange options available for this product';
      }
    } catch (e) {
      error.value = 'Error loading exchange options: ${e.toString()}';
      print("Error loading exchange options for product: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();

    // Process arguments when screen becomes ready
    processArguments();
  }

  @override
  void onClose() {
    // Reset the fixed product mode when leaving the screen
    isFixedSendProduct.value = false;
    super.onClose();
  }

  /// Load products that have rates from DataService
  void loadProductsWithRates() {
    // Skip if we're in fixed product mode - we only need products for that specific product
    if (isFixedSendProduct.value) return;

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
        
        // Set default selected product if available and no product is currently selected
        if (products.isNotEmpty && selectedSendProduct.value == null) {
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
