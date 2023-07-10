import 'package:agitation/pages/chat/chat_page.dart';
import 'package:agitation/pages/home/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class FirebaseNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;
  String? fcmToken;

  onInit() async {
    await init();
    await saveToken();
  }

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    if (fCMToken != null) {
      this.fcmToken = fCMToken;
    }

    FirebaseMessaging.onMessage.listen((message) {
      Get.snackbar(
        message.notification!.title!,
        message.notification!.body!,
        margin: EdgeInsets.only(top: 15),
        onTap: (snack) {
          Get.offAll(() => Home());
        },
      );
    });

    // FirebaseMessaging.onBackgroundMessage((message) async => await (msg) => print(msg));

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Get.offAll(() => Home());
      print("<------------------------------------------------------>");
      print("onMessageOpenedApp: ${message.data}");
      print("<------------------------------------------------------>");
    });

    // FirebaseMessaging.onBackgroundMessage((message) {
    //   return handleBackgroundMessage(message);
    // });
  }

  saveToken() async {
    Box box = Hive.box("fcmToken");
    await box.put("fcmToken", await _firebaseMessaging.getToken());
    print("FCM Token: ${box.get("fcmToken")}");
  }
}
