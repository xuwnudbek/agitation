import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class ChatProvider extends ChangeNotifier {
  TextEditingController msgController = TextEditingController();

  List messages = [
    {
      "id": 12,
      "message": "Hello, can u help me?",
      "time": "12:00",
      "isAdmin": false,
    },
    {
      "id": 15,
      "message": "Hello, how can i help u?",
      "time": "12:01",
      "isAdmin": true,
    }
  ];

  var user;

  ChatProvider() {
    onInit();
  }

  onInit() async {
    var userJson = await Hive.box("db").get("user");
    if (userJson != null) {
      user = jsonDecode(userJson);
    }
    notifyListeners();
  }

  addMsg() {
    var msg = msgController.text;
    if (msg.isEmpty) return;

    messages.add({
      "id": user["id"],
      "message": msg,
      "time": "12:00",
      "isAdmin": false,
    });
    msgController.clear();
    notifyListeners();

    Future.delayed(Duration(milliseconds: 500), () {
      messages.add({
        "id": 15,
        "message": "Hello, how can i help u?",
        "time": "12:01",
        "isAdmin": true,
      });
      notifyListeners();
    });
  }
}
