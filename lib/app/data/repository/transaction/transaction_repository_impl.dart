import 'package:exachanger_get_app/app/data/models/transaction_model.dart';
import 'package:exachanger_get_app/app/data/remote/transaction/transaction_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/repository/transaction/transaction_repository.dart';
import 'package:get/get.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteSource =
      Get.find(tag: (TransactionRemoteDataSource).toString());

  @override
  Future<List<TransactionModel>> getAllTransactions() {
    return _remoteSource.getAll();
  }

  @override
  Future<TransactionModel> getTransactionById(String id) {
    return _remoteSource.getById(id);
  }
}
