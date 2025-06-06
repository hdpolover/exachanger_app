import 'dart:convert';
import 'lib/app/data/models/transaction_model.dart';

void main() {
  // Test JSON from your provided example
  const String testJson = '''
  {
    "id": "73c13660-5673-4fab-97df-853f53c887b1",
    "user_id": "8d69f872-21b7-473c-8579-9b47f8f50866",
    "referral_id": null,
    "promo_id": null,
    "trx_code": "EXA-0020250606546",
    "payment_proof": null,
    "discount": 0,
    "total": 101,
    "transfer_meta": {
        "rate_id": "a11ab0ba-1e9b-4be5-9896-1fb9388409f6",
        "amount": "100.0",
        "total": "101.0",
        "blockchain_id": "175edada-7dce-4c3c-ad65-f658e0bd4db1",
        "wallet_address": "dsrrffgfeafe",
        "created_at": null
    },
    "status": 0,
    "note": null,
    "products": [
        {
            "id": "dcced035-bdf7-439d-86e3-3f65c9839740",
            "rate_id": "a11ab0ba-1e9b-4be5-9896-1fb9388409f6",
            "product_meta": {
                "from": {
                    "id": "d697afab-cd63-4548-a50e-a913954eea78",
                    "code": "USDC",
                    "order": 1,
                    "name": "USDC",
                    "image": "https://storage.ngodingin.org/storage/file_68137b7b1e58d7.88037574.jpg",
                    "status": "active",
                    "created_at": "05/02/2025 10:47:40",
                    "updated_at": "2025-05-26T03:07:54.000Z",
                    "price": {
                        "id": null,
                        "pricing_type": 0,
                        "pricing": 1,
                        "fee_type": 0,
                        "fee": 1,
                        "currency": "USD"
                    },
                    "blockchains": [
                        {
                            "id": "175edada-7dce-4c3c-ad65-f658e0bd4db1",
                            "code": "BTC",
                            "name": "BTC",
                            "image": "https://storage.ngodingin.org/storage/file_6814d435e652d5.75791385.png",
                            "fee_type": 0,
                            "fee": 20,
                            "status": "draft",
                            "created_at": "2025-05-03",
                            "updated_at": "2025-06-03"
                        }
                    ],
                    "transfer_data": {
                        "id": "413c5616-7043-4601-bc6d-717e1948b519",
                        "type": "address",
                        "value": "ADAxwwca342dawd",
                        "status": 1,
                        "created_at": "17/05/2025 01:37:01",
                        "updated_at": null
                    }
                },
                "to": {
                    "id": "a11ab0ba-1e9b-4be5-9896-1fb9388409f6",
                    "pricing_type": 0,
                    "pricing": 0.99,
                    "fee_type": 0,
                    "fee": 1,
                    "status": "active",
                    "currency": "id-ID",
                    "product": {
                        "id": "8261259b-9cc2-4efc-8d19-8e145a3b2c9a",
                        "code": "USDT",
                        "name": "USDT",
                        "image": "https://storage.ngodingin.org/storage/file_68137b345cce49.80443666.jpg",
                        "category": "blockchain"
                    },
                    "created_at": "06/06/2025 07:00:00"
                }
            },
            "amount": 100,
            "sub_total": 101,
            "blockchain": null
        }
    ],
    "created_at": "07/06/2025 02:27:07",
    "updated_at": null,
    "deleted_at": null
  }
  ''';

  try {
    // Parse the JSON
    final Map<String, dynamic> jsonData = json.decode(testJson);

    // Create TransactionModel from JSON
    final TransactionModel transaction = TransactionModel.fromJson(jsonData);

    print('=== Transaction Parsing Test ===');
    print('✅ JSON parsed successfully');
    print('Transaction ID: ${transaction.id}');
    print('Transaction Code: ${transaction.trxCode}');
    print('Total: ${transaction.total}');
    print('Status: ${transaction.status}');

    // Test transfer_meta parsing
    if (transaction.transferMeta != null) {
      print('\\n=== Transfer Meta ===');
      print('Rate ID: ${transaction.transferMeta!.rateId}');
      print('Amount: ${transaction.transferMeta!.amount}');
      print('Total: ${transaction.transferMeta!.total}');
      print('Blockchain ID: ${transaction.transferMeta!.blockchainId}');
      print('Wallet Address: ${transaction.transferMeta!.walletAddress}');
    }

    // Test products parsing
    if (transaction.products != null && transaction.products!.isNotEmpty) {
      print('\\n=== Products ===');
      final product = transaction.products!.first;
      print('Product ID: ${product.id}');
      print('Rate ID: ${product.rateId}');
      print('Amount: ${product.amount}');
      print('Sub Total: ${product.subTotal}');

      // Test product meta
      if (product.productMeta != null) {
        print('\\n=== Product Meta From ===');
        final from = product.productMeta!.from;
        if (from != null) {
          print('From ID: ${from.id}');
          print('From Code: ${from.code}');
          print('From Name: ${from.name}');
          print('From Status: ${from.status}');
          print('From Order: ${from.order}');

          if (from.blockchains != null && from.blockchains!.isNotEmpty) {
            print('\\n=== Blockchains ===');
            final blockchain = from.blockchains!.first;
            print('Blockchain ID: ${blockchain.id}');
            print('Blockchain Code: ${blockchain.code}');
            print('Blockchain Name: ${blockchain.name}');
            print('Blockchain Status: ${blockchain.status}');
            print('Blockchain Fee: ${blockchain.fee}');
          }
        }

        print('\\n=== Product Meta To ===');
        final to = product.productMeta!.to;
        if (to != null) {
          print('To ID: ${to.id}');
          print('To Pricing: ${to.pricing}');
          print('To Currency: ${to.currency}');
          print('To Status: ${to.status}');

          if (to.product != null) {
            print('\\n=== To Product ===');
            print('Product ID: ${to.product!.id}');
            print('Product Code: ${to.product!.code}');
            print('Product Name: ${to.product!.name}');
            print('Product Category: ${to.product!.category}');
          }
        }
      }
    }

    print('\\n✅ All parsing completed successfully!');
  } catch (e, stackTrace) {
    print('❌ Error parsing transaction: $e');
    print('Stack trace: $stackTrace');
  }
}
