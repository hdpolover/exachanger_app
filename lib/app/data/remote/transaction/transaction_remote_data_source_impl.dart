import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/base/base_remote_source.dart';
import '../../../core/values/app_endpoints.dart';
import '../../models/transaction_model.dart';
import 'transaction_remote_data_source.dart';

class TransactionRemoteDataSourceImpl extends BaseRemoteSource
    implements TransactionRemoteDataSource {
  @override
  Future<List<TransactionModel>> getAll() async {
    try {
      final dioCall = dioClient.get(AppEndpoints.transactionHistory);
      return callApiWithErrorParser(dioCall).then((response) {
        if (response.data != null) {
          // Handle different response structures
          dynamic data = response.data;

          // Check if the response has the standard API structure
          if (data is Map<String, dynamic>) {
            // If it's a map, check for nested data structure
            if (data.containsKey('data')) {
              var nestedData = data['data'];
              // Check if it's paginated response with data.data structure
              if (nestedData is Map<String, dynamic> &&
                  nestedData.containsKey('data')) {
                data = nestedData['data'];
              } else {
                data = nestedData;
              }
            }
          }

          // Ensure data is a List
          if (data is List) {
            return data
                .map(
                  (e) => TransactionModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          } else {
            print(
              "ERROR: Expected List for transactions but got ${data.runtimeType}: $data",
            );
            return [];
          }
        }
        return [];
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TransactionModel> getById(String id) async {
    try {
      final dioCall = dioClient.get('${AppEndpoints.transactions}/$id');
      return callApiWithErrorParser(dioCall).then((response) {
        if (response.data != null) {
          return TransactionModel.fromJson(response.data);
        }
        throw Exception('Transaction not found');
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
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
  }) async {
    try {
      final data = {
        'rate_id': rateId,
        'amount': amount,
        'total': total,
        'user_account_transfer': userAccountTransfer,
        if (referralCode != null) 'referral_code': referralCode,
        if (discountCode != null) 'discount_code': discountCode,
        if (blockchainId != null) 'blockchain_id': blockchainId,
        if (blockchainAddress != null) 'blockchain_address': blockchainAddress,
        if (note != null) 'note': note,
      };

      final dioCall = dioClient.post(AppEndpoints.transactions, data: data);
      return callApiWithErrorParser(dioCall).then((response) {
        if (response.data != null) {
          return TransactionModel.fromJson(response.data);
        }
        throw Exception('Failed to create transaction');
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteTransaction(String transactionId) async {
    try {
      final dioCall = dioClient.post('/transaction/delete/$transactionId');
      return callApiWithErrorParser(dioCall).then((response) {
        return response.statusCode == 200;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> uploadPaymentProof({
    required String transactionId,
    required File proofFile,
  }) async {
    try {
      // Create form data with file and transaction ID
      FormData formData = FormData.fromMap({
        'transaction_id': transactionId,
        'file': await MultipartFile.fromFile(
          proofFile.path,
          filename:
              'payment_proof_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      });

      final dioCall = dioClient.post(
        '/transaction/payment-proof',
        data: formData,
      );

      return callApiWithErrorParser(dioCall).then((response) {
        return response.statusCode == 200;
      });
    } catch (e) {
      rethrow;
    }
  }
}
