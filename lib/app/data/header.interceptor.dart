import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart' as c;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:student_management/app/data/api_athenticator.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/widget/no_internet.dart';

class HeaderInterceptor implements c.Interceptor {
  final ApiAuthenticator authenticator;

  HeaderInterceptor(this.authenticator);
  static String refreshTokenEndpoint =
      Constants.CONFIG['REFRESH_TOKEN_ENDPOINT']!;

  String getPlatformHeaderValue() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return '';
  }

  @override
  FutureOr<c.Response<BodyType>> intercept<BodyType>(
      c.Chain<BodyType> chain) async {
    //  Check internet connectivity before api calls
    var result = await checkInternetConnection();
    if (!result) {
      if (!Get.isDialogOpen!) {
        await Get.dialog(
          NoInternetDialog(isMainFlow: false),
          barrierDismissible: false,
        );
      }
      var result = await checkInternetConnection();
      if (!result) {
        throw SocketException(Constants.BOT_TOAST_MESSAGES['NO_INTERNET']!);
      }
    }
    // Skip processing if this is a refresh token request
    if (chain.request.uri.path.contains(refreshTokenEndpoint)) {
      // Add X-Franchise-Platform header
      final updatedRequest = c.applyHeader(
        chain.request,
        'X-Franchise-Platform',
        getPlatformHeaderValue(),
      );

      // Add Content-Type header
      final requestWithContentType = c.applyHeader(
        updatedRequest,
        'Content-Type',
        'application/json',
      );

      return chain.proceed(requestWithContentType);
    }

    // Check if the token is expired and refresh it if necessary
    if (await storage.hasData(Constants.STORAGE_KEYS['EXPIRES_IN']!) == true &&
        await isTokenExpired()) {
      final originalRequest = await authenticator.refreshToken(chain.request);

      // Proceed with the original request if the refresh token refresh was successful
      if (originalRequest != null) {
        // Add X-Franchise-Platform header
        final updatedRequest = c.applyHeader(
          originalRequest,
          'X-Franchise-Platform',
          getPlatformHeaderValue(),
        );

        // Add Content-Type header
        final requestWithContentType = c.applyHeader(
          updatedRequest,
          'Content-Type',
          'application/json',
        );

        return await chain.proceed(requestWithContentType);
      } else {
        // If the refresh token request failed, return an unauthorized response
        return c.Response<BodyType>(
          http.Response(
              Constants.STRINGS['UNAUTHORIZED']!, HttpStatus.unauthorized),
          null,
          error: jsonEncode({
            'message': Constants.STRINGS['UNAUTHORIZED']!,
            'statusCode': HttpStatus.unauthorized,
          }),
        );
      }
    } else {
      // If the token is not expired, proceed with applying the access token to the request
      String token =
          await storage.hasData(Constants.STORAGE_KEYS['ACCESS_TOKEN']!) == true
              ? await readFromStorage(Constants.STORAGE_KEYS['ACCESS_TOKEN']!)
              : '';

      // Add Authorization header
      final requestWithAuth =
          c.applyHeader(chain.request, 'Authorization', 'Bearer $token');
      // Add X-Franchise-Platform header
      final finalRequest = c.applyHeader(
        requestWithAuth,
        'X-Franchise-Platform',
        getPlatformHeaderValue(),
      );

      // Add Content-Type header
      final requestWithContentType = c.applyHeader(
        finalRequest,
        'Content-Type',
        'application/json',
      );

      return await chain.proceed(requestWithContentType);
    }
  }
}