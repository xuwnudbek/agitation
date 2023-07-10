import 'dart:convert';

import 'package:agitation/controller/notification/notification_service.dart';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  String channelName;

  PusherService.init(this.channelName) {
    pusher.init(
      apiKey: "4fce81fd8f05f8290139",
      cluster: "ap2",
      onConnectionStateChange: (currentState, previousState) {
        print("__________________________PusherPCState: $previousState");
        print("__________________________PusherCCState: $currentState");
      },
      onEvent: (event) => _showNotifcation(event),
    );

    pusher.subscribe(
      channelName: channelName,

      // onEvent: (PusherEvent event) => _showNotifcation(event),
    );
    pusher.connect();
  }

  _showNotifcation(PusherEvent event) {
    print("__________________________Pusher:\nEventName: ${event.eventName} \ndata: ${event.data}");

    if (event.eventName == "pusher:subscription_succeeded") return;

    var eventData = jsonDecode(event.data);
    var notiService = NotificationService();

    if (event.eventName == "message") {
      Get.currentRoute == "/chat"
          ? null
          : notiService.showNotification(
              id: 1,
              title: "Super Admin",
              body: "${eventData["data"]["text"] ?? "Unknown Body"}",
              isMsg: true,
            );
    } else if (event.eventName == "alert") {
      notiService.showNotification(
        id: 1,
        title: "Yangi organizatsiya",
        body: "${eventData['data']['company']["title"] ?? "Unknown Body"}",
        isMsg: false,
      );
    }
  }
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