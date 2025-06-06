// Transfer data model based on the JSON response
class TransferDataModel {
  final String? id;
  final String? type;
  final String? value;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  TransferDataModel({
    this.id,
    this.type,
    this.value,
    this.status,
    this.createdAt,
    this.updatedAt,
  });
  factory TransferDataModel.fromJson(Map<String, dynamic> json) {
    return TransferDataModel(
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['value'] = this.value;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'TransferDataModel{id: $id, type: $type, value: $value, status: $status}';
  }
}
