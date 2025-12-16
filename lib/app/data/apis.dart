import 'dart:io';
// import 'package:student_management/app/data/api_authenticator.dart';
import 'package:student_management/app/data/header.interceptor.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:http/io_client.dart';
import 'package:chopper/chopper.dart';
// import 'package:ultra/app/data/refresh.interceptor.dart';
part 'apis.chopper.dart';

String apiBaseUrl = 'https://sms-api-dev.up.railway.app/';

@ChopperApi(baseUrl: 'api')
abstract class ApiService extends ChopperService {
  @POST(path: '/auth/login')
  Future<Response> login(@Body() Map<String, dynamic> credentials);

  @POST(path: '/auth/refresh')
  Future<Response> refreshToken(@Body() Map<String, dynamic> query);

  @POST(path: '/auth/logout')
  Future<Response> signOut(@Body() Map<String, dynamic> query);

  @POST(path: '/students')
  Future<Response> createStudent(@Body() Map<String, dynamic> body);

  static ApiService create() {
    // final authenticator = ApiAuthenticator(baseUrl: apiBaseUrl);
    final client = ChopperClient(
      baseUrl: Uri.parse(apiBaseUrl),
      services: [_$ApiService()],
      converter: const JsonConverter(),
      // authenticator: authenticator,
      // interceptors: [HeaderInterceptor(authenticator)],
      client: IOClient(
        HttpClient()
          ..connectionTimeout = Constants.CONFIG['CONNECTION_TIMEOUT'],
      ),
    );
    return _$ApiService(client);
  }
}
