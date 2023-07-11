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
        print("$channelName __________________________: $currentState");
      },
      onEvent: (event) => _showNotifcation(event),
    );

    pusher.subscribe(
      channelName: channelName,

      // onEvent: (PusherEvent event) => _showNotifcation(event),
    );
    pusher.connect();
  }

  PusherService.listen(this.channelName, {required Function(dynamic event) onEvent}) {
    pusher.init(
      apiKey: "4fce81fd8f05f8290139",
      cluster: "ap2",
      onConnectionStateChange: (currentState, previousState) {
        print("$channelName _________________________: $currentState");
      },
      onEvent: (event) => _showNotifcation(event),
    );

    pusher.subscribe(
      channelName: channelName,
      onEvent: (event) => onEvent(event),
    );
    pusher.connect();
  }

  _showNotifcation(PusherEvent event) {
    if (event.eventName == "pusher:subscription_succeeded") return;

    // var eventData = event.data;
    var notiService = NotificationService();
    print("_______________________________________${event.eventName}");
    switch (event.eventName) {
      case "workers":
        notiService.showNotification(
          title: "super_admin".tr,
          body: "${jsonDecode(event.data)['data']['text']}",
          isMsg: true,
        );
        break;

      case "message":
        Get.currentRoute == "/ChatPage"
            ? null
            : notiService.showNotification(
                id: 1,
                title: "Super Admin",
                body: "${jsonDecode(event.data)['data']['text'] ?? "Unknown Body"}",
                isMsg: true,
              );
        break;

      default:
        break;
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