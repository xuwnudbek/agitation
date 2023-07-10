import 'package:flutter/material.dart';

class TabBarWidgetProvider extends ChangeNotifier {
  int selectedItem = 0;

  void onSelectedItem(value) {
    selectedItem = value;
    notifyListeners();
  }
}
