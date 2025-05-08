import '../../model/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getAllTransactions();

  Future<TransactionModel> getTransactionById(String id);
}
