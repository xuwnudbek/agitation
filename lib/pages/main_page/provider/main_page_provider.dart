import 'dart:convert';
import 'package:agitation/pages/main_page/main_page.dart';
import 'package:agitation/pages/no_connection/no_connection_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../access/access_page.dart';

class MainProvider extends ChangeNotifier {
  String versionText = "";
  MainProvider() {
    onInit();
  }
  void onInit() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.microphone,
      // Permission.requestInstallPackages,
    ].request();
    print(statuses[Permission.location]);
    /*  
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   }
    // }); */

    try {
      // Version? version = await cloudDB.read();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String thisVersion = packageInfo.version;
      versionText = thisVersion;
      String buildNumber = packageInfo.buildNumber;
      notifyListeners();

      /*if (thisVersion != version.version) {
          updatePageActive = true;
          Get.offAll(UpdatePage(version: version));
      }*/
    } catch (e) {
      print("eeeeeeeee ${e}");
    }
    // if (!updatePageActive) {
    Box box = await Hive.openBox('db');
    String? pin = await box.get('lock');
    await Future.delayed(const Duration(milliseconds: 1000));
    String? jsonPhone = await box.get("phone");

    String? jsonLanguage = await box.get("language");
    if (jsonLanguage != null) {
      Get.updateLocale(Locale(jsonLanguage));
    }
    // print(jsonPhone);

    Get.offAll(() => AccessPage());
    // if (jsonPhone != null) {
    //   var phone = jsonDecode(jsonPhone);
    //   if (phone['pin'] ?? false) {
    //     // Get.offAll(const SecurityPage());
    //   } else {
    //     print(1111111111);
    //     Get.offAll(const AccessPage());
    //     Get.to(AccessPage());
    //   }
    // } else {
    //   print(2222222222);
    //   Get.to(AccessPage());
    //   Get.offAll(() => AccessPage());
    // }
    // }
  }

  _changeData(String msg) {
    notificationData = msg;
  }

  _changeTitle(String msg) {
    notificationTitle = msg;
  }

  _changeBody(String msg) {
    notificationBody = msg;
  }

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
}
