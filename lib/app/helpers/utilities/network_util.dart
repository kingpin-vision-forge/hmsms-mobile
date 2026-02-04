import 'dart:async';
import 'dart:io';
import 'package:chopper/chopper.dart' as c;
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';

class NetworkUtils {
  static final NetworkUtils _instance = NetworkUtils._internal();
  factory NetworkUtils() => _instance;
  NetworkUtils._internal();

  static RxBool loading = false.obs;

  // Safe API call with error handling and retry functionality
  static Future<T?> safeApiCall<T>(
    Future<T> Function() apiCall, {
    bool showError = true,
  }) async {
    try {
      // Make API call and return the result if successful
      return await apiCall();
    } on SocketException catch (_) {
      // Handle connection failure (no network / DNS failure)
      if (showError) {
        botToastError(Constants.BOT_TOAST_MESSAGES['CONNECTION_FAILED']!);
      }
    } on ClientException catch (_) {
      // Handle HTTP client errors
      if (showError) {
        botToastError(Constants.BOT_TOAST_MESSAGES['PLEASE_CHECK_INTERNET']!);
      }
    } on TimeoutException catch (_) {
      // Handle timeout - likely slow network
      if (showError) {
        botToastError(Constants.BOT_TOAST_MESSAGES['SLOW_NETWORK']!);
      }
    } on c.Response catch (response) {
      // Handle HTTP response errors
      if (showError) {
        _handleHttpError(response.statusCode);
      }
    } catch (e) {
      // Handle other errors
      rethrow;
    }
    return null;
  }

  /// Handle HTTP status code errors with appropriate messages
  static void _handleHttpError(int statusCode) {
    if (statusCode >= 500) {
      // Server errors (5xx)
      botToastError(Constants.BOT_TOAST_MESSAGES['SERVER_ERROR']!);
    } else if (statusCode == 429) {
      // Too Many Requests - rate limited
      botToastError('Too many requests. Please wait a moment and try again.');
    } else if (statusCode >= 400) {
      // Client errors (4xx) - use default message or specific status code message
      final message = Constants.STATUS_CODE_MESSAGES[statusCode.toString()];
      if (message != null) {
        botToastError(message);
      } else {
        botToastError(Constants.BOT_TOAST_MESSAGES['PLEASE_CHECK_INTERNET']!);
      }
    }
  }

  /// Check if error is a network-related error
  static bool isNetworkError(dynamic error) {
    return error is SocketException ||
        error is ClientException ||
        error is TimeoutException;
  }
}