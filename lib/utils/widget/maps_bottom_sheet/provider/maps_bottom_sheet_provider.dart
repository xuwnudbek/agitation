import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class MapsBottomSheetProvider extends ChangeNotifier {
  List<AvailableMap> availableMaps = [];
  bool isLoading = false;

  MapsBottomSheetProvider() {
    getActiveMaps();
  }

  getActiveMaps() async {
    isLoading = true;
    notifyListeners();
    availableMaps = await MapLauncher.installedMaps;
    isLoading = false;
    notifyListeners();
  }
  
  gotoMap(AvailableMap map, Coords coords) async {
    await MapLauncher.showDirections(
      destination: coords,
      mapType: map.mapType,
    );
  }
}
