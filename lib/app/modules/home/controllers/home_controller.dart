import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:exachanger_get_app/app/data/models/notification_model.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:exachanger_get_app/app/data/models/user_model.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:exachanger_get_app/app/data/repository/transaction/transaction_repository.dart';
import 'package:exachanger_get_app/app/modules/splash/controllers/splash_controller.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/models/transaction_model.dart';
import '../../../data/repository/promo/promo_repository.dart';

class HomeController extends BaseController {
  final PromoRepository promoRepository = Get.find(
    tag: (PromoRepository).toString(),
  );

  final BlogRepository blogRepository = Get.find(
    tag: (BlogRepository).toString(),
  );

  final TransactionRepository transactionRepository = Get.find(
    tag: (TransactionRepository).toString(),
  );

  final ProductRepository productRepository = Get.find(
    tag: (ProductRepository).toString(),
  );

  // DataService for sharing data between controllers
  DataService? _dataService;

  // Getter with lazy initialization for DataService
  DataService? get dataService {
    if (_dataService == null) {
      try {
        _dataService = Get.find<DataService>();
      } catch (e) {
        print("DataService not available yet: $e");
        return null;
      }
    }
    return _dataService;
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
  // notifications
  Rx<List<NotificationModel>> notificationList = Rx<List<NotificationModel>>(
    [],
  );
  List<NotificationModel> get notifications => notificationList.value;
  final RxBool isLoadingNotifications = false.obs;
  final RxString notificationError =
      "".obs; // Refresh controller for notification pull-to-refresh
  RefreshController? _notificationRefreshController;
  // Notification pagination
  final RxInt notificationPage = 1.obs;
  final RxBool hasMoreNotifications = true.obs;
  final RxInt totalNotifications = 0.obs;

  RefreshController get notificationRefreshController {
    _notificationRefreshController ??= RefreshController(initialRefresh: false);
    return _notificationRefreshController!;
  }

  // User data
  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();
  final Rx<UserModel?> userData = Rx<UserModel?>(null);

  // Data loading state
  final RxBool isLoading = false.obs;
  final RxString error = "".obs;
  // Refresh controller for pull-to-refresh
  RefreshController? _refreshController;

  RefreshController get refreshController {
    // Only dispose if it already exists and we need to replace it
    _refreshController ??= RefreshController(initialRefresh: false);
    return _refreshController!;
  }

  // Separate refresh controller for more view
  RefreshController? _moreRefreshController;

  RefreshController get moreRefreshController {
    // Only dispose if it already exists and we need to replace it
    _moreRefreshController ??= RefreshController(initialRefresh: false);
    return _moreRefreshController!;
  }

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
                'User data fetched from reactive object: ${rxUser.value?.name}',
              );
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
        // Set a default user to prevent null errors
        userData.value = UserModel(id: "", name: "User", email: "");
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Set a default user to prevent null errors
      userData.value = UserModel(id: "", name: "User", email: "");
    }
  }

  // Get data from DataService, SplashController or fetch if not available
  void getData() {
    try {
      // Method 0: Check DataService first (preferred method)
      try {
        final ds = dataService;
        if (ds != null && ds.dataLoaded.value) {
          promoList.value = List<PromoModel>.from(ds.promoList.value);
          blogList.value = List<BlogModel>.from(ds.blogList.value);
          transactionList.value = List<TransactionModel>.from(
            ds.transactionList.value,
          );
          productList.value = List<ProductModel>.from(
            ds.productList.value.where(
              (product) =>
                  (product.status == "1" ||
                      product.status == "active" ||
                      product.status == 1.toString()) &&
                  product.rates != null &&
                  product.rates!.isNotEmpty &&
                  product.rates!.any((rate) => rate.status == 'active'),
            ),
          ); // Filter active products with active rates
          print("All data loaded from DataService");
          return;
        }
      } catch (e) {
        print("Error accessing DataService: $e");
      }

      // Method 1: Try to get the splash controller directly
      try {
        final splashController = Get.find<SplashController>(
          tag: "splash_controller",
        );

        // Create deep copies of lists to avoid reference issues
        if (splashController.promoList.value.isNotEmpty) {
          promoList.value = List<PromoModel>.from(
            splashController.promoList.value,
          );
          print(
            "Promos loaded from splash controller: ${promoList.value.length}",
          );
        }

        if (splashController.blogList.value.isNotEmpty) {
          blogList.value = List<BlogModel>.from(
            splashController.blogList.value,
          );
          print(
            "Blogs loaded from splash controller: ${blogList.value.length}",
          );
        }

        if (splashController.transactionList.value.isNotEmpty) {
          transactionList.value = List<TransactionModel>.from(
            splashController.transactionList.value,
          );
          print(
            "Transactions loaded from splash controller: ${transactionList.value.length}",
          );
        }
        if (splashController.productList.value.isNotEmpty) {
          // Filter only active products with active rates
          productList.value = List<ProductModel>.from(
            splashController.productList.value.where(
              (p) =>
                  (p.status == "1" ||
                      p.status == "active" ||
                      p.status == 1.toString()) &&
                  p.rates != null &&
                  p.rates!.isNotEmpty &&
                  p.rates!.any((rate) => rate.status == 'active'),
            ),
          );
          print(
            "Products loaded from splash controller: ${productList.value.length}",
          );
        }

        // Update DataService as well for future use
        if (promoList.value.isNotEmpty &&
            blogList.value.isNotEmpty &&
            transactionList.value.isNotEmpty &&
            productList.value.isNotEmpty) {
          dataService?.setData(
            promos: promoList.value,
            blogs: blogList.value,
            transactions: transactionList.value,
            products: productList.value,
          );
        }
      } catch (e) {
        print("Method 1 failed: $e");
      }

      // Method 2: Try to get cached data from Get storage
      if (promoList.value.isEmpty) {
        try {
          final cachedPromos = Get.find<Rx<List<PromoModel>>>(
            tag: "cached_promos",
          );
          final cachedBlogs = Get.find<Rx<List<BlogModel>>>(
            tag: "cached_blogs",
          );
          final cachedTransactions = Get.find<Rx<List<TransactionModel>>>(
            tag: "cached_transactions",
          );
          final cachedProducts = Get.find<Rx<List<ProductModel>>>(
            tag: "cached_products",
          );

          if (cachedPromos.value.isNotEmpty) {
            promoList.value = List<PromoModel>.from(cachedPromos.value);
            print("Promos loaded from cached data: ${promoList.value.length}");
          }

          if (cachedBlogs.value.isNotEmpty) {
            blogList.value = List<BlogModel>.from(cachedBlogs.value);
            print("Blogs loaded from cached data: ${blogList.value.length}");
          }

          if (cachedTransactions.value.isNotEmpty) {
            transactionList.value = List<TransactionModel>.from(
              cachedTransactions.value,
            );
            print(
              "Transactions loaded from cached data: ${transactionList.value.length}",
            );
          }
          if (cachedProducts.value.isNotEmpty) {
            // Filter only active products with active rates
            productList.value = List<ProductModel>.from(
              cachedProducts.value.where(
                (p) =>
                    (p.status == "1" ||
                        p.status == "active" ||
                        p.status == 1.toString()) &&
                    p.rates != null &&
                    p.rates!.isNotEmpty &&
                    p.rates!.any((rate) => rate.status == 'active'),
              ),
            );
            print(
              "Products loaded from cached data: ${productList.value.length}",
            );
          }

          // Cache the data in DataService for future use
          if (promoList.value.isNotEmpty &&
              blogList.value.isNotEmpty &&
              transactionList.value.isNotEmpty &&
              productList.value.isNotEmpty) {
            dataService?.setData(
              promos: promoList.value,
              blogs: blogList.value,
              transactions: transactionList.value,
              products: productList.value,
            );
          }
        } catch (e) {
          print("Method 2 failed: $e");
        }
      }

      // Method 3: Fetch from repositories as fallback
      if (promoList.value.isEmpty ||
          blogList.value.isEmpty ||
          transactionList.value.isEmpty ||
          productList.value.isEmpty) {
        print("Fetching data from repositories...");
        fetchPromos();
        fetchBlogs();
        fetchTransactions();
        fetchProducts();

        // Cache the fetched data in DataService
        Future.delayed(Duration(seconds: 2), () {
          if (promoList.value.isNotEmpty &&
              blogList.value.isNotEmpty &&
              transactionList.value.isNotEmpty &&
              productList.value.isNotEmpty) {
            dataService?.setData(
              promos: promoList.value,
              blogs: blogList.value,
              transactions: transactionList.value,
              products: productList.value,
            );
          }
        });
      }
    } catch (e) {
      print("Error in getData: $e");
    }
  }

  // Load notifications
  Future<void> loadNotifications() async {
    try {
      isLoadingNotifications.value = true;
      notificationError.value = "";

      final ds = dataService;
      if (ds == null) {
        print("DataService not available for notifications");
        return;
      }

      final notifications = await ds.notificationRepository.getNotifications(
        page: notificationPage.value,
      );

      if (notificationPage.value == 1) {
        notificationList.value = notifications;
      } else {
        notificationList.value.addAll(notifications);
      }

      totalNotifications.value = notificationList.value.length;
      hasMoreNotifications.value = notifications.length >= 10;

      print(
        "Loaded ${notifications.length} notifications for page ${notificationPage.value}",
      );
    } catch (e) {
      notificationError.value = "Failed to load notifications: $e";
      print("Error loading notifications: $e");
    } finally {
      isLoadingNotifications.value = false;
    }
  }

  // Refresh all data from API
  Future<void> refreshAll() async {
    try {
      isLoading.value = true;
      print("Refreshing all data...");

      final ds = dataService;
      if (ds != null) {
        await ds.refreshAllData();

        if (ds.promoList.value.isNotEmpty) {
          promoList.value = List<PromoModel>.from(ds.promoList.value);
        }
        if (ds.blogList.value.isNotEmpty) {
          blogList.value = List<BlogModel>.from(ds.blogList.value);
        }
        if (ds.transactionList.value.isNotEmpty) {
          transactionList.value = List<TransactionModel>.from(
            ds.transactionList.value,
          );
        }
        if (ds.productList.value.isNotEmpty) {
          // Filter only active products with active rates
          List<ProductModel> activeProducts = ds.productList.value
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
          productList.value = activeProducts;
        }
      } else {
        // Fallback to individual fetches
        await Future.wait([
          fetchPromos(),
          fetchBlogs(),
          fetchTransactions(),
          fetchProducts(),
        ]);
      }

      print("All data refreshed successfully");
      refreshController.refreshCompleted();
    } catch (e) {
      print("Error refreshing data: $e");
      refreshController.refreshFailed();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPromos() async {
    try {
      var data = await promoRepository.getAllPromos();
      if (data.isNotEmpty) {
        promoList.value = data;
        print("Fetched ${data.length} promos");
        // Store fetched data in dataService
        dataService?.setData(promos: data);
      }
    } catch (e) {
      print("Error fetching promos: $e");
    }
  }

  Future<void> fetchBlogs() async {
    try {
      var data = await blogRepository.getAllBlogs();
      if (data.isNotEmpty) {
        blogList.value = data;
        print("Fetched ${data.length} blogs");
        // Store fetched data in dataService
        dataService?.setData(blogs: data);
      }
    } catch (e) {
      print("Error fetching blogs: $e");
    }
  }

  Future<void> fetchTransactions() async {
    try {
      var data = await transactionRepository.getAllTransactions();
      if (data.isNotEmpty) {
        transactionList.value = data;
        print("Fetched ${data.length} transactions");
        // Store fetched data in dataService
        dataService?.setData(transactions: data);
      }
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  Future<void> fetchProducts() async {
    try {
      var data = await productRepository.getAllProducts();
      if (data.isNotEmpty) {
        // Filter only active products with active rates
        List<ProductModel> activeProducts = data
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

        if (activeProducts.isNotEmpty) {
          productList.value = activeProducts;
          print("Fetched ${activeProducts.length} active products");
          // Store fetched data in dataService
          dataService?.setData(products: activeProducts);
        }
      }
    } catch (e) {
      print("Error fetching products: $e");
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

    // Ensure DataService is available before proceeding
    _initializeDataService().then((_) {
      getData();
      loadUserData().then((_) {
        // Small delay to ensure shimmer is visible even on fast loads
        Future.delayed(Duration(milliseconds: 300), () {
          isLoading.value = false;
        });
      });
    });
  }

  // Helper method to ensure DataService is properly initialized
  Future<void> _initializeDataService() async {
    if (Get.isRegistered<DataService>()) {
      try {
        // Try to get DataService, if not available, wait and retry
        if (_dataService == null) {
          for (int i = 0; i < 5; i++) {
            try {
              _dataService = Get.find<DataService>();
              print("DataService found on attempt ${i + 1}");
              break;
            } catch (e) {
              print(
                "DataService not available on attempt ${i + 1}, waiting...",
              );
              if (i < 4) {
                await Future.delayed(Duration(milliseconds: 100 * (i + 1)));
              }
            }
          }
        }
      } catch (e) {
        print("Failed to initialize DataService: $e");
      }
    } else {
      print("DataService not registered yet");
    }
  }

  @override
  void onClose() {
    try {
      // Safely dispose refresh controllers
      _refreshController?.dispose();
      _refreshController = null;

      _moreRefreshController?.dispose();
      _moreRefreshController = null;

      _notificationRefreshController?.dispose();
      _notificationRefreshController = null;

      // Clear data service reference
      _dataService = null;

      print("HomeController disposed successfully");
    } catch (e) {
      print("Error disposing HomeController: $e");
    } finally {
      super.onClose();
    }
  }

  // Method for pull-to-refresh
  Future<void> onRefresh() async {
    print("DEBUG - Pull to refresh triggered!");
    try {
      await refreshAll();
      print("DEBUG - Refresh completed successfully");
      if (!isClosed && _refreshController != null) {
        refreshController.refreshCompleted();
      }
    } catch (error) {
      print("DEBUG - Refresh failed: $error");
      if (!isClosed && _refreshController != null) {
        refreshController.refreshFailed();
      }
    }
  }

  // Method for pull-to-refresh in more view
  Future<void> onMoreRefresh() async {
    if (!isClosed) {
      print("DEBUG - More view pull to refresh triggered!");
      try {
        await refreshAll();
        print("DEBUG - More view refresh completed successfully");
        if (!isClosed && _moreRefreshController != null) {
          moreRefreshController.refreshCompleted();
        }
      } catch (error) {
        print("DEBUG - More view refresh failed: $error");
        if (!isClosed && _moreRefreshController != null) {
          moreRefreshController.refreshFailed();
        }
      }
    }
  }

  // Notification methods
  Future<void> onNotificationRefresh() async {
    if (!isClosed) {
      try {
        notificationPage.value = 1;
        await loadNotifications();
        if (!isClosed && _notificationRefreshController != null) {
          notificationRefreshController.refreshCompleted();
        }
      } catch (e) {
        print("Error refreshing notifications: $e");
        if (!isClosed && _notificationRefreshController != null) {
          notificationRefreshController.refreshFailed();
        }
      }
    }
  }

  Future<void> loadMoreNotifications() async {
    if (!isClosed) {
      try {
        if (!hasMoreNotifications.value) {
          if (!isClosed && _notificationRefreshController != null) {
            notificationRefreshController.loadComplete();
          }
          return;
        }

        notificationPage.value++;
        await loadNotifications();

        if (!isClosed && _notificationRefreshController != null) {
          if (hasMoreNotifications.value) {
            notificationRefreshController.loadComplete();
          } else {
            notificationRefreshController.loadNoData();
          }
        }
      } catch (e) {
        print("Error loading more notifications: $e");
        if (!isClosed && _notificationRefreshController != null) {
          notificationRefreshController.loadFailed();
        }
      }
    }
  }

  // Notification filtering and sorting
  final RxString notificationTitleFilter = ''.obs;
  final RxString notificationType = ''.obs;
  final RxString notificationSortField = 'created_at'.obs;
  final RxString notificationSortOrder = 'DESC'.obs;

  // Apply notification filters and reload
  void applyNotificationFilters({
    String? titleFilter,
    String? typeFilter,
    String? sortField,
    String? sortOrder,
  }) {
    bool changed = false;

    if (titleFilter != null && titleFilter != notificationTitleFilter.value) {
      notificationTitleFilter.value = titleFilter;
      changed = true;
    }

    if (typeFilter != null && typeFilter != notificationType.value) {
      notificationType.value = typeFilter;
      changed = true;
    }

    if (sortField != null && sortField != notificationSortField.value) {
      notificationSortField.value = sortField;
      changed = true;
    }

    if (sortOrder != null && sortOrder != notificationSortOrder.value) {
      notificationSortOrder.value = sortOrder;
      changed = true;
    }

    if (changed) {
      loadNotifications();
    }
  }

  // Clear all notification filters
  void clearNotificationFilters() {
    notificationTitleFilter.value = '';
    notificationType.value = '';
    notificationSortField.value = 'created_at';
    notificationSortOrder.value = 'DESC';
    loadNotifications();
  }
}
