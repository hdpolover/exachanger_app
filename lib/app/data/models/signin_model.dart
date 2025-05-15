// {
//         "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjhkNjlmODcyLTIxYjctNDczYy04NTc5LTliNDdmOGY1MDg2NiIsImVtYWlsIjoibWFoZW5kcmFkd2lwdXJ3YW50b0BnbWFpbC5jb20iLCJuYW1lIjoibWFoZW5kcmEiLCJwZXJtaXNzaW9ucyI6eyJtb2JpbGUiOlt7ImtleSI6IjAiLCJhY2Nlc3MiOnRydWV9LHsia2V5IjoiMSIsImFjY2VzcyI6dHJ1ZX1dLCJhcHAiOltdfSwiZGF0ZSI6IjE5LzIvMjAyNSwgMDAuNTMuNDMiLCJleHBpcmVkIjoiMjAvMi8yMDI1LCAwMC41My40MyIsImlhdCI6MTczOTkwMTIyMywiZXhwIjoxNzM5OTg3NjIzLCJpc3MiOiJleGNoYW5nZXItdmVwYXktYnktbmdvZGluZ2luLWluZG9uZXNpYSJ9.GEyBlI9aUk-R3LdNc48GXZ0pcBf4cOAG8S-YNgrxlAU",
//         "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjhkNjlmODcyLTIxYjctNDczYy04NTc5LTliNDdmOGY1MDg2NiIsImVtYWlsIjoibWFoZW5kcmFkd2lwdXJ3YW50b0BnbWFpbC5jb20iLCJuYW1lIjoibWFoZW5kcmEiLCJwZXJtaXNzaW9ucyI6eyJtb2JpbGUiOlt7ImtleSI6IjAiLCJhY2Nlc3MiOnRydWV9LHsia2V5IjoiMSIsImFjY2VzcyI6dHJ1ZX1dLCJhcHAiOltdfSwiZGF0ZSI6IjE5LzIvMjAyNSwgMDAuNTMuNDMiLCJleHBpcmVkIjoiMjYvMi8yMDI1LCAwMC41My40MyIsImlhdCI6MTczOTkwMTIyMywiZXhwIjoxNzQwNTA2MDIzLCJpc3MiOiJleGNoYW5nZXItdmVwYXktYnktbmdvZGluZ2luLWluZG9uZXNpYSJ9.M_aDi6D-_75Nou1fYnjCg5EvtW5AYgANtcaJ5Os0CYY",
//         "data": {
//             "id": "8d69f872-21b7-473c-8579-9b47f8f50866",
//             "email": "mahendradwipurwanto@gmail.com",
//             "name": "mahendra",
//             "permissions": {
//                 "mobile": [
//                     {
//                         "key": "0",
//                         "access": true
//                     },
//                     {
//                         "key": "1",
//                         "access": true
//                     }
//                 ],
//                 "app": []
//             },
//             "date": "19/02/2025 00:53:43",
//             "expired": "20/02/2025 00:53:43"
//         },
//         "expired_in": 86400
//     }

class SigninModel {
  final String? accessToken;
  final String? refreshToken;
  final DataModel? data;
  final int? expiredIn;

  SigninModel({
    this.accessToken,
    this.refreshToken,
    this.data,
    this.expiredIn,
  });

  factory SigninModel.fromJson(Map<String, dynamic> json) {
    return SigninModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      data: json['data'] != null ? DataModel.fromJson(json['data']) : null,
      expiredIn: json['expired_in'],
    );
  }

  @override
  String toString() {
    return 'SigninModel{accessToken: $accessToken, refreshToken: $refreshToken, data: $data, expiredIn: $expiredIn}';
  }
}

class DataModel {
  final String? id;
  final String? email;
  final String? name;
  final String? role;
  final int? type;
  final PermissionsModel? permissions;
  final String? date;
  final String? expired;

  DataModel({
    this.id,
    this.email,
    this.name,
    this.role,
    this.type,
    this.permissions,
    this.date,
    this.expired,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
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

  @override
  String toString() {
    return 'Data{id: $id, email: $email, name: $name, permissions: $permissions, date: $date, expired: $expired}';
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

  @override
  String toString() {
    return 'Permissions{mobile: $mobile, app: $app}';
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

  @override
  String toString() {
    return 'Mobile{key: $key, access: $access}';
  }
}
