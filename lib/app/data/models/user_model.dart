class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? role;
  final int? type;
  PermissionsModel? permissions;
  final String? date;
  final String? expired;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.role,
    this.type,
    this.permissions,
    this.date,
    this.expired,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      type: json['type'],
      permissions: json['permissions'] != null
          ? PermissionsModel.fromJson(json['permissions'])
          : null,
      date: json['date'],
      expired: json['expired'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'type': type,
      'permissions': permissions?.toJson(),
      'date': date,
      'expired': expired,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, name: $name, role: $role, type: $type, permissions: $permissions, date: $date, expired: $expired}';
  }
}

class PermissionsModel {
  final List<MobileModel>? mobile;
  final List<dynamic>? app;

  PermissionsModel({
    this.mobile,
    this.app,
  });

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsModel(
      mobile: json['mobile'] != null
          ? List<MobileModel>.from(
              json['mobile'].map((x) => MobileModel.fromJson(x)))
          : null,
      app: json['app'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile?.map((e) => e.toJson()).toList(),
      'app': app,
    };
  }

  @override
  String toString() {
    return 'PermissionsModel{mobile: $mobile, app: $app}';
  }
}

class MobileModel {
  final String? key;
  final bool? access;

  MobileModel({
    this.key,
    this.access,
  });

  factory MobileModel.fromJson(Map<String, dynamic> json) {
    return MobileModel(
      key: json['key'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'access': access,
    };
  }

  @override
  String toString() {
    return 'MobileModel{key: $key, access: $access}';
  }
}
