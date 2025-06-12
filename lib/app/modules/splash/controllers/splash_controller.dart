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
import 'package:exachanger_get_app/app/services/auth_service.dart';
import 'package:exachanger_get_app/app/services/data_service.dart';
import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class SplashController extends BaseController {
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

  // Use lazy initialization for critical dependencies that might be missing after error flows
  AuthRemoteDataSource? _authRemoteDataSource;
  AuthRemoteDataSource get authRemoteDataSource {
    if (_authRemoteDataSource == null) {
      try {
        _authRemoteDataSource = Get.find(
          tag: (AuthRemoteDataSource).toString(),
        );
      } catch (e) {
        print(
          '🔧 SPLASH: AuthRemoteDataSource not found, this should have been handled by SplashBinding: $e',
        );
        throw Exception(
          'Critical dependency AuthRemoteDataSource is missing. Please restart the app.',
        );
      }
    }
    return _authRemoteDataSource!;
  }

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
    try {
      // Check multiple authentication indicators for robustness
      bool isSignedInFlag = await preferenceManager.getBool("is_signed_in");
      String accessToken = await preferenceManager.getString("access_token");
      String refreshToken = await preferenceManager.getString("refresh_token");

      // If any critical auth data is missing, user is not signed in
      if (!isSignedInFlag || accessToken.isEmpty || refreshToken.isEmpty) {
        print("Authentication data missing or invalid:");
        print("- isSignedIn flag: $isSignedInFlag");
        print("- hasAccessToken: ${accessToken.isNotEmpty}");
        print("- hasRefreshToken: ${refreshToken.isNotEmpty}");
        return false;
      }

      // Check if we have user data
      final userData = await preferenceManager.getUserData();
      if (userData == null) {
        print("User data not found, considering user as not signed in");
        return false;
      }

      print(
        "User appears to be signed in: ${userData.name} (${userData.email})",
      );
      return true;
    } catch (e) {
      print("Error checking sign-in status: $e");
      return false;
    }
  }

  // Verify token validity and refresh if needed
  Future<bool> verifyAndRefreshToken() async {
    try {
      statusText.value = "Verifying authentication...";
      // Get current token
      String token = await preferenceManager.getString("access_token");
      String refreshToken = await preferenceManager.getString("refresh_token");

      if (token.isEmpty || refreshToken.isEmpty) {
        print("Missing tokens, authentication verification failed");
        await preferenceManager.logout();
        return false;
      }

      // Set current token
      DioProvider.setAuthToken(token);

      // Try to get some data to verify token validity
      try {
        statusText.value = "Authenticating...";
        // Make a simple request to verify token
        await transactionRepository.getAllTransactions();
        print("Token verification successful");
        return true; // Token is valid
      } catch (e) {
        print("Token verification failed: $e");
        // Check if unauthorized exception
        if (e is UnauthorizedException) {
          try {
            statusText.value = "Refreshing token...";
            print("Attempting token refresh...");
            // Try to refresh token
            final newAccessToken = await authRemoteDataSource.refreshToken(
              refreshToken,
            );

            // Store new token
            await preferenceManager.setString("access_token", newAccessToken);

            // Update Authorization header
            DioProvider.setAuthToken(newAccessToken);

            print("Token refresh successful");
            return true; // Token refreshed successfully
          } catch (refreshError) {
            print("Token refresh failed: $refreshError");
            // Refresh token also failed, logout
            await preferenceManager.logout();
            return false;
          }
        }
        // Other error, not token related - could be network issues
        // Don't logout immediately for network errors
        if (e.toString().contains('network') ||
            e.toString().contains('connection') ||
            e.toString().contains('timeout')) {
          print(
            "Network error during token verification, but keeping user signed in",
          );
          return true; // Keep user signed in for network errors
        }

        // For other errors, logout
        await preferenceManager.logout();
        return false;
      }
    } catch (e) {
      print("General error during token verification: $e");
      // General error - don't logout for temporary issues
      return true; // Keep user signed in
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
      "User data: ${userData.value != null ? 'Loaded (${userData.value!.name})' : 'Not loaded'}",
    );
  }

  // Add method to wait for AuthService to be fully initialized
  Future<void> _waitForAuthServiceInitialization() async {
    try {
      // Wait for AuthService to be available and initialized
      int attempts = 0;
      const maxAttempts = 50; // 5 seconds max wait

      while (attempts < maxAttempts) {
        try {
          Get.find<AuthService>();
          // Service is available, give it a moment to complete initialization
          await Future.delayed(Duration(milliseconds: 100));
          print("SplashController: AuthService is available and initialized");
          return;
        } catch (e) {
          // Service not ready yet, wait and try again
          attempts++;
          await Future.delayed(Duration(milliseconds: 100));
          if (attempts % 10 == 0) {
            print(
              "SplashController: Waiting for AuthService initialization... (attempt $attempts)",
            );
          }
        }
      }

      print("SplashController: WARNING - AuthService initialization timeout");
    } catch (e) {
      print("SplashController: Error waiting for AuthService: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();

    print("SplashController: Initializing...");

    // Small delay to ensure all services are initialized
    Future.delayed(Duration(milliseconds: 200), () async {
      try {
        // Wait for AuthService initialization
        await _waitForAuthServiceInitialization();

        print("SplashController: Starting authentication validation");

        // Get AuthService instance for centralized auth state management
        final AuthService authService = Get.find<AuthService>();

        // Use AuthService to validate and repair authentication state
        bool isAuthValid = await authService.validateAndRepairAuthState();

        print("SplashController: AuthService validation result: $isAuthValid");
        print(
          "SplashController: AuthService authenticated state: ${authService.isAuthenticated.value}",
        );
        print(
          "SplashController: AuthService user email: ${authService.currentUserEmail.value}",
        );

        if (isAuthValid && authService.isAuthenticated.value) {
          print("SplashController: User is authenticated, loading app data");

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

          print("SplashController: Navigating to main screen");
          // Navigate to main screen
          Get.offNamed(Routes.MAIN);
        } else {
          print(
            "SplashController: User not authenticated, showing welcome screen",
          );
          _showWelcomeScreen();
        }
      } catch (e) {
        print("SplashController: Error during authentication validation: $e");
        _showWelcomeScreen();
      }
    });
  }

  // Helper method to show welcome screen
  void _showWelcomeScreen() {
    var metadataController = Get.find<WelcomeController>();
    metadataController.getWelcomeInfo();

    ever(metadataController.metaData, (metadata) {
      if (metadata != null) {
        Get.offNamed(Routes.WELCOME);
      }
    });
  }
}
