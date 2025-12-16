import 'package:student_management/app/helpers/constants.dart';

class RefreshTokenResponse {
  final bool success;
  final int statusCode;
  final RefreshTokenData? data;

  RefreshTokenResponse({
    required this.success,
    required this.statusCode,
    this.data,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      data:
          json['data'] != null ? RefreshTokenData.fromJson(json['data']) : null,
    );
  }
}

class RefreshTokenData {
  final String accessToken;
  final String expiresIn;

  RefreshTokenData({required this.accessToken, required this.expiresIn});

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) {
    return RefreshTokenData(
      expiresIn:
          json['accessTokenExpiresAt'] ?? Constants.CONFIG['DEFAULT_ACCESS_TOKEN_EXPIRY']!,
      accessToken: json['accessToken'] ?? '',
    );
  }
}