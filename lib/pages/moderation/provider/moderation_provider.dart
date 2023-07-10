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

    var res = await HttpService.GET(HttpService.profile);

    if (res['status'] == HttpConnection.data) {
      var data = res['data'];
      if ((data['data']['status'] ?? 0) == 1) {
        isModerated = true;
        notifyListeners();
      }
      await Future.delayed(Duration(milliseconds: 700));
    }

    isLoading = false;
    notifyListeners();
  }
}
