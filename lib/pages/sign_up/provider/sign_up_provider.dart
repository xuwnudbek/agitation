import 'dart:convert';
import 'package:agitation/pages/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:agitation/controller/https/https.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';

class SignUpProvider extends ChangeNotifier {
  BuildContext context;
  bool isLoading = false;
  List listBranch = [];

  int? selectBranch;
  var selectBranchItem;

  TextEditingController name = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password1 = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(mask: '(##) ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  SignUpProvider(this.context) {
    onInit();
  }

  void onInit() async {
    isLoading = true;
    notifyListeners();
    var result = await HttpService.GET(HttpService.regions);
    if (result['status'] == HttpConnection.data) {
      listBranch = result['data']['data'];
    }
    isLoading = false;
    notifyListeners();
  }

  void onSelectItem(value) {
    selectBranch = listBranch.indexOf(value);
    selectBranchItem = value;
    notifyListeners();
  }

  void onPressedRegistration() async {
    print('registration');
    FocusScope.of(context).unfocus();
    phone.text.toString().replaceAll(RegExp(r'[() ]'), '');
    isLoading = true;
    notifyListeners();
    if (name.text.isNotEmpty && lastName.text.isNotEmpty && phone.text.isNotEmpty && username.text.isNotEmpty && selectBranch != null && address.text.isNotEmpty && password.text.length > 3 && password.text == password1.text) {
      var data = {
        "name": name.text,
        "surname": lastName.text,
        "username": username.text,
        "email": username.text + "@gmail.com",
        "phone": "+998${phone.text.toString().replaceAll(RegExp(r'[() ]'), '')}",
        "city_id": listBranch[selectBranch!]['id'] ?? 1,
        "address": address.text,
        "password": password.text,
        "confirm_password": password1.text,
      };

      var result = await HttpService.POST(HttpService.register, data);
      print(result);
      if (result['status'] == HttpConnection.data) {
        MainSnackBar.successful(result['data']['message']);
        Box box = await Hive.openBox("db");
        var user = {
          "username": username.text,
          "token": result['data']['data'],
          "password": password.text,
        };

        await box.put('user', jsonEncode(user));
        await Future.delayed(const Duration(milliseconds: 100));
        // Get.off(VerificationPage());
        Get.offAll(() => SignInPage());
      } else {
        MainSnackBar.error(result['data']['message']);
      }
    } else {
      MainSnackBar.error("data_empty".tr);
    }

    isLoading = false;
    notifyListeners();
  }
}
