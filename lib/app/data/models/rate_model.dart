// Rate model based on the JSON response
import 'product_model.dart';

class RateModel {
  final String? id;
  final int? pricingType;
  final dynamic pricing;
  final int? feeType;
  final dynamic fee;
  final dynamic minimumAmount;
  final String? status;
  final String? currency;
  final ProductModel? product;

  RateModel({
    this.id,
    this.pricingType,
    this.pricing,
    this.feeType,
    this.fee,
    this.minimumAmount,
    this.status,
    this.currency,
    this.product,
  });
  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      id: json['id'],
      pricingType: _parseIntFromDynamic(json['pricing_type']),
      pricing: json['pricing'],
      feeType: _parseIntFromDynamic(json['fee_type']),
      fee: json['fee'],
      minimumAmount: json['minimum_amount'],
      status: json['status'],
      currency: json['currency'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }

  static int? _parseIntFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        print("ERROR: Could not parse '$value' as int");
        return null;
      }
    }
    print("ERROR: Unexpected type ${value.runtimeType} for int field: $value");
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pricing_type'] = this.pricingType;
    data['pricing'] = this.pricing;
    data['fee_type'] = this.feeType;
    data['fee'] = this.fee;
    data['minimum_amount'] = this.minimumAmount;
    data['status'] = this.status;
    data['currency'] = this.currency;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'RateModel{id: $id, pricing: $pricing, status: $status, product: $product}';
  }
}
