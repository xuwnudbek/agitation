import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/workman.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  List<Workman> teamWorkers = [];
  var allTasks = [];
  var newTasks = [];
  var progTasks = [];
  var finTasks = [];
  var countTotal;

  bool isLoading = false;

  OrderProvider() {
    onInit();
  }

  void onInit() async {
    getOrders();
  }

  //get orders from server
  getOrders() async {
    isLoading = true;
    notifyListeners();
    var result = await HttpService.GET(HttpService.home);

    if (result["status"] == HttpConnection.data) {
      allTasks = result["data"]['data']?["tasks"] ?? [];
      var workers = result["data"]['data']?["workers"] ?? [];

      print("AllTasks Count: ${allTasks.length}");

      getSeparateTasks(allTasks);
      getSeparateWorkers(workers);

      //notifyListener
      notifyListeners();
    }
    countTotal = newTasks.length + progTasks.length;
    isLoading = false;
    notifyListeners();
  }

  getSeparateWorkers(List? data) {
    teamWorkers = [];
    for (var worker in data ?? []) {
      teamWorkers.add(Workman.fromJson(worker));
    }
    notifyListeners();
  }

  getSeparateTasks(List? data) {
    // newTasks = [];

    for (var task in data ?? []) {
      if (task["status"] == 1) {
        finTasks.add(task);
      } else {
        //check if task is today
        isDateToday(task["created_at"]) ? newTasks.add(task) : progTasks.add(task);
      }
    }
    notifyListeners();
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

  @override
  void dispose() {
    super.dispose();
  }
}
