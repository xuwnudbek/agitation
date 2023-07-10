import 'package:flutter/material.dart';

class MainTextFieldPasswordProvider extends ChangeNotifier {
  final svgEyeOff = "assets/images/eye_off.svg";
  final svgEyeOn = "assets/images/eye_on.svg";
  String selectedSvg = "assets/images/eye_off.svg";
  bool obscureText = true;

  void onPressedEye() {
    obscureText = !obscureText;
    if (obscureText) {
      selectedSvg = "assets/images/eye_off.svg";
    } else {
      selectedSvg = "assets/images/eye_on.svg";
    }
    notifyListeners();
  }
}
