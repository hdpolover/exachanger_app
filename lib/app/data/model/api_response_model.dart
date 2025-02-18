class ApiResponseModel {
  final String? status;
  final int? code;
  final String? message;
  final dynamic data;

  ApiResponseModel({this.status, this.code, this.message, this.data});

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }
}
