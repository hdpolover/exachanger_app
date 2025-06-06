import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/exchange_controller.dart';

class WalletAddressInput extends StatelessWidget {
  final ExchangeController controller;

  const WalletAddressInput({Key? key, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedBlockchain = controller.selectedBlockchain.value;
      if (selectedBlockchain != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              '${selectedBlockchain.name} Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextFormField(
              key: ValueKey(selectedBlockchain.id),
              initialValue: controller.walletAddress.value,
              onChanged: (value) => controller.setWalletAddress(value),
              style: TextStyle(fontSize: 14.0),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 12.0,
                ),
                border: OutlineInputBorder(),
                hintText:
                    'Enter your ${selectedBlockchain.name} wallet address',
                prefixIcon: Icon(Icons.account_balance_wallet),
                suffixIcon: Obx(
                  () => controller.walletAddress.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => controller.setWalletAddress(''),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
          ],
        );
      }
      return SizedBox.shrink();
    });
  }
}
