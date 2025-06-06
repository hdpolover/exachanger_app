import 'package:get/get.dart';
import 'package:exachanger_get_app/app/data/remote/transaction/transaction_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/remote/transaction/transaction_remote_data_source_impl.dart';

import '../controllers/exchange_controller.dart';

class ExchangeBinding extends Bindings {
  @override
  void dependencies() {
    // Register TransactionRemoteDataSourceImpl as a permanent singleton
    Get.put<TransactionRemoteDataSource>(
      TransactionRemoteDataSourceImpl(),
      permanent: true,
    );

    // Register ExchangeController with lazyPut to allow fresh instances
    Get.lazyPut<ExchangeController>(() => ExchangeController());
  }
}
