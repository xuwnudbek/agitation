import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/client.dart';
import 'package:agitation/models/task/status.dart';
import 'package:agitation/models/task/task.dart';
import 'package:agitation/models/task/image.dart' as image;
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:flutter/material.dart';

class FinishedOrderProvider extends ChangeNotifier {
  //variables
  final int id;
  Task? task;
  List<image.Image> images = [];
  List<Client> clients = [];
  List<Status> listStatus = [];

  //booleans
  bool isLoading = false;

  FinishedOrderProvider(this.id) {
    onInit();
  }

  onInit() async {
    await getFinishedOrder(id);
  }

  //get finished order
  getFinishedOrder(int id) async {
    isLoading = true;
    notifyListeners();

    var result = await HttpService.GET(HttpService.task + "/$id");

    if (result['status'] == HttpConnection.data) {
      task = Task.fromJson(result['data']['data']);
      images = result['data']['data']['images'].map<image.Image>((e) => image.Image.fromJson(e)).toList();
      clients = result['data']['data']['clients'].map<Client>((e) => Client.fromJson(e)).toList();
    } else {
      MainSnackBar.error(result['data']['message']);
    }

    //get all status
    await getStatus();

    isLoading = false;
    notifyListeners();
  }

  getStatus() async {
    isLoading = true;
    notifyListeners();

    var result = await HttpService.GET(HttpService.getStatus);
    if (result['status'] == HttpConnection.data) {
      listStatus = result['data']['data'].map<Status>((e) => Status.fromJson(e)).toList();
    } else {
      MainSnackBar.error(result['data']['message']);
    }

    isLoading = false;
    notifyListeners();
  }

  //get images

  @override
  void dispose() {
    super.dispose();
  }
}
