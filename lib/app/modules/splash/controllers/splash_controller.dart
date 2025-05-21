import 'package:exachanger_get_app/app/data/local/preference/preference_manager_impl.dart';
import 'package:exachanger_get_app/app/data/models/blog_model.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:exachanger_get_app/app/data/models/promo_model.dart';
import 'package:exachanger_get_app/app/data/models/transaction_model.dart';
import 'package:exachanger_get_app/app/data/models/user_model.dart';
import 'package:exachanger_get_app/app/data/remote/auth/auth_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/repository/blog/blog_repository.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:exachanger_get_app/app/data/repository/promo/promo_repository.dart';
import 'package:exachanger_get_app/app/data/repository/transaction/transaction_repository.dart';
import 'package:exachanger_get_app/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:exachanger_get_app/app/network/dio_provider.dart';
import 'package:exachanger_get_app/app/network/exceptions/unauthorize_exception.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class SplashController extends BaseController {
  final PromoRepository promoRepository =
      Get.find(tag: (PromoRepository).toString());

  final BlogRepository blogRepository =
      Get.find(tag: (BlogRepository).toString());

  final TransactionRepository transactionRepository =
      Get.find(tag: (TransactionRepository).toString());

  final ProductRepository productRepository =
      Get.find(tag: (ProductRepository).toString());

  final AuthRemoteDataSource authRemoteDataSource =
      Get.find(tag: (AuthRemoteDataSource).toString());
  final PreferenceManagerImpl preferenceManager =
      Get.find<PreferenceManagerImpl>();

  // DataService for sharing data between controllers - with safe access
  DataService? _dataService;

  // Getter with lazy initialization for DataService
  DataService get dataService {
    if (_dataService == null) {
      try {
        _dataService = Get.find<DataService>();
      } catch (e) {
        print("DataService not available in SplashController: $e");
        // Try to register it if not found
        try {
          _dataService = DataService();
          Get.put<DataService>(_dataService!, permanent: true);
          _dataService!.init();
        } catch (e) {
          print("Could not register DataService: $e");
        }
      }
    }
    return _dataService!;
  }

  // Status text that will be shown on splash screen
  RxString statusText = "Loading...".obs;

  // Data containers
  Rx<List<PromoModel>> promoList = Rx<List<PromoModel>>([]);
  Rx<List<BlogModel>> blogList = Rx<List<BlogModel>>([]);
  Rx<List<TransactionModel>> transactionList = Rx<List<TransactionModel>>([]);
  Rx<List<ProductModel>> productList = Rx<List<ProductModel>>([]);

  // User data container
  Rx<UserModel?> userData = Rx<UserModel?>(null);

  // check if signed in
  Future<bool> isSignedIn() async {
    bool isSignedIn = await preferenceManager.getBool("is_signed_in");
    return isSignedIn;
  }

  // Verify token validity and refresh if needed
  Future<bool> verifyAndRefreshToken() async {
    try {
      statusText.value = "Verifying authentication...";
      // Get current token
      String token = await preferenceManager.getString("access_token");
      String refreshToken = await preferenceManager.getString("refresh_token");

      // Set current token
      DioProvider.setAuthToken(token);

      // Try to get some data to verify token validity
      try {
        statusText.value = "Authenticating...";
        // Make a simple request to verify token
        await transactionRepository.getAllTransactions();
        return true; // Token is valid
      } catch (e) {
        // Check if unauthorized exception
        if (e is UnauthorizedException) {
          try {
            statusText.value = "Refreshing token...";
            // Try to refresh token
            final newAccessToken =
                await authRemoteDataSource.refreshToken(refreshToken);

            // Store new token
            await preferenceManager.setString("access_token", newAccessToken);

            // Update Authorization header
            DioProvider.setAuthToken(newAccessToken);

            return true; // Token refreshed successfully
          } catch (refreshError) {
            // Refresh token also failed, logout
            await preferenceManager.logout();
            return false;
          }
        }
        // Other error, not token related
        return false;
      }
    } catch (e) {
      // General error
      await preferenceManager.logout();
      return false;
    }
  }

  // Fetch all data needed for the app
  Future<void> fetchAppData() async {
    try {
      // Get promos
      statusText.value = "Loading promotions...";
      await callDataService(
        promoRepository.getAllPromos(),
        onSuccess: (data) {
          promoList.value = data;
        },
        onError: (error) {
          showErrorMessage(error.toString());
        },
        onStart: () {
          // Don't show loading overlay, just update status text
        },
      );

      // Get blogs
      statusText.value = "Loading news...";
      await callDataService(
        blogRepository.getAllBlogs(),
        onSuccess: (data) {
          blogList.value = data;
        },
        onError: (error) {
          showErrorMessage(error.toString());
        },
        onStart: () {
          // Don't show loading overlay, just update status text
        },
      );

      // Get transactions
      statusText.value = "Loading transactions...";
      await callDataService(
        transactionRepository.getAllTransactions(),
        onSuccess: (data) {
          transactionList.value = data;
        },
        onError: (error) {
          showErrorMessage(error.toString());
        },
        onStart: () {
          // Don't show loading overlay, just update status text
        },
      );

      // Get products
      statusText.value = "Loading products...";
      await callDataService(
        productRepository.getAllProducts(),
        onSuccess: (data) {
          productList.value = data;
        },
        onError: (error) {
          showErrorMessage(error.toString());
        },
        onStart: () {
          // Don't show loading overlay, just update status text
        },
      );

      // Update DataService with the fetched data
      try {
        dataService.setData(
          promos: promoList.value,
          blogs: blogList.value,
          transactions: transactionList.value,
          products: productList.value,
        );
        print("DataService updated with preloaded data");
      } catch (e) {
        print("Error updating DataService: $e");
      }
      ;

      statusText.value = "Ready!";
    } catch (e) {
      showErrorMessage("Error loading data: ${e.toString()}");
    }
  } // Load user data from preferences

  Future<void> loadUserData() async {
    try {
      statusText.value = "Loading user data...";
      // Try to use the preferenceManager's getUserData method for better encapsulation
      final user = await preferenceManager.getUserData();

      if (user != null) {
        userData.value = user;
        print("User data loaded: ${userData.value?.name}");

        // First remove any existing registrations to prevent duplicates
        if (Get.isRegistered<UserModel>(tag: "current_user")) {
          Get.delete<UserModel>(tag: "current_user");
        }
        if (Get.isRegistered<Rx<UserModel?>>(tag: "user_data")) {
          Get.delete<Rx<UserModel?>>(tag: "user_data");
        }

        // Make user data available across the app
        // Use a constant tag for easier access - register the actual UserModel
        Get.put<UserModel>(user, tag: "current_user", permanent: true);
        // Also put the Rx wrapper for reactive updates
        Get.put<Rx<UserModel?>>(userData, tag: "user_data", permanent: true);

        print("User data registered with GetX: ${user.name}");
      } else {
        print("No user data found or it's invalid");
      }
    } catch (e) {
      print('Error loading user data in SplashController: $e');
    }
  }

  // Add debug information
  void printDataStatus() {
    print("SplashController data status:");
    print("Promos count: ${promoList.value.length}");
    print("Blogs count: ${blogList.value.length}");
    print("Transactions count: ${transactionList.value.length}");
    print("Products count: ${productList.value.length}");
    print(
        "User data: ${userData.value != null ? 'Loaded (${userData.value!.name})' : 'Not loaded'}");
  }

  @override
  void onInit() {
    super.onInit();

    // check if signed in
    isSignedIn().then((isSignedIn) async {
      if (isSignedIn) {
        // Verify token and refresh if needed
        bool isTokenValid = await verifyAndRefreshToken();

        if (isTokenValid) {
          // Load user data first
          await loadUserData();

          // Fetch app data
          await fetchAppData();

          // Print data status for debugging
          printDataStatus();

          // Put data in Get storage for easy access across app
          Get.put(promoList, tag: "cached_promos", permanent: true);
          Get.put(blogList, tag: "cached_blogs", permanent: true);
          Get.put(transactionList, tag: "cached_transactions", permanent: true);
          Get.put(productList, tag: "cached_products", permanent: true);

          // Navigate to main screen
          Get.offNamed(Routes.MAIN);
        } else {
          // Token refresh failed, go to welcome screen
          var metadataController = Get.find<WelcomeController>();
          metadataController.getWelcomeInfo();

          ever(metadataController.metaData, (metadata) {
            if (metadata != null) {
              Get.offNamed(Routes.WELCOME);
            }
          });
        }
      } else {
        // Not signed in, get metadata for welcome screen
        var metadataController = Get.find<WelcomeController>();
        metadataController.getWelcomeInfo();

        // Simplified ever listener
        ever(metadataController.metaData, (metadata) {
          if (metadata != null) {
            Get.offNamed(Routes.WELCOME);
          }
        });
      }
    });
  }
}
