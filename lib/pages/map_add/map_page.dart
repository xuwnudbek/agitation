import 'dart:async';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/main_material_button.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key, this.isGetCurrent = false});

  final bool isGetCurrent;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapProvider>(
      create: (context) => MapProvider(),
      child: Consumer<MapProvider>(builder: (context, provider, child) {
        return Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: MainMaterialButton(
                  enabled: !provider.isLoading,
                  color: HexToColor.fontBorderColor,
                  onPressed: () {
                    Map<String, dynamic> data = {
                      "latitude": provider.xLat,
                      "longitude": provider.yLng,
                      "address": provider.textAddress,
                    };
                    Get.back(result: data);
                  },
                  text: "save".tr),
            ),
            body: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    GoogleMap(
                      // markers: Set<Marker>.of(provider.markers.values),
                      onCameraIdle: () => isGetCurrent ? null : provider.checkPosition(),
                      onCameraMoveStarted: () => isGetCurrent ? null : provider.startCheck(),
                      onMapCreated: provider.onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(40.37495527637222, 71.78527100809049),
                        zoom: 50.0,
                      ),
                      myLocationEnabled: true,
                      onCameraMove: isGetCurrent ? null : provider.onCameraMove,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                    pin(),
                    Positioned(
                      bottom: 5,
                      left: 10,
                      right: 10,
                      child: Container(
                        // height: Get.height * 0.15,
                        decoration: BoxDecoration(
                          color: HexToColor.fontBorderColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  provider.isLoading
                                      ? Center(
                                          child: LoadingIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "${provider.textAddress}",
                                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                                        )
                                ],
                              ),
                            ),
                            FloatingActionButton(
                              heroTag: "btn1",
                              backgroundColor: HexToColor.detailsColor,
                              onPressed: () {
                                provider.getCurrentPosition();
                              },
                              child: Icon(Icons.my_location),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 15,
                      child: FloatingActionButton(
                        heroTag: "btn2",
                        backgroundColor: HexToColor.detailsColor,
                        onPressed: () {
                          if (!provider.isLoading) {
                            Get.back();
                          }
                        },
                        child: Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }

  Widget pin() {
    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.place_rounded, size: 56),
            Container(
              decoration: const ShapeDecoration(
                shadows: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black,
                  ),
                ],
                shape: CircleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}

class MapProvider extends ChangeNotifier {
  final LatLng center = const LatLng(45.521563, -122.677433);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String xLat = "40.37506851043567";
  String yLng = "71.78546077449491";
  String xLatCheck = "0";
  String yLngCheck = "0";
  bool changePosition = true;
  String textAddress = "";

  int markerIdCounter = 0;
  Completer<GoogleMapController> mapController = Completer();
  bool isLoading = false;

  MapProvider() {
    onInit(40.37506851043567, 71.78546077449491);
    checkPosition();
    getCurrentPosition();
  }

  void checkPosition() async {
    xLatCheck = xLat;
    yLngCheck = yLng;
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    if (changePosition) {
      // changePosition = true;

      await onInit(double.parse(xLatCheck), double.parse(yLngCheck));
    } else {
      changePosition = false;
      notifyListeners();
    }
  }

  void startCheck() {
    changePosition = true;
    notifyListeners();
  }

  Future<void> onInit(lat, lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    List<String> addressNames = [];
    textAddress = "";
    for (var element in placemarks) {
      bool check = false;
      for (var itemAddress in addressNames) {
        if (itemAddress == element.street.toString()) {
          check = true;
        }
      }
      if (!check) {
        addressNames.add(element.street.toString());
        textAddress = "$textAddress${element.street}, ";
      }
    }
    isLoading = false;
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
    MarkerId markerId = MarkerId(markerIdVal());
    LatLng position = LatLng(40.37506851043567, 71.78546077449491);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      // draggable: false,
    );
    markers[markerId] = marker;
    notifyListeners();

    Future.delayed(Duration(milliseconds: 100), () async {
      GoogleMapController controller = await mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 17.0,
          ),
        ),
      );
    });

    getCurrentPosition();
  }

  String markerIdVal({bool increment = false}) {
    String val = 'marker_id_$markerIdCounter';
    if (increment) markerIdCounter++;
    return val;
  }

  void onCameraMove(CameraPosition position) {
    if (markers.isNotEmpty) {
      MarkerId markerId = MarkerId(markerIdVal());
      Marker marker = markers[markerId]!;
      Marker updatedMarker = marker.copyWith(
        positionParam: position.target,
      );
      xLat = updatedMarker.position.latitude.toString();
      yLng = updatedMarker.position.longitude.toString();
      // onInit(updatedMarker.position.latitude, updatedMarker.position.longitude);

      markers[markerId] = updatedMarker;
      notifyListeners();
    }
  }

  Position? _currentPosition;
  Future<void> getCurrentPosition() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
      _currentPosition = position;
      xLat = _currentPosition!.latitude.toString();
      yLng = _currentPosition!.longitude.toString();
      notifyListeners();

      GoogleMapController controller = await mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 17.0,
          ),
        ),
      );
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
