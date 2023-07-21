import 'dart:convert';

import 'package:agitation/controller/pusher/pusher_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeProvider extends ChangeNotifier {
  var user;

  HomeProvider() {
    user = Hive.box("db").get("user");
    if (user == null) return;
    user = jsonDecode(user);
    var group_id = user["group_id"];
    var user_id = user["id"];

    print(user);

    print("__________________________user_id: $user_id");
    print("__________________________group_id: $group_id");

    //initialize pushers

    if (user['job_title'] == 1) PusherService.init("notification_l");

    PusherService.init("chat_$user_id");
    PusherService.init("channel_$group_id");
    PusherService.init("notification_$group_id");
    PusherService.init("notification_w");
  }

  DateTime? currentBackPressTime;

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
                                                                                                                                                                                                                                                                                                                                                                          
//I/flutter ( 5872): __________________________user_id: 5
//I/flutter ( 5872): __________________________group_id: 3
