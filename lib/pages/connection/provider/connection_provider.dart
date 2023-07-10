import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionProvider extends ChangeNotifier {
  bool isConnected = false;

  ConnectionProvider() {
    onInit();
  }

  void onInit() {
    Connectivity().checkConnectivity().then((value) {
      if (value != ConnectivityResult.none) {
        isConnected = true;
        notifyListeners();
      } else {
        isConnected = false;
        notifyListeners();
      }
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        isConnected = true;
        notifyListeners();
      } else {
        isConnected = false;
        notifyListeners();
      }
    });
  }
}
