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

  List<Message> messages = [];
  var user;
  Admin? admin;

  Set<DateTime> dateSets = {};
  DateTime currentDate = DateTime.parse(DateTime.now().toString().split(" ")[0]);

  ChatProvider() {
    onInit();
    getAllMessages();
    onMsg();
  }

  addToDateSets(DateTime date) {
    date = DateTime.parse(date.toString().split(" ")[0]);
    dateSets.add(date);
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

  getAllMessages() async {
    var result = await HttpService.GET(HttpService.message);

    if (result['status'] == HttpConnection.data) {
      messages.clear();

      for (var msg in result['data']['data']) {
        Message message = Message.fromJson(msg);
        addToDateSets(message.createdAt!);
        messages.add(message);
        if (message.admin != null) {
          admin = message.admin;
        }
        notifyListeners();
      }
    }

    print(messages.length);

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
