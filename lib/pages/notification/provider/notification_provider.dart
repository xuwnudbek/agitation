import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:collection/collection.dart';

class NotificationProvider extends ChangeNotifier {
  List notifications = [];
  bool isLoading = false;

  NotificationProvider() {
    Hive.box("db").put("alertCount", 0);
    onInit();
  }

  void onInit() {
    getNotifications();
  }

  bool isTodayRecieved(String? date) {
    if (date == null) return false;
    var today = DateTime.now();
    DateTime notiDate = DateTime.parse(date);

    int diffDay = notiDate.difference(today).inDays;

    if (diffDay == 0) {
      return true;
    } else {
      return false;
    }
  }

  getNotifications() {
    isLoading = true;
    notifyListeners();

    var notificationDB = Hive.box("db").get("notifications");
    print("Notifications all: $notificationDB");
    if (notificationDB != null) {
      notifications = checkSetOrNot(jsonDecode(notificationDB));
      Hive.box("db").put("notification", jsonEncode(notifications));
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  deleteAllNotification() {
    Hive.box("db").put("notifications", null);
    notifications = [];
    notifyListeners();
  }

  List checkSetOrNot(List list) {
    for (var i = 0; i < list.length - 1; i++) {
      for (int j = i + 1; j < list.length; j++) {
        var isEqual = DeepCollectionEquality().equals(list[i], list[j]);
        if (isEqual) {
          list.removeAt(j);
        }
      }
    }

    return list;
  }
}
