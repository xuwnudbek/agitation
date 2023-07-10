import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainSnackBar {
  static void error(message) {
    Get.snackbar(
      "error".tr,
      "",
      messageText: Text(
        message??"",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      icon: Icon(Icons.error),
      backgroundColor: Colors.red,
      
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      colorText: Colors.white,
    );
  } 
   static void warning(message) {
    Get.snackbar(
      "warning".tr,
      "",
      messageText: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      icon: Icon(Icons.warning),
      backgroundColor: Colors.blue.shade700,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      colorText: Colors.white,
    );
  }

  static void successful(String message) {
    Get.snackbar(
      "Ok",
      "",
      messageText: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      icon: Icon(Icons.check_circle),
      backgroundColor: Colors.green,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      colorText: Colors.white,
    );
  }
}
