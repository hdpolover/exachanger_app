import 'package:flutter/material.dart';
import 'package:exachanger_get_app/app/data/models/blockchain_model.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:get/get.dart';
import '../../controllers/exchange_controller.dart';

class BlockchainSelector extends StatelessWidget {
  final List<BlockchainModel> blockchains;
  final ExchangeController controller;
  final Function(BlockchainModel?)? onBlockchainChanged;

  const BlockchainSelector({
    Key? key,
    required this.blockchains,
    required this.controller,
    this.onBlockchainChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Blockchain Network',
          style: smallBodyTextStyle.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<BlockchainModel>(
            value: controller.selectedBlockchain.value,
            style: regularBodyTextStyle.copyWith(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 12.0,
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
              hintText: 'Select blockchain network',
              hintStyle: regularBodyTextStyle.copyWith(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
            ),
            items: blockchains.map<DropdownMenuItem<BlockchainModel>>((
              blockchain,
            ) {
              return DropdownMenuItem<BlockchainModel>(
                value: blockchain,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (blockchain.image != null &&
                        blockchain.image!.isNotEmpty)
                      Container(
                        width: 18,
                        height: 18,
                        margin: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.network(
                            blockchain.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.account_balance_wallet,
                                size: 16,
                                color: Colors.grey.shade600,
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 18,
                        height: 18,
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.account_balance_wallet,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    Flexible(
                      child: Text(
                        blockchain.name ?? 'Unknown Network',
                        style: regularBodyTextStyle.copyWith(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (blockchain) {
              controller.setSelectedBlockchain(blockchain);
              // Call the callback if provided
              if (onBlockchainChanged != null) {
                onBlockchainChanged!(blockchain);
              }
            },
          ),
        ),
      ],
    );
  }
}
