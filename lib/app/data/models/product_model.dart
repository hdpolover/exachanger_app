// Product model based on the JSON response
import 'price_model.dart';
import 'rate_model.dart';
import 'transfer_data_model.dart';

class ProductModel {
  final String? id;
  final String? code;
  final String? name;
  final String? image;
  final String? category;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final PriceModel? price;
  final List<RateModel>? rates;
  final TransferDataModel? transferData;

  ProductModel({
    this.id,
    this.code,
    this.name,
    this.image,
    this.category,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.rates,
    this.transferData,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      category: json['category'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      price: json['price'] != null ? PriceModel.fromJson(json['price']) : null,
      rates: json['rates'] != null
          ? (json['rates'] as List).map((i) => RateModel.fromJson(i)).toList()
          : null,
      transferData: json['transfer_data'] != null
          ? TransferDataModel.fromJson(json['transfer_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['image'] = this.image;
    data['category'] = this.category;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.rates != null) {
      data['rates'] = this.rates!.map((v) => v.toJson()).toList();
    }
    if (this.transferData != null) {
      data['transfer_data'] = this.transferData!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, code: $code, name: $name, category: $category, status: $status}';
  }
}
