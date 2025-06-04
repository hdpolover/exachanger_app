import 'package:exachanger_get_app/app/core/base/base_view.dart';
import 'package:exachanger_get_app/app/core/values/text_styles.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_app_bar.dart';
import 'package:exachanger_get_app/app/core/widgets/custom_button.dart';
import 'package:exachanger_get_app/app/modules/exchange/controllers/exchange_controller.dart';
import 'package:exachanger_get_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AmountTextField extends StatefulWidget {
  final dynamic product;
  final Function(String) onAmountChanged;

  const AmountTextField({
    Key? key,
    this.product,
    required this.onAmountChanged,
  }) : super(key: key);

  @override
  _AmountTextFieldState createState() => _AmountTextFieldState();
}

class _AmountTextFieldState extends State<AmountTextField> {
  String amount = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          amount = value;
        });
        widget.onAmountChanged(value);
      },
      style: TextStyle(fontSize: 14.0), // Smaller text size
      decoration: InputDecoration(
        isDense: true, // Makes the field more compact
        contentPadding: EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 12.0), // Symmetric padding
        border: OutlineInputBorder(),
        hintText: 'Enter amount',
        hintStyle: TextStyle(
            fontSize: 14.0), // Match hint text size to input text size
        prefixIcon: amount.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('\$', style: TextStyle(fontSize: 14.0)),
              )
            : null,
        prefixIconConstraints: BoxConstraints(
            minWidth: 0, minHeight: 0), // Allow flexible prefix size
        suffixIcon: Container(
          padding: EdgeInsets.all(6.0),
          child: widget.product != null &&
                  widget.product.image != null &&
                  widget.product.image!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.product.image!,
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
    );
  }
}

class ProceedExchangeView extends BaseView<ExchangeController> {
  final TextEditingController _receiveAmountController =
      TextEditingController();
  // Define fee as a constant
  static const double FEE = 1.00;

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Exchange',
    );
  }

  @override
  Widget body(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final sendProduct = args != null ? args['sendProduct'] : null;
    final receiveRate = args != null ? args['receiveRate'] : null;

    // Calculate rate for display
    final double exchangeRate =
        receiveRate != null && receiveRate.pricing != null
            ? double.tryParse(receiveRate.pricing.toString()) ?? 0.0
            : 0.0;

    // Use RxDouble for reactive values
    final RxDouble inputAmount = 0.0.obs;
    final RxDouble calculatedAmount =
        0.0.obs; // Function to update calculated values
    void updateCalculations(String amountStr) {
      double? amount = double.tryParse(amountStr);
      if (amount != null && exchangeRate > 0) {
        inputAmount.value = amount;
        calculatedAmount.value = amount * exchangeRate;
        _receiveAmountController.text =
            calculatedAmount.value.toStringAsFixed(2);
      } else {
        inputAmount.value = 0.0;
        calculatedAmount.value = 0.0;
        _receiveAmountController.text = '';
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                Text(sendProduct.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                Text(receiveRate.product.name ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Text('Enter Amount',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          SizedBox(height: 16),
          Text('The money you will send'),
          SizedBox(height: 8),
          AmountTextField(
            product: sendProduct,
            onAmountChanged: updateCalculations,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min Amount: 1 USD', style: smallBodyTextStyle),
              Text('Max Amount: 5000 USD', style: smallBodyTextStyle),
            ],
          ),
          SizedBox(height: 16),
          Text('The recipient will receive'),
          SizedBox(height: 8),
          TextField(
            controller: _receiveAmountController,
            enabled: false,
            style: TextStyle(fontSize: 14.0), // Match send field text size
            decoration: InputDecoration(
              isDense: true, // Makes the field more compact
              contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 12.0), // Symmetric padding
              border: OutlineInputBorder(),
              hintText: 'Calculated amount',
              hintStyle: TextStyle(fontSize: 14.0),
              prefixIcon: _receiveAmountController.text.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('\$', style: TextStyle(fontSize: 14.0)),
                    )
                  : null,
              prefixIconConstraints: BoxConstraints(
                  minWidth: 0, minHeight: 0), // Allow flexible prefix size
              suffixIcon: Container(
                padding: EdgeInsets.all(6.0),
                child: receiveRate != null &&
                        receiveRate.product != null &&
                        receiveRate.product!.image != null &&
                        receiveRate.product!.image!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          receiveRate.product!.image!,
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
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exchange Rate: ',
                style: smallBodyTextStyle,
              ),
              Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 4, horizontal: 8), // Adjust padding
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    children: [
                      if (sendProduct != null && sendProduct.image != null)
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
                      Text('1 USD = '),
                      if (receiveRate != null && receiveRate.product != null)
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
                      Text(receiveRate != null
                          ? '${receiveRate.pricing ?? ''} USD'
                          : ''),
                    ],
                  ))
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Fee: ', style: smallBodyTextStyle),
              Text('\$${FEE.toStringAsFixed(2)}', style: smallBodyTextStyle),
            ],
          ),
          // SizedBox(height: 8),
          // Obx(() {
          //   // Total amount is the calculated amount minus the fee
          //   double totalWithFee = calculatedAmount.value - FEE;
          //   // Make sure total doesn't go negative
          //   totalWithFee = totalWithFee > 0 ? totalWithFee : 0.0;
          //   return Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Total with Fee: ',
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: Theme.of(context).primaryColor,
          //         ),
          //       ),
          //       Text(
          //         '\$${totalWithFee.toStringAsFixed(2)}',
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: Theme.of(context).primaryColor,
          //         ),
          //       ),
          //     ],
          //   );
          // }),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
                label: 'Continue',
                onPressed: () {
                  // Calculate final amounts
                  double sendAmount = inputAmount.value;
                  double receiveAmount = calculatedAmount
                      .value; // Navigate to confirm exchange page with all necessary data
                  Get.toNamed(Routes.CONFIRM_EXCHANGE, arguments: {
                    'sendProduct': sendProduct,
                    'receiveRate': receiveRate,
                    'sendAmount': sendAmount,
                    'receiveAmount': receiveAmount,
                    'fee': FEE
                  });
                }),
          ),
        ],
      ),
    );
  }
}
