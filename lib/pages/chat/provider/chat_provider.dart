import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/controller/notification/notification_service.dart';
import 'package:agitation/controller/pusher/pusher_service.dart';
import 'package:agitation/models/admin.dart';
import 'package:agitation/models/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class ChatProvider extends ChangeNotifier {
  TextEditingController msgController = TextEditingController();
  bool isLoading = false;
  bool isMsgUploading = false;

  var user;
  Admin? admin;

  get getAllMsg => getAllMessages();

  Map<String, List<Message>> messages = {};

  ChatProvider() {
    Hive.box("db").put("msgCount", 0);
    onInit();
    getAllMessages();

    PusherService().pusher.onEvent = (event) {
      var box = Hive.box("db");

      if (event.channelName == "chat_${user['id']}" && event.eventName == "message") {
        if (Get.currentRoute == "/ChatPage")
          getAllMessages();
        else {
          NotificationService().showNotification(
            id: 1,
            title: "super_admin".tr,
            body: "${jsonDecode(event.data)['data']['text'] ?? "Unknown Body"}",
            isMsg: true,
          );
          int alertCount = box.get("msgCount") ?? 0;
          box.put("msgCount", ++alertCount);
        }
      } else {
        if (event.eventName == "workers") {
          int alertCount = box.get("alertCount") ?? 0;
          box.put("alertCount", ++alertCount);
          NotificationService().showNotification(
            title: "super_admin".tr,
            body: "${jsonDecode(event.data)['data']['text']}",
            isMsg: false,
          );
          writeNotiToDB(jsonDecode(event.data)['data']);
        } else if (event.eventName == "alert") {
          int alertCount = box.get("alertCount") ?? 0;
          box.put("alertCount", ++alertCount);
          NotificationService().showNotification(
            title: "super_admin".tr,
            body: "${jsonDecode(event.data)['data']['company']['title']} ${"added".tr}",
            isMsg: false,
          );
        }
      }
    };
  }

  onInit() async {
    var userJson = await Hive.box("db").get("user");
    if (userJson != null) {
      user = jsonDecode(userJson);
    }

    notifyListeners();
  }

  addMsg() async {
    isLoading = true;
    notifyListeners();

    var msg = msgController.text;
    if (msg.isEmpty) {
      isLoading = false;
      notifyListeners();
      return;
    }

    await HttpService.POST(HttpService.message, {"text": msg});

    msgController.clear();
    notifyListeners();

    getAllMessages();

    isLoading = false;
    notifyListeners();
  }

  deleteMsg(int id) async {
    await HttpService.POST(
      HttpService.message + "/$id",
      {"_method": "DELETE"},
    );

    getAllMessages();
  }

  getAllMessages() async {
    ("get msgs");
    isLoading = true;
    notifyListeners();

    var result = await HttpService.GET(HttpService.message);

    if (result['status'] == HttpConnection.data) {
      messages.clear();

      Map<String, dynamic> data = result['data']['data'] as Map<String, dynamic>;

      List<String> dataKeys = data.keys.toList();
      if (dataKeys.isEmpty) return;

      for (var dateString in dataKeys) {
        List<Message> messagesList = [];
        for (var message in data[dateString] ?? []) {
          Message msg = Message.fromJson(message);
          messagesList.add(msg);
          msg.admin != null ? admin = msg.admin : null;
        }
        messages[dateString] = messagesList;
      }
    }

    // (messages.length);
    isLoading = false;
    notifyListeners();
  }
}
