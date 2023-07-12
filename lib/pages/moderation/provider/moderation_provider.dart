import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class ModerationProvider extends ChangeNotifier {
  var isModerated;
  bool isLoading = false;

  ModerationProvider() {
    print("ModerationProvider init");
    onInit();
  }

  void onInit() {
    print("ModerationProvider init func");

    checkModerationStatus();
  }

  checkModerationStatus() async {
    isLoading = true;
    notifyListeners();

    var user = Hive.box("db").get("user");
    if (user == null) return;
    user = jsonDecode(user);

    var res = await HttpService.GET(HttpService.profile);

    if (res['status'] == HttpConnection.data) {
      var status = res['data']['data']['status'] ?? 0;
      user['status'] = status;
      user['group_id'] = res['data']['data']['group_id'];
      user['job_title'] = res['data']['data']['job_title'];
      await Hive.box("db").put("user", jsonEncode(user));
      notifyListeners();
    }

    var userTest = Hive.box("db").get("user");
    if (userTest == null) return;
    userTest = jsonDecode(userTest);
    print(userTest);

    isModerated = userTest['status'] == 1;

    isLoading = false;
    notifyListeners();
    print(isModerated);
  }
}
