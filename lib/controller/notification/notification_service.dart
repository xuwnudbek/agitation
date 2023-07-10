import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  var notiPlugin = FlutterLocalNotificationsPlugin();

  NotificationService() {
    init();
  }

  init() async {
    while (await Permission.notification.isDenied) {
      await Permission.notification.request();
      Future.delayed(Duration(milliseconds: 300));
    }

    var initSettings = InitializationSettings(
      android: AndroidInitializationSettings("@drawable/notification"),
      iOS: DarwinInitializationSettings(),
    );

    notiPlugin.initialize(initSettings);
  }

  showNotification({required int id, required String title, required String body, required bool isMsg}) async {
    var android = AndroidNotificationDetails("channel_Id", "channel_Name", importance: Importance.max, priority: Priority.high, playSound: true, enableVibration: true, enableLights: true, color: Colors.blue);
    var iOS = DarwinNotificationDetails();
    var notiDetails = NotificationDetails(android: android, iOS: iOS);

    await notiPlugin.show(id, "$title", "$body", notiDetails);
  }
}
