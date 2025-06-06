import 'package:cached_network_image/cached_network_image.dart';
import 'package:exachanger_get_app/app/core/values/app_images.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/data/models/transaction_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/widgets/status_chip.dart';

class HistoryItem extends StatelessWidget {
  final TransactionModel transaction;
  const HistoryItem({super.key, this.onTap, required this.transaction});

  final VoidCallback? onTap;

  _productView(String url, String name) {
    print('url: $url');

    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: url,
          errorWidget: (context, url, error) =>
              Image.asset(AppImages.logo, width: 15),
          width: 15,
        ),
        SizedBox(width: 5),
        Text(
          name,
          style: extraSmallBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _topSection() {
    int status = transaction.status ?? 0;

    From from = transaction.products![0].productMeta!.from!;
    To to = transaction.products![0].productMeta!.to!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _productView(from.image!, from.name!),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.arrow_forward, size: 20),
                    ),
                    _productView(to.product!.image!, to.product!.name!),
                  ],
                ),
                StatusChip(status: status),
              ],
            ),
            Text(
              CommonFunctions.formatDateTime(DateTime.now()),
              style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  _bottomSection() {
    // Check if wallet address exists and is not empty
    String? walletAddress = transaction.transferMeta?.walletAddress;
    bool hasWalletAddress =
        walletAddress != null && walletAddress.trim().isNotEmpty;

    // Get blockchain/crypto information for display
    String blockchainLabel = 'Wallet Address';
    if (transaction.products != null && transaction.products!.isNotEmpty) {
      From? from = transaction.products![0].productMeta?.from;
      if (from != null && from.code != null) {
        blockchainLabel = '${from.code} Address';
        // If there are blockchains, use the first one's name
        if (from.blockchains != null && from.blockchains!.isNotEmpty) {
          String blockchainName =
              from.blockchains![0].name ?? from.blockchains![0].code ?? '';
          if (blockchainName.isNotEmpty) {
            blockchainLabel = '${from.code} $blockchainName Address';
          }
        }
      }
    }
    return Row(
      mainAxisAlignment: hasWalletAddress
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only show blockchain address section if wallet address exists
        if (hasWalletAddress) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blockchainLabel,
                  style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 5),
                Text(
                  walletAddress,
                  style: regularBodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Amount Received',
              style: extraSmallBodyTextStyle.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              CommonFunctions.formatUSD(transaction.total!),
              style: bigBodyTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // decoration for the card
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [_topSection(), SizedBox(height: 10), _bottomSection()],
        ),
      ),
    );
  }
}
