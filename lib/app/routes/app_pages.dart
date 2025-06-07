import 'package:exachanger_get_app/app/modules/blog/views/blog_detail_view.dart';

import '../modules/exchange/views/proceed_exchange_view.dart';
import '../modules/exchange/views/confirm_exchange_view.dart';
import '../modules/home/views/home_more_view.dart';
import '../modules/home/views/notification_view.dart';
import 'package:get/get.dart';

// import '../middlewares/blog_middleware.dart'; // Temporarily disabled
import '../modules/blog/bindings/blog_binding.dart';
import '../modules/blog/views/blog_view.dart';
import '../modules/exchange/bindings/exchange_binding.dart';
import '../modules/exchange/views/exchange_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/pages/profile_view.dart';
import '../modules/promo/bindings/promo_binding.dart';
import '../modules/promo/views/promo_view.dart';
import '../modules/server_error/views/server_error_page_clean.dart';
import '../modules/server_error/controllers/server_error_controller.dart';

import '../modules/rate/bindings/rate_binding.dart';
import '../modules/rate/views/rate_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/transaction_detail/bindings/transaction_detail_binding.dart';
import '../modules/transaction_detail/views/transaction_detail_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(name: _Paths.MAIN, page: () => MainView(), binding: MainBinding()),
    GetPage(
      name: _Paths.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(name: _Paths.BLOG, page: () => BlogView(), binding: BlogBinding()),
    GetPage(
      name: _Paths.BLOG_DETAIL,
      page: () => BlogDetailView(),
      binding: BlogBinding(),
    ),
    GetPage(name: _Paths.RATE, page: () => RateView(), binding: RateBinding()),
    GetPage(
      name: _Paths.EXCHANGE,
      page: () => ExchangeView(),
      binding: ExchangeBinding(),
    ),
    GetPage(
      name: _Paths.PROCEED_EXCHANGE,
      page: () => ProceedExchangeView(),
      binding: ExchangeBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_DETAIL,
      page: () => TransactionDetailView(),
      binding: TransactionDetailBinding(),
    ),
    GetPage(
      name: _Paths.PROMO,
      page: () => PromoView(),
      binding: PromoBinding(),
    ),
    GetPage(
      name: _Paths.CONFIRM_EXCHANGE,
      page: () => ConfirmExchangeView(),
      binding: ExchangeBinding(),
    ),
    GetPage(
      name: _Paths.HOME_MORE,
      page: () => HomeMoreView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SERVER_ERROR,
      page: () => const ServerErrorPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ServerErrorController>(() => ServerErrorController());
      }),
    ),
  ];
}
