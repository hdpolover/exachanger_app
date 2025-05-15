import 'dart:convert';

import 'package:exachanger_get_app/app/data/models/product_model.dart';
import 'package:flutter/material.dart';

void main() {
  // Load the JSON data from response.json
  final String jsonData = '''
{
  "status":"Success",
  "code":200,
  "data":{
    "data": [
      {
        "id":"2076df50-f661-4cad-9bf9-8526b44b6f95",
        "code":"AT",
        "name":"AirTM",
        "image":"https://storage.ngodingin.org/storage/file_68137a8a1194a3.29408269.jpg",
        "category":"e-money",
        "status":1,
        "created_at":"02/05/2025 03:43:39",
        "updated_at":null,
        "price":{
          "id":null,
          "pricing_type":0,
          "pricing":1,
          "fee_type":0,
          "fee":1,
          "currency":"USD"
        },
        "rates":[
          {
            "id":"bc54dc70-eeb2-441c-b56a-dc9ef95ef0f0",
            "pricing_type":0,
            "pricing":0.9,
            "fee_type":0,
            "fee":0,
            "minimum_amount":0,
            "status":"active",
            "currency":"id-ID",
            "product":{
              "id":"93555914-6a4a-4a9b-a227-61d75a2ee970",
              "code":"NTL",
              "name":"Neteller",
              "image":"https://storage.ngodingin.org/storage/file_68137b5b8e8539.78534885.jpg",
              "category":"e-money"
            }
          }
        ],
        "transfer_data":null
      }
    ]
  },
  "message":"Success get all product data"
}
  ''';

  // Parse JSON
  final jsonObject = json.decode(jsonData);
  final data = jsonObject['data']['data'] as List<dynamic>;

  // Parse products
  final List<ProductModel> products = data
      .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
      .toList();

  // Print the result to verify
  debugPrint(products.toString());

  // Access nested objects for verification
  debugPrint("Product name: ${products.first.name}");
  debugPrint("Rate count: ${products.first.rates?.length}");
  if (products.first.rates != null && products.first.rates!.isNotEmpty) {
    debugPrint("First rate pricing: ${products.first.rates!.first.pricing}");
    debugPrint(
        "First rate product name: ${products.first.rates!.first.product?.name}");
  }
}
