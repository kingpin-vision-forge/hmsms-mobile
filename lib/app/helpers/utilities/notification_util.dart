import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationUtil {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true),
    ));
  }

  static Future<NotificationDetails> checkAppStatus(
      String soundName, String channelId, String channelName) async {
    NotificationDetails notificationDetails;
    AndroidNotificationDetails androidNotificationDetails;
    DarwinNotificationDetails iosNotificationDetails;

    androidNotificationDetails = AndroidNotificationDetails(
      channelId ?? 'default_channel_id',
      channelName, // Channel Name
      channelDescription: "Notifications for ${channelName}",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(soundName.toLowerCase()),
    );
    // iOS settings – ensure that 'presentSound' is true.
    iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: '$soundName.caf', // Make sure this file is in your iOS bundle.
    );
    notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    return notificationDetails;
  }
}