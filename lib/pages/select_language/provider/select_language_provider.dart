import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class SelectLanguageProvider extends ChangeNotifier {
  bool isLoading = false;

  void editLanguage(value) async {
    isLoading = true;
    notifyListeners();

    Box box = await Hive.openBox("db");
    box.put("language", value);
    Get.updateLocale(Locale(value));
    await Future.delayed(const Duration(seconds: 1));
    Get.back(result: true);
  }
}
