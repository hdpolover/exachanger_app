import '../../model/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getAll();

  Future<TransactionModel> getById(String id);
}
