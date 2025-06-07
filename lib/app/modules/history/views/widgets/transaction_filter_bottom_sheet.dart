import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exachanger_get_app/app/core/values/app_colors.dart';
import 'package:exachanger_get_app/app/data/models/product_model.dart';
import '../../controllers/history_controller.dart';

class TransactionFilterBottomSheet extends StatelessWidget {
  final HistoryController controller = Get.find<HistoryController>();

  TransactionFilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Obx(
                () => controller.hasActiveFilters.value
                    ? OutlinedButton(
                        onPressed: () {
                          controller.clearFilters();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1.5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Date Range Section
          _buildDateRangeSection(),
          const SizedBox(height: 24),

          // Products Section
          _buildProductsSection(),
          const SizedBox(height: 24),

          // Confirm Button
          _buildConfirmButton(context),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date Range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _buildDateField(
                  label: 'Start Date',
                  selectedDate: controller.startDate.value,
                  onTap: () => _selectStartDate(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => _buildDateField(
                  label: 'End Date',
                  selectedDate: controller.endDate.value,
                  onTap: () => _selectEndDate(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedDate != null
                        ? _formatDate(selectedDate)
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDate != null
                          ? Colors.black
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Products',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Obx(
              () => controller.selectedProductIds.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.colorPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${controller.selectedProductIds.length} selected',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.availableProducts.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'No products available',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.availableProducts.length,
              itemBuilder: (context, index) {
                final product = controller.availableProducts[index];
                return _buildProductItem(product);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProductItem(ProductModel product) {
    return Obx(() {
      final isSelected = controller.isProductSelected(product.id ?? '');

      return GestureDetector(
        onTap: () => controller.toggleProductSelection(product.id ?? ''),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.colorPrimary : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? AppColors.colorPrimary.withOpacity(0.05)
                : Colors.white,
          ),
          child: Row(
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: product.image != null && product.image!.isNotEmpty
                    ? Image.network(
                        product.image!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[200],
                            child: Icon(Icons.image, color: Colors.grey[400]),
                          );
                        },
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey[200],
                        child: Icon(Icons.image, color: Colors.grey[400]),
                      ),
              ),
              const SizedBox(width: 12),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (product.code != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.code!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),

              // Checkbox
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.colorPrimary
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: isSelected
                      ? AppColors.colorPrimary
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Obx(() {
      final filteredCount = controller.filteredTransactionList.value.length;
      final totalCount = controller.transactionList.value.length;

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.colorPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Show $filteredCount of $totalCount Transactions',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  void _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.startDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.colorPrimary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setDateFilter(picked, controller.endDate.value);
    }
  }

  void _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.endDate.value ?? DateTime.now(),
      firstDate: controller.startDate.value ?? DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.colorPrimary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setDateFilter(controller.startDate.value, picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
