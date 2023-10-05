import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/task/status.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddClientProvider extends ChangeNotifier {
  TextEditingController fioController = TextEditingController();
  TextEditingController phoneController = TextEditingController(text: "+998");
  TextEditingController commentController = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(mask: '+998 (##) ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  List<Status> listStatus = [];
  Status? status;

  bool isClientLoading = false;
  bool isLoaded = false;

  AddClientProvider() {
    onInit();
  }

  onInit() async {
    await getListStatus();
  }

  void onSelectedStatus(Status value) {
    status = value;
    notifyListeners();
  }

  getListStatus() async {
    var result = await HttpService.GET(HttpService.getStatus);

    if (result['status'] == HttpConnection.data) {
      if (result['data']['data'] != null) {
        result['data']['data'].forEach((element) {
          listStatus.add(Status.fromJson(element));
        });
        status = listStatus[0];
      }
    } else {
      (result['data']['message']);
    }

    notifyListeners();
  }

  checkEmptyField(int taskId) {
    if (fioController.text.isEmpty || phoneController.text.isEmpty || commentController.text.isEmpty) {
      MainSnackBar.error("data_empty".tr);
      return null;
    } else {
      Map data = {
        "title": fioController.text,
        "phone": phoneController.text,
        "status_id": status!.id,
        "comment": commentController.text,
        "task_id": taskId,
      };
      return data;
    }
  }

  addClient(int taskId) async {
    var data = checkEmptyField(taskId);

    isClientLoading = true;
    notifyListeners();

    var result = await HttpService.POST(HttpService.addClient, data);

    if (result['status'] == HttpConnection.data) {
      MainSnackBar.successful("client_added".tr);
    } else {
      (result['data']['message']);
    }

    isClientLoading = false;
    notifyListeners();

    return true;
  }
}
