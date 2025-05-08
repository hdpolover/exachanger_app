// {
//                 "id": "776f0bd1-9902-468b-bdd6-7a1dd22d5ce6",
//                 "user_id": "8d69f872-21b7-473c-8579-9b47f8f50866",
//                 "referral_id": null,
//                 "promo_id": null,
//                 "trx_code": "EXA-0020250209891",
//                 "payment_proof": "https://storage.ngodingin.org/storage/file_67a8e151acf020.88941514.png",
//                 "discount": 0,
//                 "total": 429.5,
//                 "transfer_meta": {
//                     "id": "a300dab1-526a-4d7d-bbf9-996aef9508aa",
//                     "type": "va",
//                     "value": "9587245042",
//                     "status": 1,
//                     "created_at": "3 Januari 2025 12:54:05",
//                     "updated_at": null
//                 },
//                 "status": 1,
//                 "note": null,
//                 "products": [
//                     {
//                         "id": "a91ea12b-82d4-48d0-8737-f75b98d50a97",
//                         "rate_id": "c40979d5-fe1d-4fe1-aa8e-e2e2bf957f84",
//                         "product_meta": {
//                             "from": {
//                                 "id": "3a9c7bd4-e106-40fc-82e3-5433d4200f59",
//                                 "code": "PYN",
//                                 "name": "Payoneer",
//                                 "image": "https://ui-avatars.com/api/?background=random&name=N",
//                                 "status": 1,
//                                 "created_at": "3 Januari 2025 12:52:07",
//                                 "updated_at": null,
//                                 "price": {
//                                     "id": "c40979d5-fe1d-40fc-82e3-5433d4200f59",
//                                     "pricing_type": 0,
//                                     "pricing": 1250,
//                                     "fee_type": 0,
//                                     "fee": 250,
//                                     "currency": "USD"
//                                 },
//                                 "transfer_data": {
//                                     "id": "a300dab1-526a-4d7d-bbf9-996aef9508aa",
//                                     "type": "va",
//                                     "value": "9587245042",
//                                     "status": 1,
//                                     "created_at": "3 Januari 2025 12:54:05",
//                                     "updated_at": null
//                                 }
//                             },
//                             "to": {
//                                 "id": "c40979d5-fe1d-4fe1-aa8e-e2e2bf957f84",
//                                 "pricing_type": 0,
//                                 "pricing": 1000,
//                                 "fee_type": 0,
//                                 "fee": 500,
//                                 "currency": "USD",
//                                 "product": {
//                                     "id": "475740f4-e123-4e12-ab5c-29034d4e2a0b",
//                                     "code": "PYPL",
//                                     "name": "Paypal",
//                                     "image": "https://ui-avatars.com/api/?background=random&name=N"
//                                 }
//                             }
//                         },
//                         "amount": 29.5,
//                         "sub_total": 429.5
//                     }
//                 ],
//                 "created_at": "2025-02-09T23:46:05.000Z",
//                 "updated_at": "2025-02-10T00:09:39.000Z",
//                 "deleted_at": null
//             }

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
      discount: json['discount'],
      total: json['total'],
      transferMeta: json['transfer_meta'] != null
          ? TransferMeta.fromJson(json['transfer_meta'])
          : null,
      status: json['status'],
      note: json['note'],
      products: json['products'] != null
          ? (json['products'] as List).map((i) => Products.fromJson(i)).toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
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

  Products({
    this.id,
    this.rateId,
    this.productMeta,
    this.amount,
    this.subTotal,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      rateId: json['rate_id'],
      productMeta: json['product_meta'] != null
          ? ProductMeta.fromJson(json['product_meta'])
          : null,
      amount: json['amount'],
      subTotal: json['sub_total'],
    );
  }

  @override
  String toString() {
    return 'Products{id: $id, rateId: $rateId, productMeta: $productMeta, amount: $amount, subTotal: $subTotal}';
  }
}

class ProductMeta {
  final From? from;
  final To? to;

  ProductMeta({
    this.from,
    this.to,
  });

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
  final int? pricing;
  final int? feeType;
  final int? fee;
  final String? currency;
  final Product? product;

  To({
    this.id,
    this.pricingType,
    this.pricing,
    this.feeType,
    this.fee,
    this.currency,
    this.product,
  });

  factory To.fromJson(Map<String, dynamic> json) {
    return To(
      id: json['id'],
      pricingType: json['pricing_type'],
      pricing: json['pricing'],
      feeType: json['fee_type'],
      fee: json['fee'],
      currency: json['currency'],
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  @override
  String toString() {
    return 'To{id: $id, pricingType: $pricingType, pricing: $pricing, feeType: $feeType, fee: $fee, currency: $currency, product: $product}';
  }
}

class Product {
  final String? id;
  final String? code;
  final String? name;
  final String? image;

  Product({
    this.id,
    this.code,
    this.name,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, code: $code, name: $name, image: $image}';
  }
}

class From {
  final String? id;
  final String? code;
  final String? name;
  final String? image;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final Price? price;
  final TransferData? transferData;

  From({
    this.id,
    this.code,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.transferData,
  });

  factory From.fromJson(Map<String, dynamic> json) {
    return From(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      price: json['price'] != null ? Price.fromJson(json['price']) : null,
      transferData: json['transfer_data'] != null
          ? TransferData.fromJson(json['transfer_data'])
          : null,
    );
  }

  @override
  String toString() {
    return 'From{id: $id, code: $code, name: $name, image: $image, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, price: $price, transferData: $transferData}';
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
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  String toString() {
    return 'TransferData{id: $id, type: $type, value: $value, status: $status, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class Price {
  final String? id;
  final int? pricingType;
  final int? pricing;
  final int? feeType;
  final int? fee;
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
      pricingType: json['pricing_type'],
      pricing: json['pricing'],
      feeType: json['fee_type'],
      fee: json['fee'],
      currency: json['currency'],
    );
  }

  @override
  String toString() {
    return 'Price{id: $id, pricingType: $pricingType, pricing: $pricing, feeType: $feeType, fee: $fee, currency: $currency}';
  }
}

class TransferMeta {
  final String? id;
  final String? type;
  final String? value;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  TransferMeta({
    this.id,
    this.type,
    this.value,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory TransferMeta.fromJson(Map<String, dynamic> json) {
    return TransferMeta(
      id: json['id'],
      type: json['type'],
      value: json['value'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  String toString() {
    return 'TransferMeta{id: $id, type: $type, value: $value, status: $status, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
