import 'dart:convert';

import 'package:agitation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:agitation/models/lock_indicator.dart';
import 'package:agitation/pages/access/access_page.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:local_auth/local_auth.dart';

class LockProvider extends ChangeNotifier {
  var lockPassword = ['', '', '', ''];
  String? newText;
  bool animateError = false;
  bool reset = false;
  String titleText = "new_pin".tr;
  //PIN kodni kiriting
  bool configurationButton = true;
  String? oldPassword;
  LockIndicator indicator;

  LockProvider(this.indicator) {
    onInit();
  }
  onInit() async {
    Box box = await Hive.openBox('db');
    String? code = await box.get('lock');
    if (code != null && indicator != LockIndicator.EDIT) {
      oldPassword = code;
      configurationButton = false;
      titleText = "input_pin".tr;
      reset = true;
      notifyListeners();
    }
    print(indicator);
    indicator != LockIndicator.EDIT ? checkFingerprint() : null;
  }

  checkFingerprint() async {
    Box box = await Hive.openBox('db');
    String? dataPhone = await box.get("phone");
    if (dataPhone != null) {
      var phone = jsonDecode(dataPhone);
      print(phone['fingerprint']);
      if (phone['fingerprint'] ?? false) {
        var res = await authenticate();

        if (res ?? true) Get.offAll(() => Home());
      }
    }
  }

  authenticate() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      var res = await auth.canCheckBiometrics;
      if (res) {
        return await auth.authenticate(
          options: AuthenticationOptions(biometricOnly: true),
          localizedReason: 'use_finger'.tr,
        );
      }
    } catch (e) {}
  }

  bool isText = false;
  void onPressedBackspace() {
    int index = 4;
    for (var element in lockPassword) {
      if (element == "") {
        index = lockPassword.indexOf(element);
        break;
      }
    }
    if (index != 0) {
      lockPassword[index - 1] = "";
    }

    notifyListeners();
  }

  String getPassword() {
    String text = "${lockPassword[0]} ${lockPassword[1]} ${lockPassword[2]} ${lockPassword[3]}";

    return text;
  }

  void onEyeOnPressed() {
    isText = !isText;
    notifyListeners();
  }

  void isAnimated() async {
    animateError = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    animateError = false;
    notifyListeners();
  }

  void onPressedNumber(value) async {
    int? index;
    for (var element in lockPassword) {
      if (element == "") {
        index = lockPassword.indexOf(element);
        break;
      }
    }
    if (index != null) {
      lockPassword[index] = value;
      notifyListeners();
      if (index == 3) {
        if (oldPassword != null) {
          String code = lockPassword[0] + lockPassword[1] + lockPassword[2] + lockPassword[3];
          await Future.delayed(const Duration(milliseconds: 200));
          if (code == oldPassword) {
            if (indicator == LockIndicator.ON) {
              print(indicator);
              await Get.offAll(() => Home());
              // Get.back(result: true);
            }
            print(11111111111);
            lockPassword = ['', '', '', ''];
            titleText = "new_pin".tr;
            reset = false;
            oldPassword = null;
            configurationButton = true;
            notifyListeners();
          } else {
            reset = true;
            lockPassword = ['', '', '', ''];
            isAnimated();
            notifyListeners();
            MainSnackBar.error("error_pin".tr);
          }
        }
      }
    }
  }

  void configuration() async {
    if (lockPassword[3] != "") {
      String code = lockPassword[0] + lockPassword[1] + lockPassword[2] + lockPassword[3];
      if (newText == null) {
        newText = code;
        lockPassword = ['', '', '', ''];
        titleText = "new_pin_config".tr;
        notifyListeners();
      } else if (code == newText) {
        String textMessage = "pin_install".tr;
        Box box = await Hive.openBox('db');

        String? lock = await box.get('lock');
        if (lock != null) {
          textMessage = "pin_update".tr;
        }
        await box.put('lock', code);
        Get.back(result: true);
        await Future.delayed(const Duration(milliseconds: 100));
        MainSnackBar.successful(textMessage);
      } else {
        isAnimated();
        MainSnackBar.warning("data_error_pin".tr);
        newText = null;
        lockPassword = ['', '', '', ''];
        titleText = "new_pin".tr;
        notifyListeners();
      }
    }
  }

  void onReset() {
    Get.dialog(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // height: Get.height*0.4,
          width: Get.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Text(
                "title_alert".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "alert_body".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  // color: Colors.ba,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Box box = await Hive.openBox("db");
                        await box.put("lock", null);
                        String? dataPhone = await box.get("phone");
                        var phone = {};
                        if (dataPhone != null) {
                          phone = jsonDecode(dataPhone);
                        }
                        phone['pin'] = false;

                        await box.put("phone", jsonEncode(phone));
                        await Future.delayed(const Duration(milliseconds: 200));
                        Get.offAll(AccessPage());
                      },
                      child: Text("yes".tr)),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("no".tr),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ))
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}
