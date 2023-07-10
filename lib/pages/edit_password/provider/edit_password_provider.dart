import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class EditPasswordProvider extends ChangeNotifier {
  bool isLoading = false;
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController newPassword1 = TextEditingController();

  int? id;

  EditPasswordProvider() {
    onInit();
  }

  onInit() async {
    isLoading = true;
    notifyListeners();

    var user = Hive.box("db").get("user");
    if (user != null) {
      var data = jsonDecode(user);
      id = data['id'];
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  isFillAllFields() {
    return oldPassword.text.isNotEmpty && newPassword.text.isNotEmpty && newPassword1.text.isNotEmpty;
  }

  void onEditData() async {
    if (oldPassword.text.isNotEmpty && newPassword.text.isNotEmpty && newPassword1.text.isNotEmpty) {
      isLoading = true;
      notifyListeners();
      var data = {
        "old_password": oldPassword.text,
        "password": newPassword.text,
        "confirm_password": newPassword1.text,
        "_method": "PUT",
      };

      var result = await HttpService.POST(HttpService.profile + "/${id}", data);
      if (result['status'] == HttpConnection.data) {
        Get.back(result: true);
        await Future.delayed(const Duration(milliseconds: 100));
        MainSnackBar.successful("pass_changed".tr);
      } else {
        MainSnackBar.error("pass_not_changed".tr);
      }
      isLoading = false;
      notifyListeners();
    }
  }
}
