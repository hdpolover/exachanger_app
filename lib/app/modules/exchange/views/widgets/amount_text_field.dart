import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmountTextField extends StatelessWidget {
  final dynamic product;
  final Function(String) onAmountChanged;
  final RxString amount = ''.obs;

  AmountTextField({Key? key, this.product, required this.onAmountChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        onChanged: (value) {
          amount.value = value;
          onAmountChanged(value);
        },
        style: TextStyle(fontSize: 14.0),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 12.0,
          ),
          border: OutlineInputBorder(),
          hintText: 'Enter amount',
          hintStyle: TextStyle(fontSize: 14.0),
          prefixIcon: amount.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('\$', style: TextStyle(fontSize: 14.0)),
                )
              : null,
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: Container(
            padding: EdgeInsets.all(6.0),
            child:
                product != null &&
                    product.image != null &&
                    product.image!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image!,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.currency_exchange, size: 20);
                      },
                    ),
                  )
                : Icon(Icons.currency_exchange, size: 20),
          ),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }
}
