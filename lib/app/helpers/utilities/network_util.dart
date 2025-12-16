import 'dart:async';
import 'dart:io';
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
    } on ClientException {
      // Handle no internet connection
      botToastError(Constants.BOT_TOAST_MESSAGES['PLEASE_CHECK_INTERNET']!);
    } on SocketException {
      // Handle no internet connection
      botToastError(Constants.BOT_TOAST_MESSAGES['PLEASE_CHECK_INTERNET']!);
    } on TimeoutException {
      // Handle timeout
      botToastError(Constants.BOT_TOAST_MESSAGES['REQUEST_TIMED_OUT']!);
    } catch (e) {
      // Handle other errors
      rethrow;
    }
    return null;
  }
}