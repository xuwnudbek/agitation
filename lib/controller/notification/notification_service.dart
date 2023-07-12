import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
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
      android: AndroidInitializationSettings(
        "@drawable/notification",
      ),
      iOS: DarwinInitializationSettings(),
    );

    notiPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        Get.toNamed("${details.payload}");
      },
    );
  }

  showNotification({int? id, required String title, required String body, required bool isMsg}) async {
    var android = AndroidNotificationDetails(
      "channel_Id_${DateTime.now().millisecond}",
      "channel_Name_${DateTime.now().millisecond}",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      color: Colors.blue,
      timeoutAfter: 1000 * 3600,
      showWhen: true,
    );
    var iOS = DarwinNotificationDetails();
    var notiDetails = NotificationDetails(android: android, iOS: iOS);

    await notiPlugin.show(
      1,
      "$title",
      "$body",
      notiDetails,
      payload: isMsg ? "/Chat" : "/Home",
    );
  }
}
