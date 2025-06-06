// Blockchain model based on the JSON response
class BlockchainModel {
  final String? id;
  final String? code;
  final String? name;
  final String? image;
  final int? feeType;
  final dynamic fee;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  BlockchainModel({
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
  factory BlockchainModel.fromJson(Map<String, dynamic> json) {
    return BlockchainModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      image: json['image'],
      feeType: _parseIntFromDynamic(json['fee_type']),
      fee: json['fee'],
      status: _parseStringFromDynamic(
        json['status'],
      ), // Handle both int and string
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

  static String? _parseStringFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is int) return value.toString(); // Convert int to string
    return value.toString(); // Fallback: convert anything to string
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['image'] = this.image;
    data['fee_type'] = this.feeType;
    data['fee'] = this.fee;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'BlockchainModel{id: $id, code: $code, name: $name, status: $status}';
  }
}
