import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/controller/pusher/pusher_service.dart';
import 'package:agitation/models/message.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatProvider extends ChangeNotifier {
  TextEditingController msgController = TextEditingController();
  bool isLoading = false;
  bool isMsgUploading = false;

  List<Message> messages = [];
  var user;

  ChatProvider() {
    onInit();
    getAllMessages();
    onMsg();
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

    if (result['status'] == HttpConnection.data) {
      messages.clear();

      for (var msg in result['data']['data']) {
        messages.add(Message.fromJson(msg));
        notifyListeners();
      }
      messages = messages.reversed.toList();
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  getAllMessages() async {
    isMsgUploading = true;
    notifyListeners();

    var result = await HttpService.GET(HttpService.message);

    if (result['status'] == HttpConnection.data) {
      messages.clear();

      for (var msg in result['data']['data']) {
        messages.add(Message.fromJson(msg));
        notifyListeners();
      }
      notifyListeners();
    }
    isMsgUploading = false;
    notifyListeners();
  }

  onMsg() async {
    user = jsonDecode(Hive.box("db").get("user"));
    notifyListeners();

    PusherService.listen("chat_${user['id']}", onEvent: (event) async {
      event = event as PusherEvent;
      if (event.eventName == "pusher:subscription_succeeded") return;
      if (event.eventName != "message") return;

      print("___________________RuntimeType: ${event.data.runtimeType}");

      // var eventData = jsonDecode(event.data);
      print("___________________msgLength 1: ${messages.length}");

      // messages.add(Message.fromJson(eventData["data"]));

      /////////////////////////////////////////

      print("___________________msgLength 1: ${000000000000000000}");

      var result = await HttpService.GET(HttpService.message);
      msgController.clear();
      notifyListeners();

      if (result['status'] == HttpConnection.data) {
        messages.clear();

        for (var msg in result['data']['data']) {
          messages.add(Message.fromJson(msg));
          notifyListeners();
        }
        // messages = messages.reversed.toList();
        notifyListeners();
      }

      /////////////////////////////////////////

      notifyListeners();
      print("___________________msgLength 2: ${messages.length}");
    });
  }
}
