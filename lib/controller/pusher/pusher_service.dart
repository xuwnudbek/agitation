import 'dart:convert';
import 'package:agitation/controller/notification/notification_service.dart';
import 'package:agitation/pages/chat/provider/chat_provider.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'package:collection/collection.dart';

class PusherService {
  final pusher = PusherChannelsFlutter.getInstance();
  int count = 0;

  var user = jsonDecode(Hive.box("db").get("user") ?? "");

  PusherService() {}

  var pusher1;
  var pusher2;
  var pusher3;
  var pusher4;
  var pusher5;

  void initialize() async {
    var group_id = user["group_id"];
    var user_id = user["id"];

    if (user['job_title'] == 1) PusherService.init("notification_l");

    pusher1 = PusherService.init("chat_$user_id");
    pusher2 = PusherService.init("channel_$group_id");
    pusher3 = PusherService.init("notification_$group_id");
    pusher4 = PusherService.init("notification_w");
    pusher5 = PusherService.init("alert_$group_id");
  }

  PusherService.init(String channelName) {
    () async {
      if (pusher.connectionState != "CONNECTED") {
        await pusher.init(
          apiKey: "4fce81fd8f05f8290139",
          cluster: "ap2",
          maxReconnectGapInSeconds: 1,
          maxReconnectionAttempts: 1,
          onEvent: (event) => onEvent(event),
          onConnectionStateChange: (currentState, previousState) {
            if (currentState == "CONNECTED") {
              print("PusherConnected: $currentState");
            } else {
              print("PusherDisconnected: $currentState");
            }
          },
          onError: (message, code, error) => print("PusherError: $message"),
          onSubscriptionError: (message, error) => print("PusherSubscriptionError: $message"),
        );

        await pusher.subscribe(
          channelName: channelName,
        );

        await pusher.connect();
      }
    }.call();
  }

  onEvent(PusherEvent event) {
    if (event.eventName == "pusher:subscription_succeeded") return;
    var notiService = NotificationService();

    // var eventData = event.data;
    var box = Hive.box("db");
    switch (event.eventName) {
      case "workers":
        int alertCount = box.get("alertCount") ?? 0;
        box.put("alertCount", ++alertCount);
        notiService.showNotification(
          title: "super_admin".tr,
          body: "${jsonDecode(event.data)['data']['text']}",
          isMsg: false,
        );
        writeNotiToDB(jsonDecode(event.data)['data']);
        break;

      case "alert":
        int alertCount = box.get("alertCount") ?? 0;
        box.put("alertCount", ++alertCount);
        notiService.showNotification(
          title: "super_admin".tr,
          body: "${jsonDecode(event.data)['data']['company']['title']} ${"added".tr}",
          isMsg: false,
        );
        break;

      case "message":
        int alertCount = box.get("msgCount") ?? 0;
        box.put("msgCount", ++alertCount);
        Get.currentRoute == "/ChatPage"
            ? null
            : notiService.showNotification(
                id: 1,
                title: "super_admin".tr,
                body: "${jsonDecode(event.data)['data']['text'] ?? "Unknown Body"}",
                isMsg: true,
              );

        break;

      default:
        print("__________________________________${event.channelName}");
        break;
    }
  }
}

writeNotiToDB(data) {
  Map types = {
    "l": "leaders".tr,
    "w": "workers".tr,
    "g": "group".tr,
  };

  var notificationsDB = Hive.box("db").get("notifications");
  List notifications = jsonDecode(notificationsDB ?? "[]");

  notifications.add({
    "text": data["text"],
    "date": data["date"],
    "type": types[data["type"]] ?? "Unknown",
  });

  //check List is Set Collection or not
  //if is not Set Collection then make it Set Collection
  checkSetOrNot(notifications);

  Hive.box("db").put("notifications", jsonEncode(notifications));
}

List checkSetOrNot(List list) {
  for (var i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {
      var isEqual = DeepCollectionEquality().equals(list[i], list[j]);
      if (isEqual) {
        list.removeAt(j);
      }
    }
  }

  return list;
}
