// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'apis.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ApiService extends ApiService {
  _$ApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ApiService;

  @override
  Future<Response<dynamic>> login(Map<String, dynamic> credentials) {
    final Uri $url = Uri.parse('api/auth/login');
    final $body = credentials;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> refreshToken(Map<String, dynamic> query) {
    final Uri $url = Uri.parse('api/auth/refresh');
    final $body = query;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> signOut(Map<String, dynamic> query) {
    final Uri $url = Uri.parse('api/auth/logout');
    final $body = query;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createStudent(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('api/students');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
