import 'dart:convert';
import 'package:agitation/controller/notification/notification_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import 'package:collection/collection.dart';

class PusherService {
  int count = 0;

  final pusher = PusherChannelsFlutter.getInstance();

  String channelName;

  PusherService.init(this.channelName) {
    if (pusher.connectionState != "CONNECTED") {
      pusher.init(
        apiKey: "4fce81fd8f05f8290139",
        cluster: "ap2",
        onConnectionStateChange: (currentState, previousState) {
          print("$channelName __________________________: ${currentState == "CONNECTED" ? "Connected" : "Not Connected"}");
        },
        maxReconnectGapInSeconds: 1,
        maxReconnectionAttempts: 1,
        onEvent: (event) => onEvent(event),
        onError: (message, code, error) => print("PusherError: $message"),
      );

      pusher.subscribe(
        channelName: channelName,
        // onEvent: (PusherEvent event) => onEvent(event),
      );

      pusher.connect();
    }
  }

  onEvent(PusherEvent event) {
    var box = Hive.box("db");
    print("PusherCount {${event.channelName}->${event.eventName}}: ${++count}");

    if (event.eventName == "pusher:subscription_succeeded") return;
    var notiService = NotificationService();

    print(event.data);
    print(event.eventName);
    print(event.channelName);

    // var eventData = event.data;
    var now = DateTime.now();
    print(now);
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
        box.put("onChanged", DateTime.now());

        notiService.showNotification(
          title: "super_admin".tr,
          body: "${jsonDecode(event.data)['data']['company']['title']} ${"added".tr}",
          isMsg: false,
        );
        break;

      case "message":
        int msgCount = box.get("msgCount") ?? 0;
        box.put("msgCount", ++msgCount);
        box.put("onChanged", DateTime.now());

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

  PusherService.listen(this.channelName, {required Function(dynamic event) onEvent}) {
    pusher.init(
      apiKey: "4fce81fd8f05f8290139",
      cluster: "ap2",
      onConnectionStateChange: (currentState, previousState) {
        print("$channelName _________________________: $currentState");
      },
      onEvent: (event) => onEvent(event),
    );

    pusher.subscribe(
      channelName: channelName,
      onEvent: (event) => onEvent(event),
    );
    pusher.connect();
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
