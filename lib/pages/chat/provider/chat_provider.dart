import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/controller/pusher/pusher_service.dart';
import 'package:agitation/models/admin.dart';
import 'package:agitation/models/message.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatProvider extends ChangeNotifier {
  TextEditingController msgController = TextEditingController();
  bool isLoading = false;
  bool isMsgUploading = false;

  var user;
  Admin? admin;

  Map<String, List<Message>> messages = {};

  ChatProvider() {
    Hive.box("db").put("msgCount", 0);

    onInit();
    getAllMessages();
    onMsg();
  }

  addToDateSets(DateTime date) {
    notifyListeners();
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

    var result = await HttpService.POST(HttpService.message, {"text": msg});

    msgController.clear();
    notifyListeners();

    getAllMessages();

    isLoading = false;
    notifyListeners();
  }

  deleteMsg(int id) async {
    var result = await HttpService.POST(
      HttpService.message + "/$id",
      {"_method": "DELETE"},
    );

    getAllMessages();
  }

  getAllMessages() async {
    print("get msgs");
    isLoading = true;
    notifyListeners();

    var result = await HttpService.GET(HttpService.message);

    print(1111111111111);
    print(result['data']);
    print(1111111111111);

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

    // print(messages.length);
    isLoading = false;
    notifyListeners();
  }

  onMsg() async {
    user = jsonDecode(Hive.box("db").get("user"));
    notifyListeners();

    PusherService.listen("chat_${user['id']}", onEvent: (event) async {
      event = event as PusherEvent;
      if (event.eventName == "pusher:subscription_succeeded") return;
      if (event.eventName != "message") return;
      /////////////////////////////////////////

      getAllMessages();
      /////////////////////////////////////////
      notifyListeners();
    });
  }
}
