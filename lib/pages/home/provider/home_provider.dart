import 'package:agitation/controller/pusher/pusher_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeProvider extends ChangeNotifier {
  DateTime? currentBackPressTime;
  int alertCount = 0;
  int msgCount = 0;

  HomeProvider() {
    PusherService().initialize();
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
    if (currentBackPressTime == null || 
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      EasyLoading.showToast("Chiqish uchun yana bir marta bosing",toastPosition: EasyLoadingToastPosition.bottom);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
