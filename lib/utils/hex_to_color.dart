import 'package:flutter/material.dart';

class HexToColor {
  static Color mainColor = hexToColor('#FF6600');
  static Color greenColor = hexToColor('#14A23C');
  static Color blackColor = hexToColor('#263238');
  static Color greyTextFieldColor = hexToColor('#DCDCDC');
  static Color redContainerColor = hexToColor('#FFF6EE');
  static Color greenContainerColor = hexToColor('#EFFFEE');
  static Color blueColor = hexToColor('#5B7FFF');

  static Color blueBackgroundColor = hexToColor('#EEF1FF');
  static Color redBackgroundColor = hexToColor('#FFEEEE');
  static Color blueWhiteBackgroundColor = hexToColor('#EEEFFF');
  static Color blueWhiteColor = hexToColor('#3036C3');

  static Color fontBorderColor = hexToColor('#426C81');
  static Color backgroundColor = hexToColor('#C4D8E1');
  static Color detailsColor = hexToColor('#6CBCE4');
  static Color detailsOtherColor = hexToColor('#6BA4C0');
  static Color disableColor = Colors.grey.withOpacity(0.3);
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));

  return Color(int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xFF000000 : 0x00000000));
}
