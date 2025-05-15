// Price model based on the JSON response
class PriceModel {
  final String? id;
  final int? pricingType;
  final dynamic pricing;
  final int? feeType;
  final dynamic fee;
  final String? currency;

  PriceModel({
    this.id,
    this.pricingType,
    this.pricing,
    this.feeType,
    this.fee,
    this.currency,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['id'],
      pricingType: json['pricing_type'],
      pricing: json['pricing'],
      feeType: json['fee_type'],
      fee: json['fee'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pricing_type'] = this.pricingType;
    data['pricing'] = this.pricing;
    data['fee_type'] = this.feeType;
    data['fee'] = this.fee;
    data['currency'] = this.currency;
    return data;
  }

  @override
  String toString() {
    return 'PriceModel{pricingType: $pricingType, pricing: $pricing, feeType: $feeType, fee: $fee, currency: $currency}';
  }
}
