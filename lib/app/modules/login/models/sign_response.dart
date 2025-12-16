import 'package:student_management/app/modules/login/models/user_response.dart';

class SignInResponse {
  final bool success;
  final int? statusCode;
  final String? message;
  final SignInData? data;

  SignInResponse({
    required this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? SignInData.fromJson(json['data']) : null,
    );
  }
}

class SignInData {
  final String? accessToken;
  final String? refreshToken;
  final UserDetails? user;

  SignInData({this.accessToken, this.refreshToken, this.user});

  factory SignInData.fromJson(Map<String, dynamic> json) {
    return SignInData(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: json['user'] != null ? UserDetails.fromJson(json['user']) : null,
    );
  }
}
