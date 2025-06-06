import 'package:flutter/material.dart';

class ExchangeHeader extends StatelessWidget {
  final dynamic sendProduct;
  final dynamic receiveRate;

  const ExchangeHeader({
    Key? key,
    required this.sendProduct,
    required this.receiveRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Exchange ', style: TextStyle(fontWeight: FontWeight.bold)),
        if (sendProduct != null) ...[
          if (sendProduct.image != null && sendProduct.image!.isNotEmpty)
            Image.network(
              sendProduct.image!,
              width: 18,
              height: 18,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.currency_exchange, size: 18);
              },
            )
          else
            Icon(Icons.currency_exchange, size: 18),
          SizedBox(width: 4),
          Text(
            sendProduct.name ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(' → '),
        ],
        if (receiveRate != null && receiveRate.product != null) ...[
          if (receiveRate.product!.image != null &&
              receiveRate.product!.image!.isNotEmpty)
            Image.network(
              receiveRate.product!.image!,
              width: 18,
              height: 18,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.currency_exchange, size: 18);
              },
            )
          else
            Icon(Icons.currency_exchange, size: 18),
          SizedBox(width: 4),
          Text(
            receiveRate.product!.name ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}
