import 'package:flutter/material.dart';

class MainButtonNavigationBarProvider extends ChangeNotifier {
  int indexItem = 0;
  onTab(value) {
    indexItem = value;
    notifyListeners();
  }
}
