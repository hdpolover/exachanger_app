import 'package:flutter/material.dart';
import 'lib/app/data/models/transaction_model.dart';
import 'lib/app/modules/history/views/widgets/history_item.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TestHistoryItemScreen());
  }
}

class TestHistoryItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Test transaction with wallet address (should show blockchain section)
    final transactionWithAddress = TransactionModel(
      id: "test-1",
      trxCode: "EXA-001",
      total: 100.0,
      status: 1,
      transferMeta: TransferMeta(
        walletAddress: "0x4f9778b95ad9454df8e2fedfce38ca754295e970",
        rateId: "rate-1",
        amount: "100.0",
        total: "101.0",
      ),
      products: [
        Products(
          id: "product-1",
          productMeta: ProductMeta(
            from: From(
              code: "USDT",
              name: "USDT",
              image: "https://example.com/usdt.png",
              blockchains: [Blockchain(name: "BEP20", code: "BEP20")],
            ),
            to: To(
              product: Product(
                name: "Target Product",
                image: "https://example.com/target.png",
              ),
            ),
          ),
        ),
      ],
    );

    // Test transaction without wallet address (should hide blockchain section)
    final transactionWithoutAddress = TransactionModel(
      id: "test-2",
      trxCode: "EXA-002",
      total: 200.0,
      status: 1,
      transferMeta: TransferMeta(
        walletAddress: null, // No wallet address
        rateId: "rate-2",
        amount: "200.0",
        total: "202.0",
      ),
      products: [
        Products(
          id: "product-2",
          productMeta: ProductMeta(
            from: From(
              code: "BANK",
              name: "Bank Transfer",
              image: "https://example.com/bank.png",
            ),
            to: To(
              product: Product(
                name: "Target Product",
                image: "https://example.com/target.png",
              ),
            ),
          ),
        ),
      ],
    );

    // Test transaction with empty wallet address
    final transactionWithEmptyAddress = TransactionModel(
      id: "test-3",
      trxCode: "EXA-003",
      total: 300.0,
      status: 1,
      transferMeta: TransferMeta(
        walletAddress: "", // Empty wallet address
        rateId: "rate-3",
        amount: "300.0",
        total: "303.0",
      ),
      products: [
        Products(
          id: "product-3",
          productMeta: ProductMeta(
            from: From(
              code: "PAYPAL",
              name: "PayPal",
              image: "https://example.com/paypal.png",
            ),
            to: To(
              product: Product(
                name: "Target Product",
                image: "https://example.com/target.png",
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text('History Item Test')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('With Wallet Address (shows blockchain):'),
            SizedBox(height: 8),
            HistoryItem(transaction: transactionWithAddress),
            SizedBox(height: 20),

            Text('Without Wallet Address (hides blockchain):'),
            SizedBox(height: 8),
            HistoryItem(transaction: transactionWithoutAddress),
            SizedBox(height: 20),

            Text('Empty Wallet Address (hides blockchain):'),
            SizedBox(height: 8),
            HistoryItem(transaction: transactionWithEmptyAddress),
          ],
        ),
      ),
    );
  }
}
