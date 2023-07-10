import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomeProvider extends ChangeNotifier {
  DateTime? currentBackPressTime;

  int indexItem = 0;
  void onTab(value) {
    indexItem = value;
    notifyListeners();
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // EasyLoading.showToast("Chiqish uchun yana bir marta bosing",toastPosition: EasyLoadingToastPosition.bottom);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
