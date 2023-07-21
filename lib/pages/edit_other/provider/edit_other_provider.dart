import 'package:agitation/models/region.dart';
import 'package:agitation/models/workman.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agitation/controller/https/https.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';

class EditOtherProvider extends ChangeNotifier {
  Workman? workman;
  List<Region> regions = [];

  var supplier;
  bool isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController address = TextEditingController();

  EditOtherProvider(this.workman) {
    onInit();
  }

  onInit() async {
    await getRegions();
    name.text = workman?.name ?? "";
    surname.text = workman?.surname ?? "";
    username.text = workman?.username ?? "";
    address.text = workman?.address ?? "";
    city_id = workman?.city_id ?? 0;
    notifyListeners();
  }

  int _city_id = 0;
  int get city_id => _city_id;
  set city_id(int value) {
    _city_id = value;
    notifyListeners();
  }

  getRegions() async {
    isLoading = true;
    notifyListeners();

    var result = await HttpService.GET(HttpService.regions);
    if (result['status'] == HttpConnection.data) {
      for (var region in result['data']['data']) {
        regions.add(Region(id: region['id'], name: region['name']));
      }
      // regions = result['data']['data'].map((e) => Region(id: e['id'], name: e['name'])).toList();
      isLoading = false;
      notifyListeners();
    }
  }

  void onEditData() async {
    if (name.text.isNotEmpty && surname.text.isNotEmpty && address.text.isNotEmpty && username.text.isNotEmpty) {
      isLoading = true;
      notifyListeners();
      var data = {
        "name": name.text,
        "surname": surname.text,
        "username": username.text,
        "address": address.text,
        "city_id": city_id.toString(),
        "_method": "PUT",
      };
      var result = await HttpService.POST(HttpService.profile + "/${workman!.id}", data);
      if (result['status'] == HttpConnection.data) {
        Get.back(result: true);
        await Future.delayed(const Duration(milliseconds: 100));
        MainSnackBar.successful("data_changed".tr);
      } else {
        MainSnackBar.successful(result['data']['message']);
      }
      isLoading = false;
      notifyListeners();
    }
  }
}
