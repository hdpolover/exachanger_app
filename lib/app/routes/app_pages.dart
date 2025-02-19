import 'package:get/get.dart';

import '../middlewares/blog_middleware.dart';
import '../modules/blog/bindings/blog_binding.dart';
import '../modules/blog/views/blog_view.dart';
import '../modules/blog_detail/bindings/blog_detail_binding.dart';
import '../modules/blog_detail/views/blog_detail_view.dart';
import '../modules/exchange/bindings/exchange_binding.dart';
import '../modules/exchange/views/exchange_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/rate/bindings/rate_binding.dart';
import '../modules/rate/views/rate_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
    ),
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
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.BLOG,
      page: () => BlogView(),
      binding: BlogBinding(),
    ),
    GetPage(
      name: _Paths.BLOG_DETAIL,
      page: () => BlogDetailView(),
      binding: BlogDetailBinding(),
      middlewares: [
        BlogMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.RATE,
      page: () => const RateView(),
      binding: RateBinding(),
    ),
    GetPage(
      name: _Paths.EXCHANGE,
      page: () => const ExchangeView(),
      binding: ExchangeBinding(),
    ),
  ];
}
