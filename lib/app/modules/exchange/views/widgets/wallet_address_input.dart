import 'package:flutter/material.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
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
              'Wallet Address',
              style: smallBodyTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              key: ValueKey(selectedBlockchain.id),
              initialValue: controller.walletAddress.value,
              onChanged: (value) => controller.setWalletAddress(value),
              style: regularBodyTextStyle.copyWith(fontSize: 13),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 14.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red.shade400, width: 2),
                ),
                hintText:
                    'Enter your ${selectedBlockchain.name} wallet address',
                hintStyle: regularBodyTextStyle.copyWith(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                prefixIcon: Icon(
                  Icons.account_balance_wallet,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                suffixIcon: Obx(
                  () => controller.walletAddress.value.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () => controller.setWalletAddress(''),
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
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
