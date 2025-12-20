import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/helpers/utilities/notification_util.dart';
import 'package:student_management/app/modules/home/controllers/firebase_controller.dart';
import 'package:student_management/firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'package:device_preview/device_preview.dart';
import 'package:bot_toast/bot_toast.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stack) {}

  await NotificationUtil.initialize();
  FirebaseController().initNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => GetMaterialApp(
        title: Constants.STRINGS['STUDENT']!,
        initialRoute: Routes.SPLASH,
        getPages: AppPages.routes,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: Constants.theme,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
