import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as _get;
import 'package:http/io_client.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/mail_util.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/models/refresh_token.dart';
import 'package:student_management/app/routes/app_pages.dart';

/// Authenticator for handling API authentication and token refresh logic.
class ApiAuthenticator extends Authenticator {
  /// Completer to ensure only one token refresh request is handled at a time.
  Completer<bool>? _tokenRefreshCompleter;
  final String baseUrl;

  ApiAuthenticator({required this.baseUrl});

  /// The URL endpoint for refreshing the token.
  static String refreshTokenEndpoint =
      Constants.CONFIG['REFRESH_TOKEN_ENDPOINT']!;

  /// Fetches the refresh token from persistent storage.
  // Future<String?> _getRefreshTokenFromStorage() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(Constants.STORAGE_KEYS['REFRESH_TOKEN']!);
  // }

  /// Fetches the access token from persistent storage.
  Future<String?> _getAccessTokenFromStorage() async {
    return await readFromStorage(Constants.STORAGE_KEYS['ACCESS_TOKEN']!);
  }

  /// Saves the access token to persistent storage.
  Future<void> _saveAccessTokenToStorage(String accessToken) async {
    await writeToStorage(
        {Constants.STORAGE_KEYS['ACCESS_TOKEN']!: accessToken});
  }

  /// Checks if the request is made to the refresh token endpoint.
  bool _isRefreshTokenRequest(Request request) {
    return request.url.toString().contains(refreshTokenEndpoint);
  }

  _handleUnauthorizedRequest() async {
    _finishTokenRefresh(complete: false);
    await _clearTokens();
    return null;
  }

  @override
  FutureOr<Request?> authenticate(Request request, Response response,
      [Request? originalRequest]) async {
    _tokenRefreshCompleter?.complete(false);
    print('i am api req $request');
    print('i am api res $response');
    // Skip processing if this is a refresh token request
    if (_isRefreshTokenRequest(request)) {
      if (response.statusCode == HttpStatus.unauthorized) {
        await _handleUnauthorizedRequest();
      }
      return null;
    }

    // Handle 401 responses
    if (response.statusCode == HttpStatus.unauthorized) {
      // If refresh is in progress, wait for it
      if (_tokenRefreshCompleter != null &&
          !_tokenRefreshCompleter!.isCompleted) {
        final isTokenRefreshed = await _tokenRefreshCompleter?.future;
        if (isTokenRefreshed ?? false) {
          return _applyAuthHeader(request);
        }
        return null;
      }

      _tokenRefreshCompleter = Completer<bool>();
      // Call refresh token api
      return await refreshToken(originalRequest);
    }

    return null;
  }

  refreshToken(Request? originalRequest) async {
    // Create a separate client for refresh token request
    final chopperClient = ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      services: [
        ApiService.create(),
      ],
      converter: const JsonConverter(),
      client: IOClient(HttpClient()
        ..connectionTimeout = Constants.CONFIG['CONNECTION_TIMEOUT']),
    );

    try {
      final refreshToken =
          await readFromStorage(Constants.STORAGE_KEYS['REFRESH_TOKEN']!);
      final deviceId =
          await readFromStorage(Constants.STORAGE_KEYS['DEVICE_ID']!);
      if (refreshToken == null) {
        _finishTokenRefresh(complete: false);
        return null;
      }

      final apiService = chopperClient.getService<ApiService>();
      final response = await NetworkUtils.safeApiCall(() => apiService
          .refreshToken({'refreshToken': refreshToken, 'deviceId': deviceId}));
      if (response == null) return;
      if (response.isSuccessful) {
        if (response.body != null &&
            response.body.runtimeType != String &&
            response.body['data'] != null &&
            response.body['success'] == true) {
          final refreshTokenData =
              RefreshTokenData.fromJson(response.body['data']);
          if (refreshTokenData == null) {
            _finishTokenRefresh(complete: false);
            await _handleUnauthorizedRequest();
          }
          final accessToken = refreshTokenData.accessToken ?? '';
          if (accessToken.isEmpty) {
            _finishTokenRefresh(complete: false);
            await _handleUnauthorizedRequest();
          }

          await writeToStorage(
            {
              Constants.STORAGE_KEYS['ACCESS_TOKEN']!: accessToken,
              Constants.STORAGE_KEYS['EXPIRES_IN']!: refreshTokenData.expiresIn,
            },
          );
          final expiresIn = refreshTokenData.expiresIn;
          await storeTokenExpiry(expiresIn);
          if (accessToken.isNotEmpty) {
            await _saveAccessTokenToStorage(accessToken);
            _finishTokenRefresh();
            return _applyAuthHeader(originalRequest!);
          } else {
            // No access Token
            await _handleUnauthorizedRequest();
          }
        } else {
          // response object is null
          // Unauthorized condition if refresh token is invalid
          if (response.statusCode == HttpStatus.unauthorized) {
            _handleUnauthorizedRequest();
            return null;
          }

          // Server error to check if error is null
          final rawError = response.error?.toString();
          if (rawError == null || rawError.toLowerCase() == 'null') return;

          // Try to decode error string
          final decoded = jsonDecode(rawError);
          // If error is not a map, return
          if (decoded is! Map<String, dynamic>) return;
          serverError(response, () => refreshToken(originalRequest));
        }
      }
      // Unauthorized condition if refresh token is invalid
      else if (response.statusCode == HttpStatus.unauthorized) {
        await _handleUnauthorizedRequest();
      } else {
        serverError(response, () => refreshToken(originalRequest));
      }
    } catch (e) {
      errorUtil.handleAppError(
          apiName: 'refreshToken',
          error: e,
          displayMessage:
              Constants.BOT_TOAST_MESSAGES['TOKEN_REFRESH_FAILED']!);
    } finally {
      chopperClient.dispose();
    }
  }

  void _finishTokenRefresh({bool complete = true}) {
    _tokenRefreshCompleter?.complete(complete);
    _tokenRefreshCompleter = null;
  }

  Future<void> _clearTokens() async {
    MailUtil.showMailSentDialog(
        Icons.error,
        Constants.STRINGS['SESSION_ERROR_TITLE']!,
        Constants.STRINGS['SESSION_ERROR_DESCRIPTION']!,
        Constants.STRINGS['CONTINUE']!, () async {
      await eraseStorage();
      // Check Internet Connection
      /*
      If no internet connection,
      delete token gives error while deleting fcm token
      */
      _get.Get.offAllNamed(Routes.LOGIN);
      var result = await checkInternetConnection();
      if (result) {
        await FirebaseMessaging.instance.deleteToken();
      }
    });
  }

  Future<Request> _applyAuthHeader(Request request) async {
    final accessToken = await _getAccessTokenFromStorage();
    if (accessToken != null) {
      return applyHeader(
        request,
        'Authorization',
        'Bearer $accessToken',
      );
    }
    return request;
  }
}