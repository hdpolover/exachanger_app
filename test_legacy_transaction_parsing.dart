import 'dart:convert';
import 'lib/app/data/models/transaction_model.dart';

void main() {
  // Test with legacy JSON structure for backward compatibility
  const String legacyJson = '''
  {
    "id": "776f0bd1-9902-468b-bdd6-7a1dd22d5ce6",
    "user_id": "8d69f872-21b7-473c-8579-9b47f8f50866",
    "referral_id": null,
    "promo_id": null,
    "trx_code": "EXA-0020250209891",
    "payment_proof": "https://storage.ngodingin.org/storage/file_67a8e151acf020.88941514.png",
    "discount": 0,
    "total": 429.5,
    "transfer_meta": {
        "name": "Bank Transfer",
        "type": "va",
        "value": "9587245042",
        "status": 1,
        "created_at": "3 Januari 2025 12:54:05",
        "updated_at": null
    },
    "status": 1,
    "note": null,
    "products": [],
    "created_at": "2025-02-09T23:46:05.000Z",
    "updated_at": "2025-02-10T00:09:39.000Z",
    "deleted_at": null
  }
  ''';

  try {
    // Parse the JSON
    final Map<String, dynamic> jsonData = json.decode(legacyJson);

    // Create TransactionModel from JSON
    final TransactionModel transaction = TransactionModel.fromJson(jsonData);

    print('=== Legacy Transaction Parsing Test ===');
    print('✅ Legacy JSON parsed successfully');
    print('Transaction ID: ${transaction.id}');
    print('Transaction Code: ${transaction.trxCode}');
    print('Total: ${transaction.total}');
    print('Status: ${transaction.status}');

    // Test legacy transfer_meta parsing
    if (transaction.transferMeta != null) {
      print('\\n=== Legacy Transfer Meta ===');
      print('Name: ${transaction.transferMeta!.name}');
      print('Type: ${transaction.transferMeta!.type}');
      print('Value: ${transaction.transferMeta!.value}');
      print('Status: ${transaction.transferMeta!.status}');
      print('Created At: ${transaction.transferMeta!.createdAt}');

      // New fields should be null for legacy data
      print('\\n=== New Fields (should be null) ===');
      print('Rate ID: ${transaction.transferMeta!.rateId}');
      print('Amount: ${transaction.transferMeta!.amount}');
      print('Blockchain ID: ${transaction.transferMeta!.blockchainId}');
      print('Wallet Address: ${transaction.transferMeta!.walletAddress}');
    }

    print('\\n✅ Legacy parsing completed successfully!');
    print('✅ Backward compatibility maintained!');
  } catch (e, stackTrace) {
    print('❌ Error parsing legacy transaction: $e');
    print('Stack trace: $stackTrace');
  }
}
