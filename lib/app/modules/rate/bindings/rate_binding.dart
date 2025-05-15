import 'package:exachanger_get_app/app/data/remote/product/product_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/remote/product/product_remote_data_source_impl.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository.dart';
import 'package:exachanger_get_app/app/data/repository/product/product_repository_impl.dart';
import 'package:get/get.dart';

import '../controllers/rate_controller.dart';

class RateBinding extends Bindings {
  @override
  void dependencies() {
    // Register dependencies
    Get.lazyPut<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(),
      tag: (ProductRemoteDataSource).toString(),
    );

    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(),
      tag: (ProductRepository).toString(),
    );

    Get.lazyPut<RateController>(
      () => RateController(),
    );
  }
}
