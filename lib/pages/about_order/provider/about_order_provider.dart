import 'dart:async';
import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/task/location.dart';
import 'package:agitation/models/task/status.dart';
import 'package:agitation/models/task/task.dart';
import 'package:agitation/models/client.dart';
import 'package:agitation/models/workman.dart';
import 'package:agitation/pages/camera/camera_page.dart';
import 'package:agitation/utils/functions/main_functions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:agitation/models/task/image.dart' as image;
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

class AboutOrderProvider extends ChangeNotifier {
  final int id;
  final int workerId;

  Task? task;
  List<image.Image> images = [];
  List<Location> locations = [];
  List<Client> clients = [];

  List<Workman> locAddedWorkers = []; //the location added workers

  List<Status> listStatus = [];

  bool isLoading = false;
  bool isImageLoading = false;
  bool isLocationLoading = false;
  bool isClientLoading = false;
  bool canAddLocation = false;
  bool checkLocLoading = false;

  Location? location;

  //Timer
  Timer? timer;
  String leftTime = "";

  AboutOrderProvider({required this.id, required this.workerId}) {
    onInit();
    startTimer();
  }

  startTimer() {
    Timer.periodic(Duration(milliseconds: 250), (timer) {
      if (task != null) {
        if (task!.date != null) {
          leftTime = MainFunctions().checkLeftTime(task!.date!, DateTime.now().toString(), isFinished: task!.status == 1 ? true : false);
          notifyListeners();
        }
      }
    });
  }

  onInit() async {
    await getTask(id);
    await getListStatus();
  }

  getTask(int id) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 500));

    var result = await HttpService.GET(HttpService.task + "/$id");

    if (result['status'] == HttpConnection.data) {
      task = Task.fromJson(result['data']['data']);
      getData(result['data']['data']);
      notifyListeners();
    } else {
      (result['data']['message']);
    }

    isLoading = false;
    notifyListeners();
  }

  //get locations, clients, images
  getData(Map<String, dynamic> data) async {
    isLoading = true;
    notifyListeners();

    await getListStatus();
    await getLocations(data);
    await getLocWorker(data);
    await getImages(data);
    await getClients(data);

    isLoading = false;
    notifyListeners();
  }

  getListStatus() async {
    var result = await HttpService.GET(HttpService.getStatus);

    if (result['status'] == HttpConnection.data) {
      if (result['data']['data'] != null) {
        result['data']['data'].forEach((element) {
          listStatus.add(Status.fromJson(element));
        });
      }
    } else {
      (result['data']['message']);
    }

    notifyListeners();
  }

  //get locations
  getLocations(Map<String, dynamic> data) async {
    locations = [];

    if (data["locations"] != null) {
      for (var item in data["locations"]) {
        ("item:: $item['worker']");
        locations.add(Location.fromJson(item));
      }
    }
    notifyListeners();
  }

  //get Location added worker
  getLocWorker(Map<String, dynamic> data) async {
    locAddedWorkers = [];

    for (var location in locations) {
      if (location.taskId == id) {
        locAddedWorkers.add(location.workman!);
      }
    }
    notifyListeners();

    checkCanAddLocation(workerId);
  }

  //check can add location
  checkCanAddLocation(int worker_id) {
    List ids = [];
    locAddedWorkers.forEach((element) => ids.add(element.id));

    ("LocAddedWorkers id: ${ids}");

    if (ids.contains(worker_id)) {
      canAddLocation = false;
    } else {
      canAddLocation = true;
    }

    notifyListeners();
  }

  //getClients
  getClients(Map<String, dynamic> data) async {
    clients = [];

    if (data["clients"] != null) {
      for (var item in data["clients"]) {
        clients.add(Client.fromJson(item));
      }
    }

    notifyListeners();
  }

  //get task's images
  uploadImage({required int taskId, required int workerId, bool isCamera = false}) async {
    var pickedImages = await pickImage(isCamera: isCamera);

    isImageLoading = true;
    notifyListeners();

    // List<String> images = await Future.wait(pickedImages.map((e) async => await MainFunctions.base64Encoder(e!)));

    Map<String, String> data = {
      "worker_id": "$workerId",
      "task_id": "$taskId",
    };

    var result = await HttpService.postWithFile(HttpService.addImage, data, pickedImages);

    if (result['status'] == HttpConnection.data) {
      getData(result['data']['data']);
    } else {
      (result['data']['message']);
    }

    isImageLoading = false;
    notifyListeners();
  }

  //pick image
  Future<List<XFile?>> pickImage({bool isCamera = false}) async {
    if (isCamera) {
      var path = await Get.to(() => CameraPage());
      if (path == null) return [];
      return [XFile(path)];
    } else {
      final ImagePicker picker = ImagePicker();
      return await picker.pickMultiImage();
    }
  }

  //Add Location and get data
  addLocation(Map<String, dynamic> data) async {
    String workerId = jsonDecode(await Hive.box("db").get("user"))["id"].toString();
    data.addAll({"worker_id": workerId, "task_id": task!.id});

    isLocationLoading = true;
    notifyListeners();

    var result = await HttpService.POST(HttpService.addLocation, data);

    if (result['status'] == HttpConnection.data) {
      await getTask(id);
      canAddLocation = false;
    } else {
      (result['data']['message']);
    }

    isLocationLoading = false;
    notifyListeners();
  }

  //get images
  getImages(Map<String, dynamic> data) async {
    images = [];

    if (data["images"] != null) {
      for (var item in data["images"]) {
        images.add(image.Image.fromJson(item));
      }
    }

    notifyListeners();
  }

  //finish Task
  Future<bool> finishTask(int taskId) async {
    isLoading = true;
    notifyListeners();

    var result = await HttpService.GET(HttpService.changeTaskStatus + "/$taskId");

    if (result['status'] == HttpConnection.data) {
      isLoading = false;
      notifyListeners();
      Get.back(result: true);
      return true;
    } else {
      isLoading = false;
      notifyListeners();
      Get.back();
      return false;
    }
  }

  String checkLeftTime(String date1, String date2) {
    DateTime d1 = DateTime.parse(date1);
    DateTime d2 = DateTime.parse(date2);

    Duration diff = d1.difference(d2);

    return "${diff.inDays}:${diff.inHours.remainder(24)}:${diff.inMinutes.remainder(60)}:${diff.inSeconds.remainder(60)}";
  }
}
