import 'package:get/get.dart';
import 'package:exachanger_get_app/app/modules/server_error/views/server_error_page_clean.dart';
import 'package:exachanger_get_app/app/modules/server_error/controllers/server_error_controller.dart';

/// Routes for server error module
class ServerErrorRoutes {
  static const String serverError = '/server-error';
}

/// Pages for server error module
class ServerErrorPages {
  static List<GetPage> pages = [
    GetPage(
      name: ServerErrorRoutes.serverError,
      page: () => const ServerErrorPage(),
      binding: ServerErrorBinding(),
    ),
  ];
}

/// Binding for server error module
class ServerErrorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServerErrorController>(() => ServerErrorController());
  }
}
