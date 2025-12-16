import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_management/app/helpers/constants.dart';
import 'package:student_management/app/modules/bottom_navbar/views/bottom_navbar_view.dart';
import 'app/routes/app_pages.dart';
import 'package:device_preview/device_preview.dart';
import 'package:bot_toast/bot_toast.dart';

@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();

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
