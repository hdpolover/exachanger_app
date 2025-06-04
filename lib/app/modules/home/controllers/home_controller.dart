import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:exachanger_get_app/app/data/models/user_model.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:exachanger_get_app/app/data/repository/transaction/transaction_repository.dart';
import 'package:exachanger_get_app/app/modules/splash/controllers/splash_controller.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:get/get.dart';

import '../../../data/models/transaction_model.dart';
import '../../../data/repository/promo/promo_repository.dart';

class HomeController extends BaseController {
  final PromoRepository promoRepository =
      Get.find(tag: (PromoRepository).toString());

  final BlogRepository blogRepository =
      Get.find(tag: (BlogRepository).toString());

  final TransactionRepository transactionRepository =
      Get.find(tag: (TransactionRepository).toString());

  final ProductRepository productRepository =
      Get.find(tag: (ProductRepository).toString());

  // DataService for sharing data between controllers
  DataService? _dataService;

  // Getter with lazy initialization for DataService
  DataService get dataService {
    if (_dataService == null) {
      try {
        _dataService = Get.find<DataService>();
      } catch (e) {
        print("DataService not available yet: $e");
      }
    }
    return _dataService!;
  }

  //promos
  Rx<List<PromoModel>> promoList = Rx<List<PromoModel>>([]);
  List<PromoModel> get promos => promoList.value;

  // blogs
  Rx<List<BlogModel>> blogList = Rx<List<BlogModel>>([]);
  List<BlogModel> get blogs => blogList.value;

  // transactions
  Rx<List<TransactionModel>> transactionList = Rx<List<TransactionModel>>([]);
  List<TransactionModel> get transactions => transactionList.value;

  // products
  Rx<List<ProductModel>> productList = Rx<List<ProductModel>>([]);
  List<ProductModel> get products => productList.value;

  // User data
  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();
  final Rx<UserModel?> userData = Rx<UserModel?>(null);

  // Data loading state
  final RxBool isLoading = false.obs;
  final RxString error = "".obs;

  // Load user data
  Future<void> loadUserData() async {
    try {
      // First try to get from Get.find which would be faster
      try {
        if (Get.isRegistered<UserModel>(tag: "current_user")) {
          UserModel user = Get.find<UserModel>(tag: "current_user");
          userData.value = user;
          print('User data fetched from Get: ${user.name}');
          return;
        } else {
          print('UserModel not registered with tag "current_user"');
        }
      } catch (e) {
        print('Error accessing user data from Get storage: $e');
        // Fall back to getting reactive object
        try {
          if (Get.isRegistered<Rx<UserModel?>>(tag: "user_data")) {
            Rx<UserModel?> rxUser = Get.find<Rx<UserModel?>>(tag: "user_data");
            if (rxUser.value != null) {
              userData.value = rxUser.value;
              print(
                  'User data fetched from reactive object: ${rxUser.value?.name}');
              return;
            } else {
              print('Reactive user data found but value is null');
            }
          } else {
            print('Reactive user data not registered with tag "user_data"');
          }
        } catch (e) {
          print('Error accessing reactive user data: $e');
        }
      }

      // Fall back to loading from preferences
      final userFromPrefs = await preferenceManager.getUserData();
      if (userFromPrefs != null) {
        userData.value = userFromPrefs;
        print('User data loaded from preferences: ${userFromPrefs.name}');

        // Store for future use
        if (Get.isRegistered<UserModel>(tag: "current_user")) {
          Get.delete<UserModel>(tag: "current_user");
        }
        Get.put<UserModel>(userFromPrefs, tag: "current_user", permanent: true);
        print('User data registered with GetX');
      } else {
        print('No user data found in preferences');
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Get data from DataService, SplashController or fetch if not available
  void getData() {
    try {
      // Method 0: Check DataService first (preferred method)
      try {
        if (_dataService != null && dataService.dataLoaded.value) {
          promoList.value = List<PromoModel>.from(dataService.promoList.value);
          blogList.value = List<BlogModel>.from(dataService.blogList.value);
          transactionList.value =
              List<TransactionModel>.from(dataService.transactionList.value);
          productList.value = List<ProductModel>.from(
              dataService.productList.value.where((product) =>
                  product.status == "active")); // Filter active products
          print("All data loaded from DataService");
          return;
        }
      } catch (e) {
        print("Error accessing DataService: $e");
      }

      // Method 1: Try to get the splash controller directly
      try {
        final splashController =
            Get.find<SplashController>(tag: "splash_controller");

        // Create deep copies of lists to avoid reference issues
        if (splashController.promoList.value.isNotEmpty) {
          promoList.value =
              List<PromoModel>.from(splashController.promoList.value);
          print(
              "Promos loaded from splash controller: ${promoList.value.length}");
        }

        if (splashController.blogList.value.isNotEmpty) {
          blogList.value =
              List<BlogModel>.from(splashController.blogList.value);
          print(
              "Blogs loaded from splash controller: ${blogList.value.length}");
        }

        if (splashController.transactionList.value.isNotEmpty) {
          transactionList.value = List<TransactionModel>.from(
              splashController.transactionList.value);
          print(
              "Transactions loaded from splash controller: ${transactionList.value.length}");
        }

        if (splashController.productList.value.isNotEmpty) {
          // Filter only active products (status == "active") to match DataService behavior
          productList.value = List<ProductModel>.from(splashController
              .productList.value
              .where((p) => p.status == "active"));
          print(
              "Products loaded from splash controller: ${productList.value.length}");
        }

        // Update DataService as well for future use
        if (promoList.value.isNotEmpty &&
            blogList.value.isNotEmpty &&
            transactionList.value.isNotEmpty &&
            productList.value.isNotEmpty) {
          dataService.setData(
              promos: promoList.value,
              blogs: blogList.value,
              transactions: transactionList.value,
              products: productList.value);
        }
      } catch (e) {
        print("Method 1 failed: $e");
      }

      // Method 2: Try to get cached data from Get storage
      if (promoList.value.isEmpty) {
        try {
          final cachedPromos =
              Get.find<Rx<List<PromoModel>>>(tag: "cached_promos");
          final cachedBlogs =
              Get.find<Rx<List<BlogModel>>>(tag: "cached_blogs");
          final cachedTransactions =
              Get.find<Rx<List<TransactionModel>>>(tag: "cached_transactions");
          final cachedProducts =
              Get.find<Rx<List<ProductModel>>>(tag: "cached_products");

          if (cachedPromos.value.isNotEmpty) {
            promoList.value = List<PromoModel>.from(cachedPromos.value);
            print("Promos loaded from cached data: ${promoList.value.length}");
          }

          if (cachedBlogs.value.isNotEmpty) {
            blogList.value = List<BlogModel>.from(cachedBlogs.value);
            print("Blogs loaded from cached data: ${blogList.value.length}");
          }

          if (cachedTransactions.value.isNotEmpty) {
            transactionList.value =
                List<TransactionModel>.from(cachedTransactions.value);
            print(
                "Transactions loaded from cached data: ${transactionList.value.length}");
          }

          if (cachedProducts.value.isNotEmpty) {
            // Filter only active products (status == "active")
            productList.value = List<ProductModel>.from(
                cachedProducts.value.where((p) => p.status == "active"));
            print(
                "Products loaded from cached data: ${productList.value.length}");
          }

          // Update DataService as well for future use
          if (promoList.value.isNotEmpty &&
              blogList.value.isNotEmpty &&
              transactionList.value.isNotEmpty &&
              productList.value.isNotEmpty) {
            dataService.setData(
                promos: promoList.value,
                blogs: blogList.value,
                transactions: transactionList.value,
                products: productList.value);
          }
        } catch (e) {
          print("Method 2 failed: $e");
        }
      }

      // If we successfully got data from either method, return early
      if (promoList.value.isNotEmpty &&
          blogList.value.isNotEmpty &&
          transactionList.value.isNotEmpty &&
          productList.value.isNotEmpty) {
        print("All data loaded from cache");
        return;
      }
    } catch (e) {
      print("Error getting cached data: $e");
      // Continue to fetch data if cached data isn't found
    }

    // If we got here, we need to fetch the data
    print("Fetching fresh data in HomeController");
    isLoading.value = true;
    error.value = "";

    // Fetch promos
    var promoService = promoRepository.getAllPromos();
    callDataService(promoService, onSuccess: (data) {
      promoList.value = data;
      print("Promos fetched in HomeController: ${data.length}");
    }, onError: (error) {
      showErrorMessage(error.toString());
      this.error.value = error.toString();
    });

    // Fetch blogs
    var blogService = blogRepository.getAllBlogs();
    callDataService(blogService, onSuccess: (data) {
      blogList.value = data;
      print("Blogs fetched in HomeController: ${data.length}");
    }, onError: (error) {
      showErrorMessage(error.toString());
      this.error.value = error.toString();
    });

    // Fetch transactions
    var transactionService = transactionRepository.getAllTransactions();
    callDataService(transactionService, onSuccess: (data) {
      transactionList.value = data;
      print("Transactions fetched in HomeController: ${data.length}");
    }, onError: (error) {
      showErrorMessage(error.toString());
      this.error.value = error.toString();
    });

    // Fetch products
    var productService = productRepository.getAllProducts();
    callDataService(productService, onSuccess: (data) {
      // Filter only active products (status == "active") to match DataService behavior
      productList.value = data.where((p) => p.status == "active").toList();
      print("Products fetched in HomeController: ${productList.value.length}");
      isLoading.value = false;

      // Update DataService with newly fetched data
      dataService.setData(
          promos: promoList.value,
          blogs: blogList.value,
          transactions: transactionList.value,
          products: productList.value);
    }, onError: (error) {
      showErrorMessage(error.toString());
      this.error.value = error.toString();
      isLoading.value = false;
    });
  }

  // Refresh data from API (for pull-to-refresh functionality)
  Future<void> refreshData() async {
    // Store current data as backup in case of API failures
    List<ProductModel> currentProducts =
        List<ProductModel>.from(productList.value);
    List<PromoModel> currentPromos = List<PromoModel>.from(promoList.value);
    List<BlogModel> currentBlogs = List<BlogModel>.from(blogList.value);
    List<TransactionModel> currentTransactions =
        List<TransactionModel>.from(transactionList.value);

    print(
        "DEBUG - Before refresh: Current active products count: ${currentProducts.length}");

    try {
      isLoading.value = true;
      error.value = "";

      // Make sure we have access to the DataService
      if (_dataService != null) {
        // Use DataService to refresh all data at once
        await dataService.refreshAllData();
        // Update our local lists from the refreshed data in DataService
        if (dataService.promoList.value.isNotEmpty) {
          promoList.value = List<PromoModel>.from(dataService.promoList.value);
        }
        if (dataService.blogList.value.isNotEmpty) {
          blogList.value = List<BlogModel>.from(dataService.blogList.value);
        }
        if (dataService.transactionList.value.isNotEmpty) {
          transactionList.value =
              List<TransactionModel>.from(dataService.transactionList.value);
        }
        // Make sure we're only getting active products (status == "active") if we have any products
        if (dataService.productList.value.isNotEmpty) {
          // Filter the products to only get active ones
          List<ProductModel> activeProducts = dataService.productList.value
              .where((p) => p.status == "active")
              .toList();

          if (activeProducts.isNotEmpty) {
            productList.value = activeProducts;
            print(
                "DEBUG - After refresh: Active products count=${activeProducts.length}");
          } else {
            // No active products found, keep existing
            print(
                "DEBUG - No active products found after refresh, keeping existing (${currentProducts.length})");
            if (currentProducts.isNotEmpty) {
              productList.value = currentProducts;
            }
          }
        } else {
          // No products at all, keep existing
          print(
              "DEBUG - No products found in DataService after refresh, keeping existing (${currentProducts.length})");
          if (currentProducts.isNotEmpty) {
            productList.value = currentProducts;
          }
        }

        isLoading.value = false;
        print("All data refreshed through DataService");
        return;
      } else {
        print("DataService not available, using fallback");
      }
    } catch (e) {
      print(
          "DataService refresh failed, falling back to individual API calls: $e");
      error.value = e.toString();

      // Fall back to individual API calls if DataService refresh fails

      // Fetch promos
      await callDataService(
        promoRepository.getAllPromos(),
        onSuccess: (data) {
          promoList.value = data;
          // Update the DataService with new promos
          dataService.setData(promos: data);
        },
        onError: (error) {
          showErrorMessage(error.toString());
          this.error.value = error.toString();
        },
      );

      // Fetch blogs
      await callDataService(
        blogRepository.getAllBlogs(),
        onSuccess: (data) {
          blogList.value = data;
          // Update the DataService with new blogs
          dataService.setData(blogs: data);
        },
        onError: (error) {
          showErrorMessage(error.toString());
          this.error.value = error.toString();
        },
      );

      // Fetch transactions
      await callDataService(
        transactionRepository.getAllTransactions(),
        onSuccess: (data) {
          transactionList.value = data;
          // Update the DataService with new transactions
          dataService.setData(transactions: data);
        },
        onError: (error) {
          showErrorMessage(error.toString());
          this.error.value = error.toString();
        },
      );

      // Fetch products
      await callDataService(
        productRepository.getAllProducts(),
        onSuccess: (data) {
          print(
              "DEBUG - Fallback refresh: Raw products fetched: ${data.length}");

          if (data.isNotEmpty) {
            // Filter only active products (status == "active") to match DataService behavior
            List<ProductModel> activeProducts =
                data.where((p) => p.status == "active").toList();
            print(
                "DEBUG - Fallback refresh: Active products filtered: ${activeProducts.length}");
            if (activeProducts.isNotEmpty) {
              productList.value = activeProducts;
              // Update the DataService with new products
              dataService.setData(products: activeProducts);
            } else {
              print(
                  "DEBUG - Fallback refresh: No active products found, keeping existing products");
              // Maintain existing products if available
              if (currentProducts.isNotEmpty) {
                print(
                    "DEBUG - Fallback refresh: Restoring ${currentProducts.length} previous products");
                // Keep the current products
                // Don't update DataService with currentProducts to avoid confusion
              }
            }
          } else {
            print(
                "DEBUG - Fallback refresh: No products returned from API, keeping existing products");
            // Maintain existing products if available
            if (currentProducts.isNotEmpty) {
              print(
                  "DEBUG - Fallback refresh: Restoring ${currentProducts.length} previous products");
              // Keep the current products
              // Don't update DataService with currentProducts to avoid confusion
            }
          }
        },
        onError: (error) {
          showErrorMessage(error.toString());
          this.error.value = error.toString();
          print("DEBUG - Fallback refresh: Error fetching products: $error");
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh user data when the home screen becomes active
    loadUserData();
  }

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true; // Start with loading state to show shimmer effects
    getData();
    loadUserData().then((_) {
      // Small delay to ensure shimmer is visible even on fast loads
      Future.delayed(Duration(milliseconds: 300), () {
        isLoading.value = false;
      });
    });
  }
}
