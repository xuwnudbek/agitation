import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/company.dart';
import 'package:agitation/models/task/task.dart';
import 'package:agitation/utils/functions/main_functions.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OrganizationProvider extends ChangeNotifier {
  TextEditingController title = TextEditingController();
  List<XFile> images = [];
  String latitude = "";
  String longitude = "";
  String address = "";

  List<Task> tasks = [];

  OrganizationProvider() {
    onInit();
  }

  onInit() async {
    getAllActiveTasks();
  }

  bool isLoading = false;

  set setLocAdd(Map<String, dynamic> data) {
    latitude = data['latitude'];
    longitude = data['longitude'];
    address = data['address'];
    notifyListeners();
  }

  bool get isValid => title.text.isNotEmpty && images.isNotEmpty && latitude.isNotEmpty && longitude.isNotEmpty ? true : false;

  createCompany() async {
    isLoading = true;
    notifyListeners();

    List<String> base64Images = await Future.wait(images.map((e) => MainFunctions.base64Encoder(e)));

    Map<String, dynamic> data = {
      "title": title.text,
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
      "images": base64Images,
    };
    var result = await HttpService.POST(HttpService.createCompany, data);

    if (result['status'] == HttpConnection.data) {
      MainSnackBar.successful("company_added".tr);
      Navigator.pop(Get.context!);
      // Get.back();
    } else {
      MainSnackBar.error(result['data']['message'] ?? "internet_error".tr);
      print(result['data']);
    }
    isLoading = false;

    notifyListeners();
  }

  getAllActiveTasks() async {
    tasks = [];

    isLoading = true;
    notifyListeners();

    var result = await HttpService.GET(HttpService.getTasks);

    if (result['status'] == HttpConnection.data) {
      var data = result['data']['data'];
      for (var task in data) {
        tasks.add(Task.fromJson(task));
      }
    } else {
      MainSnackBar.error(result['data']['message'] ?? "internet_error".tr);
      print(result['data']);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> pickImage() async {
    return await ImagePicker().pickMultiImage().then((value) {
      if (value.isNotEmpty) {
        images.addAll(value);
        notifyListeners();
        return true;
      }
      return false;
    });
  }

  removeImage(int index) {
    images.removeAt(index);
    notifyListeners();
  }

  //Refresh\
  void refresh() async {
    getAllActiveTasks();
  }
}
