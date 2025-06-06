// Example JSON Structure:
// {
//     "id": "73c13660-5673-4fab-97df-853f53c887b1",
//     "user_id": "8d69f872-21b7-473c-8579-9b47f8f50866",
//     "referral_id": null,
//     "promo_id": null,
//     "trx_code": "EXA-0020250606546",
//     "payment_proof": null,
//     "discount": 0,
//     "total": 101,
//     "transfer_meta": {
//         "rate_id": "a11ab0ba-1e9b-4be5-9896-1fb9388409f6",
//         "amount": "100.0",
//         "total": "101.0",
//         "blockchain_id": "175edada-7dce-4c3c-ad65-f658e0bd4db1",
//         "wallet_address": "dsrrffgfeafe",
//         "created_at": null
//     },
//     "status": 0,
//     "note": null,
//     "products": [
//         {
//             "id": "dcced035-bdf7-439d-86e3-3f65c9839740",
//             "rate_id": "a11ab0ba-1e9b-4be5-9896-1fb9388409f6",
//             "product_meta": {
//                 "from": {
//                     "id": "d697afab-cd63-4548-a50e-a913954eea78",
//                     "code": "USDC",
//                     "order": 1,
//                     "name": "USDC",
//                     "image": "https://storage.ngodingin.org/storage/file_68137b7b1e58d7.88037574.jpg",
//                     "status": "active",
//                     "created_at": "05/02/2025 10:47:40",
//                     "updated_at": "2025-05-26T03:07:54.000Z",
//                     "price": {
//                         "id": null,
//                         "pricing_type": 0,
//                         "pricing": 1,
//                         "fee_type": 0,
//                         "fee": 1,
//                         "currency": "USD"
//                     },
//                     "blockchains": [...],
//                     "transfer_data": {
//                         "id": "413c5616-7043-4601-bc6d-717e1948b519",
//                         "type": "address",
//                         "value": "ADAxwwca342dawd",
//                         "status": 1,
//                         "created_at": "17/05/2025 01:37:01",
//                         "updated_at": null
//                     }
//                 },
//                 "to": {
//                     "id": "a11ab0ba-1e9b-4be5-9896-1fb9388409f6",
//                     "pricing_type": 0,
//                     "pricing": 0.99,
//                     "fee_type": 0,
//                     "fee": 1,
//                     "status": "active",
//                     "currency": "id-ID",
//                     "product": {
//                         "id": "8261259b-9cc2-4efc-8d19-8e145a3b2c9a",
//                         "code": "USDT",
//                         "name": "USDT",
//                         "image": "https://storage.ngodingin.org/storage/file_68137b345cce49.80443666.jpg",
//                         "category": "blockchain"
//                     },
//                     "created_at": "06/06/2025 07:00:00"
//                 }
//             },
//             "amount": 100,
//             "sub_total": 101,
//             "blockchain": null
//         }
//     ],
//     "created_at": "07/06/2025 02:27:07",
//     "updated_at": null,
//     "deleted_at": null
// }

class TransactionModel {
  final String? id;
  final String? userId;
  final String? referralId;
  final String? promoId;
  final String? trxCode;
  final String? paymentProof;
  final int? discount;
  final double? total;
  final TransferMeta? transferMeta;
  final int? status;
  final String? note;
  final List<Products>? products;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  TransactionModel({
    this.id,
    this.userId,
    this.referralId,
    this.promoId,
    this.trxCode,
    this.paymentProof,
    this.discount,
    this.total,
    this.transferMeta,
    this.status,
    this.note,
    this.products,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      referralId: json['referral_id'],
      promoId: json['promo_id'],
      trxCode: json['trx_code'],
      paymentProof: json['payment_proof'],
      discount: _parseIntFromDynamic(json['discount']),
      total: json['total'] != null
          ? double.parse(json['total'].toString())
          : null,
      transferMeta: json['transfer_meta'] != null
          ? TransferMeta.fromJson(json['transfer_meta'])
          : null,
      status: _parseIntFromDynamic(json['status']),
      note: json['note'],
      products: json['products'] != null
          ? (json['products'] as List).map((i) => Products.fromJson(i)).toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
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

  @override
  String toString() {
    return 'TransactionModel{id: $id, userId: $userId, referralId: $referralId, promoId: $promoId, trxCode: $trxCode, paymentProof: $paymentProof, discount: $discount, total: $total, transferMeta: $transferMeta, status: $status, note: $note, products: $products, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}

class Products {
  final String? id;
  final String? rateId;
  final ProductMeta? productMeta;
  final double? amount;
  final double? subTotal;
  final String? blockchain;

  Products({
    this.id,
    this.rateId,
    this.productMeta,
    this.amount,
    this.subTotal,
    this.blockchain,
  });
  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      rateId: json['rate_id'],
      productMeta: json['product_meta'] != null
          ? ProductMeta.fromJson(json['product_meta'])
          : null,
      amount: json['amount'] != null
          ? double.parse(json['amount'].toString())
          : null,
      subTotal: json['sub_total'] != null
          ? double.parse(json['sub_total'].toString())
          : null,
      blockchain: json['blockchain'],
    );
  }
  @override
  String toString() {
    return 'Products{id: $id, rateId: $rateId, productMeta: $productMeta, amount: $amount, subTotal: $subTotal, blockchain: $blockchain}';
  }
}

class ProductMeta {
  final From? from;
  final To? to;

  ProductMeta({this.from, this.to});

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    return ProductMeta(
      from: json['from'] != null ? From.fromJson(json['from']) : null,
      to: json['to'] != null ? To.fromJson(json['to']) : null,
    );
  }

  @override
  String toString() {
    return 'ProductMeta{from: $from, to: $to}';
  }
}

class To {
  final String? id;
  final int? pricingType;
  final double? pricing;
  final int? feeType;
  final double? fee;
  final String? status; // Changed from String? to String?
  final String? currency;
  final Product? product;
  final String? createdAt;

  To({
    this.id,
    this.pricingType,
    this.pricing,
    this.feeType,
    this.fee,
    this.status,
    this.currency,
    this.product,
    this.createdAt,
  });

  factory To.fromJson(Map<String, dynamic> json) {
    return To(
      id: json['id'],
      pricingType: _parseIntFromDynamic(json['pricing_type']),
      pricing: json['pricing'] != null
          ? double.parse(json['pricing'].toString())
          : null,
      feeType: _parseIntFromDynamic(json['fee_type']),
      fee: json['fee'] != null ? double.parse(json['fee'].toString()) : null,
      status: json['status'],
      currency: json['currency'],
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      createdAt: json['created_at'],
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

  @override
  String toString() {
    return 'To{id: $id, pricingType: $pricingType, pricing: $pricing, feeType: $feeType, fee: $fee, status: $status, currency: $currency, product: $product, createdAt: $createdAt}';
  }
}

class Product {
  final String? id;
  final String? code;
  final String? name;
  final String? image;
  final String? category;

  Product({this.id, this.code, this.name, this.image, this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      category: json['category'],
    );
  }
  @override
  String toString() {
    return 'Product{id: $id, code: $code, name: $name, image: $image, category: $category}';
  }
}

class From {
  final String? id;
  final String? code;
  final int? order;
  final String? name;
  final String? image;
  final String? status; // Changed to String? to handle "active"/"draft"
  final String? createdAt;
  final String? updatedAt;
  final Price? price;
  final List<Blockchain>? blockchains;
  final TransferData? transferData;

  From({
    this.id,
    this.code,
    this.order,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.blockchains,
    this.transferData,
  });

  factory From.fromJson(Map<String, dynamic> json) {
    return From(
      id: json['id'],
      code: json['code'],
      order: _parseIntFromDynamic(json['order']),
      name: json['name'],
      image: json['image'],
      status: json['status']
          ?.toString(), // Convert to string to handle both int and string
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      price: json['price'] != null ? Price.fromJson(json['price']) : null,
      blockchains: json['blockchains'] != null
          ? (json['blockchains'] as List)
                .map((i) => Blockchain.fromJson(i))
                .toList()
          : null,
      transferData: json['transfer_data'] != null
          ? TransferData.fromJson(json['transfer_data'])
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

  @override
  String toString() {
    return 'From{id: $id, code: $code, order: $order, name: $name, image: $image, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, price: $price, blockchains: $blockchains, transferData: $transferData}';
  }
}

class TransferData {
  final String? id;
  final String? type;
  final String? value;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  TransferData({
    this.id,
    this.type,
    this.value,
    this.status,
    this.createdAt,
    this.updatedAt,
  });
  factory TransferData.fromJson(Map<String, dynamic> json) {
    return TransferData(
      id: json['id'],
      type: json['type'],
      value: json['value'],
      status: _parseIntFromDynamic(json['status']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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

  @override
  String toString() {
    return 'TransferData{id: $id, type: $type, value: $value, status: $status, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class Price {
  final String? id;
  final int? pricingType;
  final double? pricing;
  final int? feeType;
  final double? fee;
  final String? currency;

  Price({
    this.id,
    this.pricingType,
    this.pricing,
    this.feeType,
    this.fee,
    this.currency,
  });
  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'],
      pricingType: _parseIntFromDynamic(json['pricing_type']),
      pricing: json['pricing'] != null
          ? double.parse(json['pricing'].toString())
          : null,
      feeType: _parseIntFromDynamic(json['fee_type']),
      fee: json['fee'] != null ? double.parse(json['fee'].toString()) : null,
      currency: json['currency'],
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

  @override
  String toString() {
    return 'Price{id: $id, pricingType: $pricingType, pricing: $pricing, feeType: $feeType, fee: $fee, currency: $currency}';
  }
}

class Blockchain {
  final String? id;
  final String? code;
  final String? name;
  final String? image;
  final int? feeType;
  final double? fee;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  Blockchain({
    this.id,
    this.code,
    this.name,
    this.image,
    this.feeType,
    this.fee,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Blockchain.fromJson(Map<String, dynamic> json) {
    return Blockchain(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      feeType: _parseIntFromDynamic(json['fee_type']),
      fee: json['fee'] != null ? double.parse(json['fee'].toString()) : null,
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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

  @override
  String toString() {
    return 'Blockchain{id: $id, code: $code, name: $name, image: $image, feeType: $feeType, fee: $fee, status: $status, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class TransferMeta {
  final String? rateId;
  final String? amount;
  final String? total;
  final String? blockchainId;
  final String? walletAddress;
  final String? createdAt;
  // Legacy fields for backward compatibility
  final String? name;
  final String? type;
  final String? value;
  final int? status;
  final String? updatedAt;

  TransferMeta({
    this.rateId,
    this.amount,
    this.total,
    this.blockchainId,
    this.walletAddress,
    this.createdAt,
    // Legacy fields
    this.name,
    this.type,
    this.value,
    this.status,
    this.updatedAt,
  });

  factory TransferMeta.fromJson(Map<String, dynamic> json) {
    return TransferMeta(
      rateId: json['rate_id'],
      amount: json['amount']?.toString(),
      total: json['total']?.toString(),
      blockchainId: json['blockchain_id'],
      walletAddress: json['wallet_address'],
      createdAt: json['created_at'],
      // Legacy fields for backward compatibility
      name: json['name'],
      type: json['type'],
      value: json['value'],
      status: _parseIntFromDynamic(json['status']),
      updatedAt: json['updated_at'],
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

  @override
  String toString() {
    return 'TransferMeta{rateId: $rateId, amount: $amount, total: $total, blockchainId: $blockchainId, walletAddress: $walletAddress, createdAt: $createdAt, name: $name, type: $type, value: $value, status: $status, updatedAt: $updatedAt}';
  }
}
