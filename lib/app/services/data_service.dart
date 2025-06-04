import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:exachanger_get_app/app/data/models/transaction_model.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:exachanger_get_app/app/data/repository/promo/promo_repository.dart';
import 'package:exachanger_get_app/app/data/repository/transaction/transaction_repository.dart';
import 'package:get/get.dart';

/// DataService acts as a central repository for shared data across the app
/// It persists data between screens and controllers
class DataService extends GetxService {
  // Data repositories
  final PromoRepository promoRepository =
      Get.find(tag: (PromoRepository).toString());
  final BlogRepository blogRepository =
      Get.find(tag: (BlogRepository).toString());
  final TransactionRepository transactionRepository =
      Get.find(tag: (TransactionRepository).toString());
  final ProductRepository productRepository =
      Get.find(tag: (ProductRepository).toString());

  // Observable data containers
  final Rx<List<PromoModel>> promoList = Rx<List<PromoModel>>([]);
  final Rx<List<BlogModel>> blogList = Rx<List<BlogModel>>([]);
  final Rx<List<TransactionModel>> transactionList =
      Rx<List<TransactionModel>>([]);
  final Rx<List<ProductModel>> productList = Rx<List<ProductModel>>([]);
  // Flag to indicate if data has been loaded
  final RxBool dataLoaded = false.obs;

  // Flag to indicate if the service is initialized
  final RxBool isInitialized = false.obs;

  /// Initialize the service and return itself
  Future<DataService> init() async {
    print('DataService initialized');
    isInitialized.value = true;
    return this;
  }

  /// Store data in the service
  void setData({
    List<PromoModel>? promos,
    List<BlogModel>? blogs,
    List<TransactionModel>? transactions,
    List<ProductModel>? products,
  }) {
    if (promos != null && promos.isNotEmpty) {
      promoList.value = promos;
    }

    if (blogs != null && blogs.isNotEmpty) {
      blogList.value = blogs;
    }

    if (transactions != null && transactions.isNotEmpty) {
      transactionList.value = transactions;
    }

    if (products != null && products.isNotEmpty) {
      productList.value = products;
    }

    // If all data is loaded, set the flag
    if (promoList.value.isNotEmpty &&
        blogList.value.isNotEmpty &&
        transactionList.value.isNotEmpty &&
        productList.value.isNotEmpty) {
      dataLoaded.value = true;
    }

    // Print data status for debugging
    print('DataService updated: promos=${promoList.value.length}, '
        'blogs=${blogList.value.length}, '
        'transactions=${transactionList.value.length}, '
        'products=${productList.value.length}');
  }

  /// Load/refresh all data from API
  Future<void> refreshAllData() async {
    try {
      print('DEBUG - Starting refreshAllData in DataService');

      // Create individual futures and use try-catch for each one to make it more robust
      List<PromoModel> promos = [];
      List<BlogModel> blogs = [];
      List<TransactionModel> transactions = [];
      List<ProductModel> products = [];

      try {
        promos = await promoRepository.getAllPromos();
        print('DEBUG - Promos fetched: ${promos.length}');
      } catch (e) {
        print('ERROR fetching promos: $e');
      }

      try {
        blogs = await blogRepository.getAllBlogs();
        print('DEBUG - Blogs fetched: ${blogs.length}');
      } catch (e) {
        print('ERROR fetching blogs: $e');
      }

      try {
        transactions = await transactionRepository.getAllTransactions();
        print('DEBUG - Transactions fetched: ${transactions.length}');
      } catch (e) {
        print('ERROR fetching transactions: $e');
      }

      try {
        products = await productRepository.getAllProducts();
        print('DEBUG - Products fetched: ${products.length}');
      } catch (e) {
        print('ERROR fetching products: $e');
      }

      // Update observable lists
      promoList.value = promos;
      blogList.value = blogs;
      transactionList.value =
          transactions; // Print raw products data for debugging
      print(
          'DEBUG - DataService.refreshAllData: Raw products from API: ${products.length}');
      if (products.isNotEmpty) {
        print(
            'DEBUG - DataService.refreshAllData: Raw product statuses: ${products.map((p) => p.status).toList()}');

        // Filter only active products (status == 1)
        List<ProductModel> activeProducts =
            products.where((p) => p.status == 1).toList();

        // Only update if we actually got active products, otherwise keep existing
        if (activeProducts.isNotEmpty) {
          productList.value = activeProducts;
        } else {
          print(
              'DEBUG - DataService.refreshAllData: No active products found, keeping existing products');
        }

        // Log filtered products count
        print(
            'DEBUG - DataService.refreshAllData: Active products after filter: ${productList.value.length}');
      } else {
        print(
            'DEBUG - DataService.refreshAllData: No products fetched from API, keeping existing products');
      }

      // Set loaded flag
      dataLoaded.value = true;

      print('Data refreshed successfully: promos=${promos.length}, '
          'blogs=${blogs.length}, '
          'transactions=${transactions.length}, '
          'products=${products.length}');
    } catch (e) {
      print('Error refreshing data: $e');
      throw e;
    }
  }
}
