import 'dart:convert';

import 'package:exachanger_get_app/app/core/base/base_controller.dart';
import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:exachanger_get_app/app/data/models/user_model.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
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

  // User data
  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();
  final Rx<UserModel?> userData = Rx<UserModel?>(null);

  // Load user data
  Future<void> loadUserData() async {
    try {
      final userDataJson = await preferenceManager.getString('user_data');
      if (userDataJson.isNotEmpty) {
        final userMap = jsonDecode(userDataJson);
        userData.value = UserModel.fromJson(userMap);
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

        // Update DataService as well for future use
        if (promoList.value.isNotEmpty &&
            blogList.value.isNotEmpty &&
            transactionList.value.isNotEmpty) {
          dataService.setData(
              promos: promoList.value,
              blogs: blogList.value,
              transactions: transactionList.value);
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

          // Update DataService as well for future use
          if (promoList.value.isNotEmpty &&
              blogList.value.isNotEmpty &&
              transactionList.value.isNotEmpty) {
            dataService.setData(
                promos: promoList.value,
                blogs: blogList.value,
                transactions: transactionList.value);
          }
        } catch (e) {
          print("Method 2 failed: $e");
        }
      }

      // If we successfully got data from either method, return early
      if (promoList.value.isNotEmpty &&
          blogList.value.isNotEmpty &&
          transactionList.value.isNotEmpty) {
        print("All data loaded from cache");
        return;
      }
    } catch (e) {
      print("Error getting cached data: $e");
      // Continue to fetch data if cached data isn't found
    }

    // If we got here, we need to fetch the data
    print("Fetching fresh data in HomeController");

    // Fetch promos
    var promoService = promoRepository.getAllPromos();
    callDataService(promoService, onSuccess: (data) {
      promoList.value = data;
      print("Promos fetched in HomeController: ${data.length}");
    }, onError: (error) {
      showErrorMessage(error.toString());
    });

    // Fetch blogs
    var blogService = blogRepository.getAllBlogs();
    callDataService(blogService, onSuccess: (data) {
      blogList.value = data;
      print("Blogs fetched in HomeController: ${data.length}");
    }, onError: (error) {
      showErrorMessage(error.toString());
    });

    // Fetch transactions
    var transactionService = transactionRepository.getAllTransactions();
    callDataService(transactionService, onSuccess: (data) {
      transactionList.value = data;
      print("Transactions fetched in HomeController: ${data.length}");

      // Update DataService with newly fetched data
      dataService.setData(
          promos: promoList.value,
          blogs: blogList.value,
          transactions: transactionList.value);
    }, onError: (error) {
      showErrorMessage(error.toString());
    });
  }

  // Refresh data from API (for pull-to-refresh functionality)
  Future<void> refreshData() async {
    try {
      // Make sure we have access to the DataService
      if (_dataService != null) {
        // Use DataService to refresh all data at once
        await dataService.refreshAllData();

        // Update our local lists from the refreshed data in DataService
        promoList.value = List<PromoModel>.from(dataService.promoList.value);
        blogList.value = List<BlogModel>.from(dataService.blogList.value);
        transactionList.value =
            List<TransactionModel>.from(dataService.transactionList.value);

        print("All data refreshed through DataService");
        return;
      } else {
        print("DataService not available, using fallback");
      }
    } catch (e) {
      print(
          "DataService refresh failed, falling back to individual API calls: $e");

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
        },
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    getData();
    loadUserData();
  }
}
