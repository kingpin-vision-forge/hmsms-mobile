
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/data/apis.dart';
import 'package:student_management/app/helpers/widget/custom_alert_dialog.dart';

class MailUtil {
  final ApiService _apiService = ApiService.create();

  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    ).hasMatch(email);
  }

  static showMailSentDialog(IconData icon, String title, String content,
      String cta, VoidCallback onBack) {
    Get.dialog(
        barrierDismissible: false,
        CustomAlertDialog(
            icon: icon,
            title: title,
            content: content,
            cta: cta,
            onBack: onBack));
  }

  // Send Email from Client List and Client Details
  // Future<void> sendEmail(List<String> emails, String subject, String body,
  //     List<String> cc, VoidCallback successCallback) async {
  //   if (emails.isEmpty) return;
  //   try {
  //     final mailPayload = {
  //       "notificationType": "email",
        
  //         'type': 'web',
  //         'subject': subject.trim().isNotEmpty ? subject.trim() : ' ',
  //         'message': body.trim().isNotEmpty
  //             ? body.trim().replaceAll('\n', '<br>')
  //             : ' ',
  //         'to': emails,
  //         // 'fse_email': userData['email'] ?? '',
  //         // 'fse_number': getPhoneNumber(userData),
  //         if (cc.isNotEmpty) ...{'cc': cc}
  //     };

  //     final res = await NetworkUtils.safeApiCall(
  //         () => _apiService.sendEmailNotify(mailPayload));
  //     if (res == null) return;
  //     if (res.isSuccessful) {
  //       showMailSentDialog(
  //           Icons.check_circle,
  //           capitalize(Constants.STRINGS['EMAIL']!),
  //           Constants.STRINGS['SENT_SUCCESSFULLY']!,
  //           Constants.STRINGS['DONE']!,
  //           successCallback);
  //     } else {
  //       botToastError(Constants.BOT_TOAST_MESSAGES['SEND_EMAIL_FAILED']!);
  //     }
  //   } catch (e) {
  //     errorUtil.handleAppError(
  //       apiName: 'sendEmail',
  //       error: e,
  //       displayMessage: Constants.BOT_TOAST_MESSAGES['SEND_EMAIL_FAILED']!,
  //     );
  //   }
  // }

  // Build signature spans for email in rich text
  List<TextSpan> buildSignatureSpans(Map<String, dynamic> userData) {
    List<String> lines = [];

    lines.add('Kind regards,\n');

    final fullName = (userData['username'] ?? '').toString().trim();
    if (fullName.isNotEmpty) lines.add(fullName);

    final phone = (userData['phone'] != null &&
            userData['phone'].toString().trim().isNotEmpty)
        ? userData['phone'].toString().trim()
        : (userData['phone_2'] != null &&
                userData['phone_2'].toString().trim().isNotEmpty)
            ? userData['phone_2'].toString().trim()
            : '';

    if (phone.isNotEmpty) lines.add(phone);

    final email = (userData['email'] ?? '').toString().trim();
    if (email.isNotEmpty) lines.add(email);

    final traderName = (userData['trader_name'] ?? '').toString().trim();
    if (traderName.isNotEmpty) lines.add(traderName);

    return [
      for (var i = 0; i < lines.length; i++)
        TextSpan(text: i == lines.length - 1 ? lines[i] : '${lines[i]}\n'),
    ];
  }

// Build signature for email in plain text
  String buildEmailSignature(Map<String, dynamic> userData) {
    List<String> signatureLines = [];
    final fullName = (userData['username'] ?? '').toString().trim();
    if (fullName.isNotEmpty) {
      signatureLines.add('Kind regards,\n');
      signatureLines.add(fullName);
    }

    final phone = (userData['phone'] != null &&
            userData['phone'].toString().trim().isNotEmpty)
        ? userData['phone'].toString().trim()
        : (userData['phone_2'] != null &&
                userData['phone_2'].toString().trim().isNotEmpty)
            ? userData['phone_2'].toString().trim()
            : '';

    if (phone.isNotEmpty) {
      signatureLines.add(phone);
    }

    final email = (userData['email'] ?? '').toString().trim();
    if (email.isNotEmpty) {
      signatureLines.add(email);
    }

    final traderName = (userData['trader_name'] ?? '').toString().trim();
    if (traderName.isNotEmpty) {
      signatureLines.add(traderName);
    }

    if (signatureLines.isEmpty) {
      return ''; // Optional: Return empty if nothing present
    }

    return '\n\n${signatureLines.join('\n')}';
  }
}