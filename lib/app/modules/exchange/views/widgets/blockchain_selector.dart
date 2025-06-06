import 'package:flutter/material.dart';
import 'package:exachanger_get_app/app/data/models/blockchain_model.dart';
import 'package:get/get.dart';
import '../../controllers/exchange_controller.dart';

class BlockchainSelector extends StatelessWidget {
  final List<BlockchainModel> blockchains;
  final ExchangeController controller;

  const BlockchainSelector({
    Key? key,
    required this.blockchains,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Blockchain', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<BlockchainModel>(
            value: controller.selectedBlockchain.value,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 12.0,
              ),
              border: OutlineInputBorder(),
              hintText: 'Select blockchain network',
            ),
            items: blockchains.map<DropdownMenuItem<BlockchainModel>>((
              blockchain,
            ) {
              return DropdownMenuItem<BlockchainModel>(
                value: blockchain,
                child: Row(
                  children: [
                    if (blockchain.image != null &&
                        blockchain.image!.isNotEmpty)
                      Container(
                        width: 24,
                        height: 24,
                        margin: EdgeInsets.only(right: 8),
                        child: Image.network(
                          blockchain.image!,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.account_balance_wallet, size: 24);
                          },
                        ),
                      ),
                    Text(blockchain.name ?? ''),
                  ],
                ),
              );
            }).toList(),
            onChanged: (blockchain) {
              controller.setSelectedBlockchain(blockchain);
            },
          ),
        ),
      ],
    );
  }
}
