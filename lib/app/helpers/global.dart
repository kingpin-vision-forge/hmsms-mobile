import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/helpers/utilities/error_util.dart';
import 'package:student_management/app/helpers/utilities/network_util.dart';
import 'package:student_management/app/helpers/utilities/secure_storage.dart';
import 'package:student_management/app/helpers/widget/errorScreen.dart';
import 'package:student_management/services/internet_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:chopper/chopper.dart' as c;
import 'package:intl/intl.dart';

final ApiService _apiService = ApiService.create();

var codeLength = 0.obs;
final isCodeButtonEnabled = false.obs;
var isRetry = false.obs;
// var notificationList = <NotificationItem>[].obs;
var unread = 0.obs;
var clientCountryCode = Constants.STRINGS['DEFAULT_DIAL_CODE']!.obs;
var isFetchingCountryCode = false.obs;
var currency = '\$';
var fseId = 17227;
var userId = '';
var userData = readFromStorage(Constants.STORAGE_KEYS['USER_DATA']!);
var isLoading = false.obs;
var isFetchingTemplate = false.obs;
var divisionUrl = '';
var device = '';
var page = 1.obs;
var limit = 10.obs;

Map<String, dynamic> fseData = {
  'franchisee_id': 17227,
  'fms_fse_id': 176328,
  'trader_name': "Jim's Car Detailing (Richmond) - 2DD7",
  'account_number': "83939847",
  'bank_account_name': "Sarfy &",
  'bsb': "778990",
  'business_address': "73 Frontier Av, Marsden Park 2765 NSW",
  'business_email': "shahidpeerzade761@gmail.com",
  'company': "Vari & Viha Pty Ltd",
  'country': "AU",
  'division': "Car Detailing",
  'file_id': "",
  'first_name': "6706cd9",
  'gst_rate': "10.00",
  'phone_1': "0483934306",
  'time_zone': "Australia/Sydney",
};

// Global Util Instances
// DownloadUtil downloadUtil = DownloadUtil();
// DetailDownloadUtil detailDownloadUtil = DetailDownloadUtil();
// ReceiptDownloadUtil receiptDownloadUtil = ReceiptDownloadUtil();
SecureStorage storage = SecureStorage();
ErrorUtil errorUtil = ErrorUtil();
// ClientSelectionUtil clientsLogicCtrl = ClientSelectionUtil();

setUserData() async {
  userData = await readFromStorage(Constants.STORAGE_KEYS['USER_DATA']!);
  userId = userData['id'];
}

//validation for mfacode
onCodeChanged(String value) {
  codeLength.value = value.length;
  isCodeButtonEnabled.value = value.length == 6;
}

writeToStorage(Map<String, dynamic> data) {
  data.forEach((key, value) async {
    await storage.write(key, value);
  });
}

readFromStorage(String key) async {
  return await storage.read(key);
}

eraseStorage() async {
  // Store permission page shown value before erasing storage
  var permissionPageShown = await readFromStorage(
    Constants.STORAGE_KEYS['PERMISSION_PAGE_SHOWN']!,
  );
  // Erase storage
  await storage.erase();
  /* Write permission page shown value back to storage,
  Only showing permission page if it was shown before
  */
  await writeToStorage({
    Constants.STORAGE_KEYS['PERMISSION_PAGE_SHOWN']!: permissionPageShown,
  });
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String getFseFullName(Map<String, dynamic> userData) {
  final fullName = (userData['username'] ?? '').toString().trim();
  return fullName.isNotEmpty ? fullName : 'N/A';
}

String getPhoneNumber(Map<String, dynamic> userData) {
  final phone1 = userData['phone']?.toString();

  if (phone1 != null && phone1.isNotEmpty) {
    return phone1;
  }
  return '';
}

//validation for username
String? validateUsername(String value) {
  if (value.isEmpty) {
    return 'Email cannot be empty';
  }

  // simple email regex
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email address';
  }

  return null;
}

String clientFormatTimeOfDay(TimeOfDay time) {
  if (time == null) {
    return '';
  }

  final hour = time.hour > 12
      ? time.hour - 12
      : (time.hour == 0 ? 12 : time.hour);
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'pm' : 'am';

  return '$hour:$minute $period';
}

//convert timeofday
String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0
      ? 12
      : time.hourOfPeriod; // Adjust hour for 12-hour format
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'am' : 'pm';

  return '$hour:$minute $period';
}

//convert the time string
TimeOfDay parseTimeString(String timeString) {
  // Split the string into time and period (AM/PM)
  final parts = timeString.split(' ');
  final timeParts = parts[0].split(':');

  // Parse the hour and minute
  int hour = int.parse(timeParts[0]);
  final int minute = int.parse(timeParts[1]);

  // Adjust hour based on AM/PM
  if (parts[1].toLowerCase() == 'pm' && hour != 12) {
    hour += 12; // Convert to 24-hour format
  } else if (parts[1].toLowerCase() == 'am' && hour == 12) {
    hour = 0; // Midnight case
  }

  return TimeOfDay(hour: hour, minute: minute);
}

botToastError(String message) {
  BotToast.showText(
    text: message,
    textStyle: TextStyle(color: AppColors.secondaryColor),
    duration: const Duration(seconds: 3),
    align: const Alignment(0, -0.8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}

botToastSuccess(String message) {
  BotToast.showText(
    text: message,
    textStyle: const TextStyle(color: AppColors.secondaryColor),
    contentColor: AppColors.primaryColor,
    duration: const Duration(seconds: 3),
    align: const Alignment(0, -0.8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}

scrollListener(ScrollController controller, Function fetchList) {
  controller.addListener(() {
    if (controller.position.pixels >=
            controller.position.maxScrollExtent - 100 &&
        controller.position.userScrollDirection == ScrollDirection.reverse) {
      fetchList(); // Only trigger pagination when scrolled to bottom
    }
  });
}

storeTokenExpiry(String expiresIn) async {
  final now = DateTime.now().toUtc();

  // Parse ISO8601 datetime string
  final expiryDate = DateTime.parse(expiresIn).toUtc();

  // Optional: get the duration from now (in seconds or millis)
  final expiryTimeMillis = expiryDate.millisecondsSinceEpoch;

  await writeToStorage({
    Constants.STORAGE_KEYS['EXPIRES_IN']!: expiryTimeMillis,
  });
}

Future<bool> isTokenExpired() async {
  try {
    final expiresIn =
        await storage.hasData(Constants.STORAGE_KEYS['EXPIRES_IN']!) == true
        ? await readFromStorage(Constants.STORAGE_KEYS['EXPIRES_IN']!)
        : null;
    if (expiresIn == null) return true;

    final expiryMillis = int.tryParse(expiresIn.toString());
    if (expiryMillis == null) return true;

    final nowMillis = DateTime.now().toUtc().millisecondsSinceEpoch;

    return nowMillis >= expiryMillis;
  } catch (e) {
    // Assuming expired if parsing fails
    return true;
  }
}

serverError(c.Response res, Function() callback) {
  final dynamic error = res.error;
  if (error == null || error.toString().toLowerCase() == 'null') return;
  try {
    // Try to decode error string
    final Map<String, dynamic> errorMap = _parseErrorToMap(error);
    final int statusCode = res.statusCode;

    // If status code is 408,502,503, 504 show retry screen
    if (_shouldShowRetryScreen(statusCode)) {
      Get.to(Error503Screen(retryCallback: callback));
      return;
    }

    switch (statusCode) {
      case 400:
        showBotToastError(
          (errorMap['message']?.toString() ?? '').trim(),
          Constants.STATUS_CODE_MESSAGES['400']!,
        );
        break;

      case 401:
        if (errorMap['message'] != null &&
            errorMap['message'] is String &&
            errorMap['message'].toString().isNotEmpty &&
            errorMap['message'].toString() !=
                Constants.STRINGS['UNAUTHORIZED']!) {
          botToastError(errorMap['message']);
        }
        break;

      case 403:
        showBotToastError(
          (errorMap['message']?.toString() ?? '').trim(),
          Constants.STATUS_CODE_MESSAGES['403']!,
        );
        break;

      case 404:
        showBotToastError(
          (errorMap['message']?.toString() ?? '').trim(),
          Constants.STATUS_CODE_MESSAGES['404']!,
        );
        break;

      case 500:
        // Passing empty string as message to show default error message
        showBotToastError('', Constants.STATUS_CODE_MESSAGES['500']!);
        break;

      default:
        if (errorMap['message'] != null) {
          botToastError(errorMap['message']);
        } else {
          botToastError(Constants.BOT_TOAST_MESSAGES['SERVER_PROBLEM']!);
        }
        break;
    }
  } catch (e) {
    botToastError(Constants.BOT_TOAST_MESSAGES['SERVER_PROBLEM']!);
  }
}

// Based on the provided status code,
// determine if a retry screen should be shown
bool _shouldShowRetryScreen(int statusCode) {
  // 408- Request Timeout
  // 502- Bad Gateway
  // 503- Service Unavailable
  // 504- Gateway Timeout
  const retryStatusCodes = [408, 502, 503, 504];
  return retryStatusCodes.contains(statusCode);
}

// Show bot toast error with fallback
void showBotToastError(dynamic message, String fallback) {
  final String msg = message?.toString().trim() ?? '';
  botToastError(msg.isNotEmpty ? msg : fallback);
}

/// Tries to parse the error into a Map<String, dynamic>
Map<String, dynamic> _parseErrorToMap(dynamic error) {
  if (error is Map<String, dynamic>) return error;

  if (error is String) {
    try {
      final decoded = jsonDecode(error);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      // Not a JSON string; return empty map
      return {};
    }
  }

  return {};
}

Future<bool> checkInternetConnection() async {
  await Future.delayed(const Duration(milliseconds: 100));
  InternetConnectivityService internetConnectivityService =
      Get.isRegistered<InternetConnectivityService>()
      ? Get.find<InternetConnectivityService>()
      : Get.put(InternetConnectivityService(), permanent: true);
  return await internetConnectivityService.checkInternetConnectivity();
}

double parseGst(dynamic value) {
  final parsed = double.tryParse(value?.toString() ?? '');
  if (parsed == null) return 0.0;
  return double.parse(parsed.toStringAsFixed(2));
}

/// Formats a number as a string with commas and two decimal places (e.g., 12,345.67)
String formatAmount(dynamic value) {
  if (value == null) return '0.00';
  double? number;
  if (value is String) {
    number = double.tryParse(value.replaceAll(',', ''));
  } else if (value is num) {
    number = value.toDouble();
  }
  if (number == null) return '0.00';
  final formatter = NumberFormat('#,##0.00');
  return formatter.format(number);
}

// Convert TimeOfDay to total minutes since midnight (for 24-hour comparisons)
int convertToMinutes(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}

//job start time format
String jobFormatDate(String date) {
  try {
    DateTime parsedDate = DateTime.parse(date);

    String formattedDate = DateFormat("d MMM yyyy").format(parsedDate);

    return formattedDate;
  } catch (e) {
    return ' ';
  }
}

//date format
String formatDate(String date) {
  try {
    DateTime parsedDate = DateTime.parse(date);

    String formattedDate = DateFormat("d MMM, hh:mm a").format(parsedDate);
    formattedDate = formattedDate.replaceAll('AM', 'am').replaceAll('PM', 'pm');

    return formattedDate;
  } catch (e) {
    return ' ';
  }
}

// Utility function to format date to "Monday 24 Feb 2025" format
String formatAlertDate(String dateString) {
  try {
    DateTime date = DateTime.parse(dateString);

    return DateFormat('EEEE dd MMM yyyy').format(date);
  } catch (e) {
    return '--';
  }
}

// Utility function to format backend time to AM/PM format
String formatTimeAlerts(String timeString) {
  try {
    final parts = timeString.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);

    // Create DateTime object for formatting
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, hours, minutes);

    return DateFormat('hh:mm a').format(dateTime).toLowerCase();
  } catch (e) {
    return '--:--';
  }
}

Future<void> fetchNotification({bool isLoadMore = false}) async {
  // if (isLoadMore) {
  //   page.value += 1; // Increment page when loading more
  // } else {
  //   page.value = 1; // Reset page on refresh
  //   notificationList.clear(); // Clear list for fresh data
  // }

  // try {
  //   isLoading.value = true;
  //   c.Response? res = await NetworkUtils.safeApiCall(() =>
  //       _apiService.fetchNotification(limit: limit.value, page: page.value));
  //   if (res == null) return;
  //   if (res.isSuccessful) {
  //     if (res.body != null &&
  //         res.body.runtimeType != String &&
  //         res.body['data'] != null &&
  //         res.body['success'] == true) {
  //       final response = NotificationFetchResponse.fromJson(res.body);
  //       notificationList.addAll(response.data ?? <NotificationItem>[]);
  //       unread.value = int.parse(response.unreadNotificationCount ?? '0');
  //     }
  //   } else {
  //     serverError(res, () => fetchNotification(isLoadMore: isLoadMore));
  //   }
  // } catch (e) {
  //   errorUtil.handleAppError(
  //     apiName: 'fetchNotification',
  //     error: e,
  //     displayMessage:
  //         Constants.BOT_TOAST_MESSAGES['FAILED_NOTIFICATION_FETCH']!,
  //   );
  // } finally {
  //   isLoading.value = false;
  // }
}

// fetch country code
// Future<Franchisee?> fetchCountryCode() async {
//   try {
//     isFetchingCountryCode.value = true;

//     // Prepare settings payload with FSE ID
//     Map<String, dynamic> payload = {
//       'fms_fse_id': fseData['fms_fse_id'].toString(),
//       'selected_fields': ['country_dial_code']
//     };
//     // Request franchisee settings
//     c.Response? res =
//         await NetworkUtils.safeApiCall(() => _apiService.settings(payload));
//     if (res == null) return null;

//     // Handle successful response
//     if (res.isSuccessful) {
//       // Validate response structure
//       if (res.body != null &&
//           res.body.runtimeType != String &&
//           res.body['data'] != null &&
//           res.body['success'] == true) {
//         final response = Franchisee.fromJson(res.body['data']);
//         clientCountryCode.value = response.countryCode;
//         await writeToStorage({
//           Constants.STORAGE_KEYS['COUNTRY_DIAL_CODE']!: clientCountryCode.value,
//         });
//       }
//     } else {
//       // Handle API errors
//       serverError(res, () => fetchCountryCode());
//     }
//   } catch (e) {
//     // Handle unexpected errors
//     // botToastError(Constants.BOT_TOAST_MESSAGES['DEFAULT_ERROR']!);
//   } finally {
//     isFetchingCountryCode.value = false;
//   }
//   return null;
// }

// SignOut function
signOut() async {
  // if (Platform.isIOS) {
  //   device = 'ios';
  // } else if (Platform.isAndroid) {
  //   device = 'android';
  // } else {
  //   device = '';
  // }

  Map<String, dynamic> payload = {
    // 'accessToken':
    //     await readFromStorage(Constants.STORAGE_KEYS['ACCESS_TOKEN']!),
    'identifier': await readFromStorage(Constants.STORAGE_KEYS['USERNAME']!),
    // 'deviceId': await readFromStorage(Constants.STORAGE_KEYS['DEVICE_ID']!),
  };
  try {
    c.Response? res = await NetworkUtils.safeApiCall(
      () => _apiService.signOut(payload),
    );
    if (res == null) return;
    if (res.isSuccessful) {
      await eraseStorage();
      botToastSuccess(Constants.BOT_TOAST_MESSAGES['SIGNED_OUT']!);
      Get.offAllNamed('/login');
    } else {
      await eraseStorage();
      Get.offAllNamed('/login');
      botToastSuccess(Constants.BOT_TOAST_MESSAGES['SIGNED_OUT']!);
    }
  } catch (e) {
    var result = await checkInternetConnection();
    if (result) {
      await eraseStorage();
      Get.offAllNamed('/login');
      botToastSuccess(Constants.BOT_TOAST_MESSAGES['SIGNED_OUT']!);
    } else {
      botToastError(Constants.BOT_TOAST_MESSAGES['NO_INTERNET']!);
    }
  }
}
