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
      // Create a batch of futures to run in parallel
      final futures = await Future.wait([
        promoRepository.getAllPromos(),
        blogRepository.getAllBlogs(),
        transactionRepository.getAllTransactions(),
        productRepository.getAllProducts()
      ]); // Extract results
      final promos = futures[0] as List<PromoModel>;
      final blogs = futures[1] as List<BlogModel>;
      final transactions = futures[2] as List<TransactionModel>;
      final products = futures[3] as List<ProductModel>;

      // Update observable lists
      promoList.value = promos;
      blogList.value = blogs;
      transactionList.value = transactions;
      // Filter only active products (status == 1)
      productList.value = products.where((p) => p.status == 1).toList();

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
