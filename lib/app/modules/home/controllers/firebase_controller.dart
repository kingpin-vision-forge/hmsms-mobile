import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/global.dart';
import 'package:student_management/app/modules/home/models/notification_message.dart';
import 'package:student_management/app/routes/app_pages.dart';

String device = '';
String fCMToken = '';

class FirebaseController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    initNotifications();
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Setup device type and (for iOS) get the APNS token
    if (Platform.isIOS) {
      device = 'ios';
      await _firebaseMessaging.getAPNSToken();
    } else if (Platform.isAndroid) {
      device = 'android';
    }

    // Get the FCM token and save it to storage
    fCMToken = (await _firebaseMessaging.getToken())!;
    await writeToStorage({Constants.STORAGE_KEYS['FCM_TOKEN']!: fCMToken});
    initPushNotification();
  }

  Future<void> initPushNotification() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );
    } else {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    _handleTerminatedStateMessages();
    _handleBackgroundStateMessages();
    _handleForegroundMessages();
  }

  void navigateToNotification() {
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  void _handleTerminatedStateMessages() async {
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) => _processMessage(message),
    );
  }

  void _handleBackgroundStateMessages() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      _processMessage(message);
    });
  }

  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) async {
      if (!await _validateUserSession()) return;
      // Mark the app status as 'foreground'
      await writeToStorage({'app_open_status': 'foreground'});
      final data = NotificationMessageModel.fromJson(message.data);
      if (data.type == 'bell-notification') {
        _handleBellAlertNotification(message);
      }
    });
  }

  Future<void> _processMessage(RemoteMessage? message) async {
    if (message == null || message.data.isEmpty) return;
    if (!await _validateUserSession()) return;
    await writeToStorage({'app_open_status': 'background'});
    final data = NotificationMessageModel.fromJson(message.data);
    if (data.type == 'bell-notification') {
      _handleBellAlertNotification(message);
    } else {
      try {
        _handleBellAlertNotification(message);
      } catch (e) {}
    }
  }

  Future<bool> _validateUserSession() async {
    final accessToken = await readFromStorage(
      Constants.STORAGE_KEYS['ACCESS_TOKEN']!,
    );
    if (accessToken == null || accessToken.toString().isEmpty) {
      Get.offNamed(Routes.LOGIN);
      botToastError(Constants.BOT_TOAST_MESSAGES['PLEASE_SIGNIN']!);
      return false;
    }
    return true;
  }

  void _handleBellAlertNotification(RemoteMessage message) async {
    final notification = message.notification;
    String appStatus = await readFromStorage('app_open_status') ?? 'background';
    if (notification != null) {
      if (appStatus == 'foreground') {
        _handleNewBellNotification();
        fetchNotification();
      } else {
        fetchNotification();
      }
    }
  }

  //new notification bot toast message
  void _handleNewBellNotification() {
    BotToast.showCustomText(
      onlyOne: true,
      duration: const Duration(seconds: 5),
      align: const Alignment(0, -0.9),
      toastBuilder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: 300, // Set the desired width here
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'New notification received',
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
