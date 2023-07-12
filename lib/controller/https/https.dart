import 'dart:convert';
import 'dart:io';
import 'package:agitation/utils/functions/main_functions.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HttpService {
  // static String mainUrl = "shop-bot.orzugrand.uz";
  // static String mainUrl = "192.168.0.116:8000";
  static String mainUrl = "192.168.0.125:2004";
  static String additional = "api/";

  static String profile = "${additional}worker";
  static String register = "${additional}register";
  static String login = "${additional}login";
  static String home = "${additional}home";
  static String regions = "${additional}city";
  static String addImage = "${additional}addimages";
  static String addLocation = "${additional}addlocation";
  static String addClient = "${additional}client";
  static String getStatus = "${additional}status";
  static String createCompany = "${additional}company";

  static String getTasks = "${additional}tasks";
  static String changeTaskStatus = "${additional}changeTask";
  static String task = "${additional}task";

  static String image = "http://$mainUrl/images";
  static String message = "${additional}message";

  static String newOrder = "${additional}tickets";
  static String progress = "${additional}tickets/progress";
  static String inProgress = "${additional}tickets/in-progress";
  static String orderSave = "${additional}tickets/done";
  static String doneOrders = "${additional}tickets/done";
  static String returnOrders = "${additional}tickets/return";
  static String returnOrdersInProgress = "${additional}tickets/in-progress-by-return";
  static String returnDone = "${additional}tickets/done-by-return";
  static String otherOrders = "${additional}tacks";
  static String otherSave = "${additional}tacks/done";
  static String returnDoneList = "${additional}tickets/done-by-return";
  static String profilePassword = "${additional}profile/password";
  static String saveAvatar = "${additional}profile/avatar";
  static String verification = "${additional}verify-phone-number";
  static String notificationList = "${additional}notifications";

  static getHeaders() async {
    Box box = await Hive.openBox("db");
    String? user = await box.get("user");
    String? lang = await box.get("language");
    String auth = '';

    lang ??= "";
    if (user != null) {
      auth = jsonDecode(user)['token'] ?? "";
    }
    return {'Content-type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $auth', 'Accept-Language': lang};
  }

  static POST(url, body, {params, String? password}) async {
    try {
      Map<String, String>? headers = await getHeaders();

      // Uri.https(HttpService.mainUrl, url, params),
      var response = await http.post(
        Uri.http(HttpService.mainUrl, url, params),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode < 299) {
        var data = {'status': HttpConnection.data, 'data': jsonDecode(response.body)};
        return data;
      } else {
        print("ERROR:: ${response.body}");
        var data = {'status': HttpConnection.error, 'data': jsonDecode(response.body)};
        return data;
      }
    } on HttpException catch (e) {
      print("ERROR:: {$e}");
      var data = {
        'status': HttpConnection.none,
        'data': {'message': "internet_error".tr}
      };

      return data;
    }
  }

  static GET(url, {params, String? password}) async {
    try {
      Map<String, String>? headers = await getHeaders();

      // Uri.https(HttpService.mainUrl, url, params),
      var response = await http.get(
        Uri.http(HttpService.mainUrl, url, params),
        headers: headers,
      );
      if (response.statusCode < 299) {
        var data = {'status': HttpConnection.data, 'data': jsonDecode(response.body)};
        return data;
      } else {
        var data = {'status': HttpConnection.error, 'data': jsonDecode(response.body)};
        return data;
      }
    } on HttpException {
      var data = {
        'status': HttpConnection.none,
        'data': {'message': "internet_error".tr}
      };

      MainSnackBar.error("internet_error".tr);

      return data;
    }
  }

  static PATCH(url, {body, params, String? password}) async {
    try {
      Map<String, String>? headers = await getHeaders();

      // Uri.https(HttpService.mainUrl, url, params),
      var response = await http.patch(
        Uri.http(HttpService.mainUrl, url, params),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode < 299) {
        var data = {'status': HttpConnection.data, 'data': jsonDecode(response.body)};
        return data;
      } else {
        var data = {'status': HttpConnection.error, 'data': jsonDecode(response.body)};

        return data;
      }
    } on HttpException {
      var data = {
        'status': HttpConnection.none,
        'data': {'message': "internet_error".tr}
      };

      return data;
    }
  }

  static uploadImage(int userId, XFile image) async {
    Map<String, String>? headers = await getHeaders();
    var request = http.MultipartRequest(
      'POST',
      Uri.http(HttpService.mainUrl, HttpService.profile + "/$userId"),
    );

    request.headers.addAll(headers!);
    request.fields['_method'] = "PUT";
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode < 299) {
      var data = {'status': HttpConnection.data, 'data': jsonDecode(await response.stream.bytesToString())};
      print("status: ${response.statusCode} => ${data}");
      return data;
    } else {
      var data = {'status': HttpConnection.error, 'data': jsonDecode(await response.stream.bytesToString())};
      print("status: ${response.statusCode} => ${data}");

      return data;
    }
  }
}

enum HttpConnection { data, none, error }
