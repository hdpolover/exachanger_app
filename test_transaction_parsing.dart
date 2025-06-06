import 'dart:convert';
import 'lib/app/data/models/transaction_model.dart';

void main() {
  // Test data from your API response
  const String jsonResponse = '''
{
    "status": "Success",
    "code": 200,
    "data": {
        "data": [
            {
                "id": "19d2cb2d-4825-4a33-a058-8d384c2424b8",
                "user_id": "8d69f872-21b7-473c-8579-9b47f8f50866",
                "referral_id": null,
                "promo_id": null,
                "trx_code": "EXA-0020250508520",
                "payment_proof": null,
                "discount": 0,
                "total": 429.5,
                "transfer_meta": {
                    "name": "Mahendra Dwi Purwanto",
                    "type": "email",
                    "value": "mahendradwipurwanto@gmail.com",
                    "created_at": null
                },
                "status": 0,
                "note": null,
                "products": [
                    {
                        "id": "58c33628-35b9-42de-ac28-5afbb8ac3621",
                        "rate_id": "bc54dc70-eeb2-441c-b56a-dc9ef95ef0f0",
                        "product_meta": {
                            "from": {
                                "id": "2076df50-f661-4cad-9bf9-8526b44b6f95",
                                "code": "AT",
                                "name": "AirTM",
                                "image": "https://storage.ngodingin.org/storage/file_68137a8a1194a3.29408269.jpg",
                                "status": 1,
                                "created_at": "06/01/2025 03:43:39",
                                "updated_at": null,
                                "price": {
                                    "id": null,
                                    "pricing_type": 0,
                                    "pricing": 1,
                                    "fee_type": 0,
                                    "fee": 1,
                                    "currency": "USD"
                                },
                                "transfer_data": {
                                    "id": "b931bd2b-1448-448d-ab71-8395e3238c65",
                                    "type": "others",
                                    "value": "vebryexa@gmail.com",
                                    "status": 1,
                                    "created_at": "02/05/2025 21:21:20",
                                    "updated_at": null
                                }
                            },
                            "to": {
                                "id": "bc54dc70-eeb2-441c-b56a-dc9ef95ef0f0",
                                "pricing_type": 0,
                                "pricing": 0.9,
                                "fee_type": 0,
                                "fee": 0,
                                "status": "active",
                                "currency": "id-ID",
                                "product": {
                                    "id": "93555914-6a4a-4a9b-a227-61d75a2ee970",
                                    "code": "NTL",
                                    "name": "Neteller",
                                    "image": "https://storage.ngodingin.org/storage/file_68137b5b8e8539.78534885.jpg",
                                    "category": "e-money"
                                },
                                "created_at": "Invalid Date"
                            }
                        },
                        "amount": 29.5,
                        "sub_total": 429.5,
                        "blockchain": null
                    }
                ],
                "created_at": "09/05/2025 01:37:37",
                "updated_at": null,
                "deleted_at": null
            },
            {
                "id": "62db8c26-cbad-46aa-8753-59e0f4625356",
                "user_id": "8d69f872-21b7-473c-8579-9b47f8f50866",
                "referral_id": null,
                "promo_id": null,
                "trx_code": "EXA-0020250605478",
                "payment_proof": null,
                "discount": 0,
                "total": 2,
                "transfer_meta": {
                    "name": "Unknown User",
                    "type": "email",
                    "value": "unknown@user.com",
                    "created_at": null
                },
                "status": 0,
                "note": null,
                "products": [
                    {
                        "id": "f785fcb1-5daf-46d2-b2fa-8b69961b50ed",
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
                                    },
                                    {
                                        "id": "4714fa22-15f4-4f1b-8ea9-89d897768be2",
                                        "code": "SOLC",
                                        "name": "Solana",
                                        "image": "https://storage.ngodingin.org/storage/file_683d806b822b59.93212024.png",
                                        "fee_type": 0,
                                        "fee": 3,
                                        "status": "active",
                                        "created_at": "2025-06-03",
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
                                "created_at": "05/06/2025 07:00:00"
                            }
                        },
                        "amount": 0,
                        "sub_total": 2,
                        "blockchain": null
                    }
                ],
                "created_at": "05/06/2025 22:34:20",
                "updated_at": null,
                "deleted_at": null
            }
        ]
    }
}
''';

  try {
    print("🧪 Testing Transaction Model Parsing...");

    final Map<String, dynamic> jsonData = json.decode(jsonResponse);
    final List<dynamic> transactionList = jsonData['data']['data'];

    print("✅ JSON parsing successful");
    print("📊 Found ${transactionList.length} transactions");

    for (int i = 0; i < transactionList.length; i++) {
      print("\n🔍 Processing transaction ${i + 1}:");

      final transaction = TransactionModel.fromJson(transactionList[i]);
      print("   ✅ Transaction ${transaction.id} parsed successfully");
      print("   💰 Total: ${transaction.total}");
      print(
        "   📧 Transfer to: ${transaction.transferMeta?.name} (${transaction.transferMeta?.value})",
      );
      print("   📦 Products: ${transaction.products?.length ?? 0}");

      if (transaction.products != null) {
        for (int j = 0; j < transaction.products!.length; j++) {
          final product = transaction.products![j];
          print("   📦 Product ${j + 1}:");
          print(
            "      From: ${product.productMeta?.from?.name} (${product.productMeta?.from?.code})",
          );
          print(
            "      To: ${product.productMeta?.to?.product?.name} (${product.productMeta?.to?.product?.code})",
          );
          print("      Amount: ${product.amount}");
          print("      Sub-total: ${product.subTotal}");

          if (product.productMeta?.from?.blockchains != null) {
            print(
              "      🔗 Blockchains: ${product.productMeta!.from!.blockchains!.length}",
            );
            for (final blockchain in product.productMeta!.from!.blockchains!) {
              print(
                "         - ${blockchain.name} (${blockchain.code}) - Fee: ${blockchain.fee}",
              );
            }
          }
        }
      }
    }

    print("\n🎉 All transactions parsed successfully!");
  } catch (e, stackTrace) {
    print("❌ Error parsing transaction model: $e");
    print("📚 Stack trace: $stackTrace");
  }
}
