import 'package:flutter_test/flutter_test.dart';
import 'package:exachanger_get_app/app/modules/history/controllers/history_controller.dart';
import 'package:exachanger_get_app/app/data/models/transaction_model.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:get/get.dart';

void main() {
  group('HistoryController Filter Tests', () {
    late HistoryController controller;

    setUp(() {
      // Initialize GetX
      Get.testMode = true;

      // Create mock controller
      controller = HistoryController();

      // Add sample transactions for testing
      controller.transactionList.value = [
        TransactionModel(
          id: '1',
          createdAt: '2025-06-01',
          products: [
            Products(
              productMeta: ProductMeta(
                from: From(id: 'product1', name: 'Bitcoin', code: 'BTC'),
                to: To(
                  product: Product(id: 'product2', name: 'USDT', code: 'USDT'),
                ),
              ),
            ),
          ],
        ),
        TransactionModel(
          id: '2',
          createdAt: '2025-06-05',
          products: [
            Products(
              productMeta: ProductMeta(
                from: From(id: 'product3', name: 'Ethereum', code: 'ETH'),
                to: To(
                  product: Product(id: 'product2', name: 'USDT', code: 'USDT'),
                ),
              ),
            ),
          ],
        ),
      ];

      controller.filteredTransactionList.value = List.from(
        controller.transactionList.value,
      );
    });

    test('should filter transactions by date range', () {
      // Set date filter
      controller.setDateFilter(DateTime(2025, 6, 2), DateTime(2025, 6, 6));

      // Should only show transaction from June 5th
      expect(controller.filteredTransactionList.value.length, 1);
      expect(controller.filteredTransactionList.value.first.id, '2');
    });

    test('should filter transactions by product selection', () {
      // Initialize products
      controller.initializeAvailableProducts();

      // Select specific product
      controller.toggleProductSelection('product1');

      // Should only show transactions with Bitcoin
      expect(controller.filteredTransactionList.value.length, 1);
      expect(controller.filteredTransactionList.value.first.id, '1');
    });

    test('should clear all filters', () {
      // Apply some filters
      controller.setDateFilter(DateTime(2025, 6, 2), DateTime(2025, 6, 6));
      controller.toggleProductSelection('product1');

      expect(controller.hasActiveFilters.value, true);

      // Clear filters
      controller.clearFilters();

      expect(controller.hasActiveFilters.value, false);
      expect(controller.filteredTransactionList.value.length, 2);
    });

    test('should track filter status correctly', () {
      expect(controller.hasActiveFilters.value, false);

      // Add date filter
      controller.setDateFilter(DateTime.now(), null);
      expect(controller.hasActiveFilters.value, true);

      // Clear and add product filter
      controller.clearFilters();
      controller.toggleProductSelection('product1');
      expect(controller.hasActiveFilters.value, true);
    });

    tearDown(() {
      Get.reset();
    });
  });
}
