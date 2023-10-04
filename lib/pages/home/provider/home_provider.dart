import 'dart:convert';

import 'package:agitation/controller/pusher/pusher_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeProvider extends ChangeNotifier {
  DateTime? currentBackPressTime;
  var user;
  int alertCount = 0;
  int msgCount = 0;

  HomeProvider() {
    if (Hive.box("db").get("onChanged") == null) {
      Hive.box("db").put("onChanged", DateTime.now());
    }
    
    user = Hive.box("db").get("user");
    if (user == null) return;

    user = jsonDecode(user);
    var group_id = user["group_id"];
    var user_id = user["id"];

    if (user['job_title'] == 1) PusherService.init("notification_l");

    PusherService.init("chat_$user_id");
    PusherService.init("channel_$group_id");
    PusherService.init("notification_$group_id");
    PusherService.init("notification_w");

    checkNotificaionsCount();
  }

  checkNotificaionsCount() {
    var box = Hive.box("db");
    box.watch(key: "alertCount").listen((event) {
      alertCount = event.value;
      notifyListeners();
    });
    box.watch(key: "msgCount").listen((event) {
      msgCount = event.value;
      notifyListeners();
    });

    alertCount = Hive.box("db").get("alertCount") ?? 0;
    notifyListeners();
  }

  int indexItem = 0;
  void onTab(value) {
    indexItem = value;
    notifyListeners();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // EasyLoading.showToast("Chiqish uchun yana bir marta bosing",toastPosition: EasyLoadingToastPosition.bottom);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
