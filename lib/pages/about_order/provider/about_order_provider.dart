import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/task/location.dart';
import 'package:agitation/models/task/status.dart';
import 'package:agitation/models/task/task.dart';
import 'package:agitation/models/client.dart';
import 'package:agitation/models/workman.dart';
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

  AboutOrderProvider({required this.id, required this.workerId}) {
    onInit();
  }

  onInit() async {
    await getTask(id);
    await getListStatus();
    await checkCanAddLocation(workerId);
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
      print(result['data']['message']);
    }

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
      print(result['data']['message']);
    }

    notifyListeners();
  }

  //get task's images
  uploadImage({required int taskId, required int workerId}) async {
    var pickedImages = await pickImage();

    isImageLoading = true;
    notifyListeners();

    List<String> images = await Future.wait(pickedImages.map((e) async => await MainFunctions.base64Encoder(e!)));


    var data = {
      "worker_id": "$workerId",
      "task_id": "$taskId",
      "images": images,
    };

    var result = await HttpService.POST(HttpService.addImage, data);

    if (result['status'] == HttpConnection.data) {
      getData(result['data']['data']);
    } else {
      print(result['data']['message']);
    }

    isImageLoading = false;
    notifyListeners();
  }

  //get locations, clients, images
  getData(Map<String, dynamic> data) async {
    Clipboard.setData(ClipboardData(text: jsonEncode(data)));

    await getListStatus();
    await getLocations(data);
    await getLocWorker(data);
    await getImages(data);
    await getClients(data);
  }

  //pick image
  Future<List<XFile?>> pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickMultiImage();
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
      print(result['data']['message']);
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

  //get locations
  getLocations(Map<String, dynamic> data) async {
    locations = [];

    if (data["locations"] != null) {
      for (var item in data["locations"]) {
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
  }

  //check can add location
  checkCanAddLocation(int worker_id) {
    print("worker_id: $worker_id");
    if (locations.any((element) => element.workerId == worker_id)) {
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
}
