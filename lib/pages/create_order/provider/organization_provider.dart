import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/task/task.dart';
import 'package:agitation/pages/camera/camera_page.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

class OrganizationProvider extends ChangeNotifier {
  TextEditingController title = TextEditingController();

  List<XFile> images = [];
  String latitude = "";
  String longitude = "";
  String address = "";

  bool hasGroup = false;

  List<Task> tasks = [];

  OrganizationProvider() {
    onInit();
    checkGroup();
  }

  checkGroup() async {
    var user = jsonDecode(Hive.box("db").get("user"));

    var res = await HttpService.GET(HttpService.profile);

    if (res['status'] == HttpConnection.data) {
      user['status'] = res['data']['data']['status'] ?? 0;
      user['group_id'] = res['data']['data']['group_id'] ?? 0;
      user['job_title'] = res['data']['data']['job_title'];
      await Hive.box("db").put("user", jsonEncode(user));

      if (user["group_id"] > 0) {
        hasGroup = true;
      } else {
        hasGroup = false;
      }
    }
    notifyListeners();
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

  String? _date = null;
  get date => _date;
  set setDate(String date) {
    this._date = date;
    notifyListeners();
  }

  bool get isValid => title.text.isNotEmpty && images.isNotEmpty && latitude.isNotEmpty && longitude.isNotEmpty ? true : false;

  createCompany() async {
    isLoading = true;
    notifyListeners();

    Map<String, String> data = {
      "title": title.text,
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
      // "date": date,
    };

    var result = await HttpService.postWithFile(HttpService.createCompany, data, images);

    if (result['status'] == HttpConnection.data) {
      MainSnackBar.successful("company_added".tr);
      Navigator.pop(Get.context!);
      // Get.back();
    } else {
      MainSnackBar.error(result['data']['message'] ?? "internet_error".tr);
      (result['data']);
    }
    ("resultresultresultresult");

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
        (task);
        Task taskObject = Task.fromJson(task);
        tasks.add(taskObject);
      }
    } else {
      MainSnackBar.error(result['data']['message'] ?? "internet_error".tr);
      (result['data']);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> pickImage({bool isCamera = false}) async {
    if (isCamera) {
      var path = await Get.to(() => CameraPage());
      if (path == null) return false;

      images.add(XFile(path));
      notifyListeners();
      return true;
    } else {
      return await ImagePicker().pickMultiImage().then((value) {
        if (value.isNotEmpty) {
          images.addAll(value);
          notifyListeners();
          return true;
        }
        return false;
      });
    }
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
