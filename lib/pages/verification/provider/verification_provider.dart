import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:agitation/controller/https/https.dart';
import 'package:agitation/pages/confirmation/confirmation_page.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';

class VerificationProvider extends ChangeNotifier {
  int timerFinished = 60;
  Timer? timer;
  List input = [
    {
      "number": "",
      "active": true,
    },
    {
      "number": "",
      "active": false,
    },
    {
      "number": "",
      "active": false,
    },
    {
      "number": "",
      "active": false,
    },
  ];
  bool isLoading = false;

  VerificationProvider() {
    onInit();
  }
  void onInit() async {
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void startTimer() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        timerFinished--;
        notifyListeners();
        if (timerFinished == 0) {
          timer.cancel();
        }
      },
    );
  }

  String getTimer() {
    String row = "";
    if (timerFinished < 10) {
      row = "0$timerFinished";
    } else {
      row = "$timerFinished";
    }
    return row;
  }

  void onPressedNumber(value) {
    int? index;
    for (var element in input) {
      if (element['number'] == "") {
        index = input.indexOf(element);
        break;
      }
    }
    if (index != null) {
      input[index]['number'] = value;
      if (index < 3) {
        input[index + 1]['active'] = true;
      }
      if (index == 3) {
        String code = input[0]['number'] +
            input[1]['number'] +
            input[2]['number'] +
            input[3]['number'];
        onVerification(code);
      }
    }

    notifyListeners();
  }

  Future<void> onVerification(code) async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    var data = {
      "verification_code": code,
    };
    var result = await HttpService.POST(HttpService.verification, data);
    if (result['status'] == HttpConnection.data) {
      Get.offAll(const ConfirmationPage());
      await Future.delayed(const Duration(milliseconds: 400));
      MainSnackBar.successful(result['data']['message']);
    } else {
      MainSnackBar.error(result['data']['message']);
      isLoading = false;
      notifyListeners();
    }
  }

  void onPressedBackspace() {
    int index = 4;
    for (var element in input) {
      if (element['number'] == "") {
        index = input.indexOf(element);
        break;
      }
    }
    if (index != 0) {
      input[index - 1]['number'] = "";
      if (index == 4) {
        input[index - 1]['active'] = true;
      } else {
        input[index]['active'] = false;
      }
    }

    notifyListeners();
  }
}
