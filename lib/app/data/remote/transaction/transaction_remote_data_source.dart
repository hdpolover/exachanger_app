import 'dart:io';
import '../../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getAll();

  Future<TransactionModel> getById(String id);
  Future<TransactionModel> createTransaction({
    required String rateId,
    required double amount,
    required double total,
    String? referralCode,
    String? discountCode,
    String? blockchainId,
    String? blockchainAddress,
    String? note,
    required Map<String, String> userAccountTransfer,
  });

  Future<bool> deleteTransaction(String transactionId);

  Future<bool> uploadPaymentProof({
    required String transactionId,
    required File proofFile,
  });
}
