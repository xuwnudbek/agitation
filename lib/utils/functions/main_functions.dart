import 'dart:convert';

import 'package:agitation/utils/hex_to_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class MainFunctions {
  static Future<String> base64Encoder(XFile xFile) async {
    var image = await img.readFile(xFile.path);

    var size = image!.elementSizeInBytes / 1024 / 1024;

    print(size);

    return base64.encode(image);
  }

  static customDialog({
    required String title,
    required String subtitle,
    required Function onConfirm,
  }) {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/check.png", width: 60, height: 60),
              SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: HexToColor.fontBorderColor,
                ),
              ),
            ],
          ),
          content: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: HexToColor.fontBorderColor,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: Text(
                "no".tr,
                style: TextStyle(
                  color: HexToColor.fontBorderColor,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(HexToColor.fontBorderColor),
                elevation: MaterialStatePropertyAll(2),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                onConfirm();
                Get.back();
              },
              child: Text(
                "yes".tr,
                style: TextStyle(),
              ),
            ),
          ],
        );
      },
    );
  }

  bool isTodayFinished(String date) {
    DateTime now = DateTime.now();
    DateTime taskDate = DateTime.parse(date);

    return now == taskDate ? true : false;
  }

  static int checkType(data) {
    if (data is String) return int.parse(data);
    if (data is int) return data;
    return 0;
  }
}
