// lib/features/auth/models/sign_in_response.dart
class SignInResponse {
  final String token;
  final String refreshToken;

  SignInResponse({
    required this.token,
    required this.refreshToken,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }
}
