import 'package:agitation/controller/https/https.dart';
import 'package:agitation/controller/notification/notification_service.dart';
import 'package:agitation/models/workman.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  List<Workman> teamWorkers = [];
  bool isNull = false;
  var allTasks = [];
  var newTasks = [];
  var progTasks = [];
  var finTasks = [];
  var countTotal;

  String? groupName;


  bool isLoading = false;

  OrderProvider({Function? moderation}) {
    moderation?.call();
    onInit();
  }

  void onInit() async {
    getOrders();
  }

  //get orders from server
  getOrders() async {
    print(":getOrders");
    isLoading = true;
    notifyListeners();
    var result = await HttpService.GET(HttpService.home);

    if (result["status"] == HttpConnection.data) {
      print("result: ${result['data']['data']}");
      result['data']['data'] == null ? isNull = true : isNull = false;

      allTasks = result["data"]['data']?["tasks"] ?? [];
      var workers = result["data"]['data']?["workers"] ?? [];

      groupName = result["data"]['data']?["title"] ?? null;

      getSeparateTasks(allTasks);
      getSeparateWorkers(workers);

      //notifyListener
      notifyListeners();
    }
    countTotal = progTasks.length;
    isLoading = false;
    notifyListeners();
  }

  getSeparateWorkers(List? data) {
    teamWorkers = [];
    for (var worker in data ?? []) {
      teamWorkers.add(Workman.fromJson(worker));
    }
    // notifyListeners();
  }

  getSeparateTasks(List? data) {
    // newTasks = [];

    for (var task in data ?? []) {
      if (task["status"] == true || task["status"] == 1) {
        finTasks.add(task);
      } else {
        //check if task is today
        isDateToday(task["created_at"]) ? newTasks.add(task) : null;
        progTasks.add(task);
      }
    }
    // notifyListeners();
  }

  //check task's date and return true if it is today
  bool isDateToday(String date) {
    date = date.split("T")[0].split("-")[2];
    var now = DateTime.now().day;
    return int.parse(date) == now;
  }

  //on refresh call this function
  Future<void> refresh() async {
    // allTasks = [];
    newTasks = [];
    progTasks = [];
    finTasks = [];
    getOrders();

    await Future.delayed(Duration(milliseconds: 400));
  }
}
