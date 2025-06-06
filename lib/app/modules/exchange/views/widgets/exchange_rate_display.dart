import 'package:flutter/material.dart';

class ExchangeRateDisplay extends StatelessWidget {
  final dynamic sendProduct;
  final dynamic receiveRate;

  const ExchangeRateDisplay({
    Key? key,
    required this.sendProduct,
    required this.receiveRate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final exchangeRate = receiveRate?.pricing?.toString() ?? '0';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Send product (Paypal) image and amount
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (sendProduct?.image != null)
                Image.network(
                  sendProduct!.image!,
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.currency_exchange,
                      size: 20,
                      color: Colors.blue,
                    );
                  },
                )
              else
                Icon(Icons.currency_exchange, size: 20, color: Colors.blue),
              SizedBox(width: 6),
              Text(
                '1 USD',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 8),

        // Arrow
        Icon(Icons.arrow_forward, size: 16, color: Colors.grey.shade600),

        SizedBox(width: 8),

        // Receive product (USDT) image and amount
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (receiveRate?.product?.image != null)
                Image.network(
                  receiveRate!.product!.image!,
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.currency_exchange,
                      size: 20,
                      color: Colors.green,
                    );
                  },
                )
              else
                Icon(Icons.currency_exchange, size: 20, color: Colors.green),
              SizedBox(width: 6),
              Text(
                '$exchangeRate USD',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
