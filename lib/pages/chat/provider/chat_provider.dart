import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/message.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ChatProvider extends ChangeNotifier {
  TextEditingController msgController = TextEditingController();
  bool isLoading = false;
  bool isMsgUploading = false;

  List<Message> messages = [];
  var user;

  ChatProvider() {
    onInit();
    getAllMessages();
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
}
