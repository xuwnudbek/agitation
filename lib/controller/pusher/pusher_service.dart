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
    print("PusherCount {${event.channelName}->${event.eventName}}: ${++count}");

    if (event.eventName == "pusher:subscription_succeeded") return;
    var notiService = NotificationService();

    // var eventData = event.data;
    switch (event.eventName) {
      case "workers":
        notiService.showNotification(
          title: "super_admin".tr,
          body: "${jsonDecode(event.data)['data']['text']}",
          isMsg: false,
        );
        writeNotiToDB(jsonDecode(event.data)['data']);
        break;

      case "message":
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
    "l": "Leaders",
    "w": "Workers",
    "g": "Group",
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


//{
//     "id": "1",
//     "title": "Super Admin",
//     "body": "How can i help you?"
// }

// {
//     "id": "1",
//     "title": "Yangi organizatsiya",
//     "body": "17-MAKTAB - qo'shildi"
// }