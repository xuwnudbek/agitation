import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

class ModerationProvider extends ChangeNotifier {
  bool isModerated = false;
  bool isLoading = false;

  ModerationProvider() {
    onInit();
  }

  void onInit() {
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
      
      if ((res['data']['data']['status'] ?? 0) == 1) {
        user['status'] = res['data']['data']['status'];
        user['group_id'] = res['data']['data']['group_id'];
        user['job_title'] = res['data']['data']['job_title'];

        await Hive.box("db").put("user", jsonEncode(user));

        isModerated = true;
        notifyListeners();
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
