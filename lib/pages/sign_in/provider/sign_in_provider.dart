import 'dart:convert';

import 'package:agitation/models/user.dart';
import 'package:agitation/pages/home/home.dart';
import 'package:agitation/pages/verification/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_auth/local_auth.dart';
import 'package:agitation/controller/https/https.dart';
// import 'package:agitation/page/home/home.dart';
// import 'package:agitation/page/verification/verification_page.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignInProvider extends ChangeNotifier {
  TextEditingController username = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  BuildContext context;

  SignInProvider(this.context) {
    onInit();
  }

  var maskFormatter = MaskTextInputFormatter(mask: '(##) ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  void onInit() async {
    Box box = await Hive.openBox("db");
    String? jsonUser = await box.get("user");
    var user = {};
    if (jsonUser != null) {
      user = jsonDecode(jsonUser);
      username.text = user['username'];
      notifyListeners();
    }

    String? jsonPhone = await box.get("phone");
    if (jsonPhone != null) {
      var phone = jsonDecode(jsonPhone);
      if (phone['fingerprint'] ?? false) {
        authenticateWithBiometrics(user);
      }
    }
  }

  void onSignIn() async {
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      FocusScope.of(context).unfocus();

      Box box = await Hive.openBox("db");
      var fcmToken = await Hive.box("fcmToken").get("fcmToken");
      fcmToken ??= "";

      var data = {
        "username": username.text,
        "password": password.text,
        "notification_token": fcmToken,
      };
      isLoading = true;
      notifyListeners();

      var result = await HttpService.POST(HttpService.login, data);

      if (result['status'] == HttpConnection.data) {
        var userData = result['data']['data']['user'];
        var user = User(
          id: userData['id'],
          fullName: userData['name'] + " " + userData['surname'],
          username: userData['username'],
          password: password.text,
          groupId: userData['group_id'],
          jobTitleId: userData['job_title'],
          token: result['data']['data']['token'],
        );
        await box.put('user', jsonEncode(user.toJson()));

        notifyListeners();

        MainSnackBar.successful("success".tr);
        await Future.delayed(const Duration(milliseconds: 100));
        Get.offAll(() => Home(), transition: Transition.fadeIn);
      } else {
        MainSnackBar.error(result['data']['data']);
      }
      // print(result['status']);
      // if (result['status'] == HttpConnection.data) {
      //   if (result['data']['type'] == 2) {
      //     var user = {
      //       "username": username.text,
      //       "token": result['data']['token'],
      //       "password": password.text,
      //     };
      //     await box.put('user', jsonEncode(user));
      //     MainSnackBar.successful(result['data']["message"]);
      //     await Future.delayed(const Duration(milliseconds: 100));
      //     Get.offAll(Home());
      //   } else if (result['data']['type'] == 3) {
      //     var user = {
      //       "username": username.text,
      //       "token": result['data']['token'],
      //       "password": password.text,
      //     };
      //     await box.put('user', jsonEncode(user));
      //     MainSnackBar.warning(result['data']["message"]);
      //     Get.offAll(const VerificationPage());
      //   }
      // } else {
      //   MainSnackBar.error(result['data']['message']);
      // }
    } else {
      MainSnackBar.error("data_empty".tr);
    }
    isLoading = false;
    notifyListeners();
  }

  void authenticateWithBiometrics(user) async {
    bool authenticated = false;
    try {
      final LocalAuthentication auth = LocalAuthentication();
      authenticated = await auth.authenticate(
        localizedReason: 'Autentifikatsiya qilish uchun barmoq izini skanerlang',
      );
    } on PlatformException catch (e) {
      print(e);
      return;
    }
    if (authenticated) {
      Box box = await Hive.openBox("db");
      String? token = await box.get("token");
      if (token == null) {
        token = "";
      }
      FocusScope.of(context).unfocus();
      var data = {
        "email": "${user['username']}@gmail.com",
        "password": user['password'],
        "notification_token": token,
      };
      isLoading = true;
      notifyListeners();
      var result = await HttpService.POST(HttpService.login, data);
      print(1111111111);
      if (result['status'] == HttpConnection.data) {
        Box box = await Hive.openBox("db");
        var user1 = {
          "username": username.text,
          "token": result['data']['token'],
          "password": user['password'],
        };
        await box.put('user', jsonEncode(user1));

        print("<--------------------------------------------------------------------->");
        print(box.get('user'));
        print("<--------------------------------------------------------------------->");

        MainSnackBar.successful(result['data']["message"]);
        await Future.delayed(const Duration(milliseconds: 100));
        print("RESULT with offAll:: ${result}");
        Get.offAll(() => Home());
      } else {
        MainSnackBar.error(result['data']['errors']);
      }
      isLoading = false;
      notifyListeners();
    }
  }
}
