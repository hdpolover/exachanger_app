class SignUpResponseModel {
  final String? status;
  final int? code;
  final SignUpData? data;
  final String? message;

  SignUpResponseModel({this.status, this.code, this.data, this.message});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      status: json['status'],
      code: json['code'],
      data: json['data'] != null ? SignUpData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class SignUpData {
  final String? signature;

  SignUpData({this.signature});

  factory SignUpData.fromJson(Map<String, dynamic> json) {
    String? extractedSignature;

    // Try to extract signature from the JSON structure
    // The backend returns the signature as the key of the data map
    if (json.isNotEmpty) {
      // First check if there's a direct 'signature' field
      if (json.containsKey('signature')) {
        extractedSignature = json['signature'];
      } else {
        // Otherwise, the signature is the first key of the data map
        extractedSignature = json.keys.first;
      }
    }

    print('🔍 SignUpData: Extracting signature from JSON: $json');
    print('🔍 SignUpData: Extracted signature: "$extractedSignature"');

    return SignUpData(signature: extractedSignature);
  }

  Map<String, dynamic> toJson() {
    return {'signature': signature};
  }
}

class SetupPinRequest {
  final String signature;
  final String pin;

  SetupPinRequest({required this.signature, required this.pin});
  Map<String, dynamic> toJson() {
    return {
      'signature': signature,
      'pin':
          int.tryParse(pin) ??
          pin, // Convert to int if possible, fallback to string
    };
  }
}

class SetupPinResponseModel {
  final String? status;
  final int? code;
  final SetupPinData? data;
  final String? message;

  SetupPinResponseModel({this.status, this.code, this.data, this.message});

  factory SetupPinResponseModel.fromJson(Map<String, dynamic> json) {
    return SetupPinResponseModel(
      status: json['status'],
      code: json['code'],
      data: json['data'] != null ? SetupPinData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class SetupPinData {
  final String? accessToken;
  final String? refreshToken;
  final UserDataModel? userData;
  final int? expiredIn;

  SetupPinData({
    this.accessToken,
    this.refreshToken,
    this.userData,
    this.expiredIn,
  });

  factory SetupPinData.fromJson(Map<String, dynamic> json) {
    return SetupPinData(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      userData: json['data'] != null
          ? UserDataModel.fromJson(json['data'])
          : null,
      expiredIn: json['expired_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'data': userData?.toJson(),
      'expired_in': expiredIn,
    };
  }
}

class UserDataModel {
  final String? id;
  final String? email;
  final String? name;
  final String? role;
  final int? type;
  final PermissionsModel? permissions;
  final String? date;
  final String? expired;

  UserDataModel({
    this.id,
    this.email,
    this.name,
    this.role,
    this.type,
    this.permissions,
    this.date,
    this.expired,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
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
}

class PermissionsModel {
  final List<MobilePermissionModel>? mobile;
  final List<dynamic>? app;

  PermissionsModel({this.mobile, this.app});

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsModel(
      mobile: json['mobile'] != null
          ? List<MobilePermissionModel>.from(
              json['mobile'].map((x) => MobilePermissionModel.fromJson(x)),
            )
          : null,
      app: json['app'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'mobile': mobile?.map((x) => x.toJson()).toList(), 'app': app};
  }
}

class MobilePermissionModel {
  final String? key;
  final bool? access;

  MobilePermissionModel({this.key, this.access});

  factory MobilePermissionModel.fromJson(Map<String, dynamic> json) {
    return MobilePermissionModel(key: json['key'], access: json['access']);
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'access': access};
  }
}
