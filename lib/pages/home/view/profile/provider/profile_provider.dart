import 'dart:convert';
import 'dart:io';

import 'package:agitation/models/workman.dart';
import 'package:agitation/pages/main_page/main_page.dart';
import 'package:agitation/utils/functions/main_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/lock_indicator.dart';
import 'package:agitation/pages/lock_page/lock_page.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileProvider extends ChangeNotifier {
  Workman? workman;

  bool isAdmin = false;
  bool notification = true;
  bool fingerprint = false;
  bool isLoading = false;
  bool pin = false;
  String language = "uz";

  String version = "";
  var supplier = {};

  ProfileProvider() {
    onInit();
  }

  void onInit() async {
    isLoading = true;
    notifyListeners();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version = packageInfo.version;

    Box box = await Hive.openBox('db');
    var user = await box.get("user");
    if (user != null) {
      var data = jsonDecode(user);
      isAdmin = data['job_title'] == 1;
      notifyListeners();
    }

    String? dataPhone = await box.get("phone");
    String? jsonLanguage = await box.get("language");
    if (jsonLanguage != null) {
      language = jsonLanguage;
      notifyListeners();
    }
    if (dataPhone != null) {
      var phone = jsonDecode(dataPhone);
      notification = phone['notification'] ?? true;
      fingerprint = phone['fingerprint'] ?? false;
      pin = phone['pin'] ?? false;
    }

    //get my data
    await getMyData();
    //end get my data

    isLoading = false;
    notifyListeners();
  }

  void oCheckLanguage() async {
    Box box = await Hive.openBox('db');

    String? jsonLanguage = await box.get("language");
    if (jsonLanguage != null) {
      language = jsonLanguage;
      notifyListeners();
    }
  }

  getMyData() async {
    var result = await HttpService.GET(HttpService.profile);

    if (result['status'] == HttpConnection.data) {
      var data = result['data']['data'];
      workman = Workman.fromJson(data);
      var finishedTasks = data['tasks'].where((element) => element["status"] == 1).toList();

      workman?.setAllFinishedTasks = finishedTasks.length;
      workman?.setTodayFinishedTasks = finishedTasks.where((element) => MainFunctions().isTodayFinished(element["date"])).toList().length;
    }
  }

  void onNotificationChange(value) async {
    if (value == false) return;
    if (value == true) return;

    Box box = await Hive.openBox("db");
    String? dataPhone = await box.get("phone");
    var phone = {};
    if (dataPhone != null) {
      phone = jsonDecode(dataPhone);
    }
    phone['notification'] = value;
    notification = value;
    await box.put("phone", jsonEncode(phone));
    notifyListeners();
  }

  void onFingerPrintChange(value) async {
    if (value) {
      var lock = jsonDecode(Hive.box("db").get("lock") ?? "null" );

      if (lock == null) {
        MainSnackBar.error("must_pin".tr);
        return;
      }

      var isBla = await authenticate();
      if (isBla != true) return;
      print(await isBla);

      Box box = await Hive.openBox("db");
      String? dataPhone = await box.get("phone");
      var phone = {};
      if (dataPhone != null) {
        phone = jsonDecode(dataPhone);
      }
      phone['fingerprint'] = value;
      fingerprint = value;
      await box.put("phone", jsonEncode(phone));
      notifyListeners();
      print("fingerprint: $value");
    } else {
      Box box = await Hive.openBox("db");
      String? dataPhone = await box.get("phone");
      var phone = {};
      if (dataPhone != null) {
        phone = jsonDecode(dataPhone);
      }
      phone['fingerprint'] = value;
      fingerprint = value;
      await box.put("phone", jsonEncode(phone));
      notifyListeners();
      print("fingerprint: $value");
    }
  }

  Future<bool> authenticate() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      var res = await auth.canCheckBiometrics;
      if (res) {
        return await auth.authenticate(
          options: AuthenticationOptions(biometricOnly: true),
          localizedReason: 'use_finger'.tr,
        );
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  void onPinChange(value) async {
    if (value) {
      var check = await Get.to(LockPage(indicator: LockIndicator.EDIT));

      if (check == null) return;
      if (check == false) return;

      if (check ?? false) onPin(true);

      if (check ?? false) {
        Box box = await Hive.openBox("db");
        String? dataPhone = await box.get("phone");
        var phone = {};
        if (dataPhone != null) {
          phone = jsonDecode(dataPhone);
        }
        phone['pin'] = value;
        pin = value;
        await box.put("phone", jsonEncode(phone));
        notifyListeners();
      } else {
        onPin(check);
      }
    } else {
      onPin(value);
      onFingerPrintChange(false);
    }
  }

  void onPin(value) async {
    Box box = await Hive.openBox("db");
    String? dataPhone = await box.get("phone");
    var phone = {};
    if (dataPhone != null) {
      phone = jsonDecode(dataPhone);
    }
    phone['pin'] = value;
    pin = value ?? true;
    await box.put("phone", jsonEncode(phone));
    notifyListeners();
  }

  void onSaveImage(path) async {
    //
    if (3 > 2) {
      MainSnackBar.successful("succes");
      // await refresh();
    } else {
      MainSnackBar.error("error");
    }
  }

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();
    var result = await HttpService.GET(HttpService.profile);
    supplier = {};
    notifyListeners();
    if (result['status'] == HttpConnection.data) {
      // await Future.delayed(const Duration(seconds: 10));
      supplier = result['data']['data'];
      // notifyListeners();
    }
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();
  }

  logout() async {
    await Hive.box("db").clear();
    await Hive.box("language").clear();
    await Hive.box("fcmToken").clear();

    Get.offAll(() => MainPage());
  }
}
