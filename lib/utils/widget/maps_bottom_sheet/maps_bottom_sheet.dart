import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/maps_bottom_sheet/provider/maps_bottom_sheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';

class BottomSheetX extends StatelessWidget {
  BottomSheetX({super.key, required this.provider, required this.coords});
  MapsBottomSheetProvider provider;
  Coords coords;


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 350, minHeight: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: HexToColor.fontBorderColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(29), topRight: Radius.circular(29)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "select_map".tr,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            for (AvailableMap e in provider.availableMaps)
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: MaterialButton(
                  splashColor: Colors.grey[200],
                  focusColor: Colors.grey[200],
                  hoverColor: Colors.grey[200],
                  onPressed: () {
                    provider.gotoMap(e, coords);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: SvgPicture.asset(
                                  "${e.icon}",
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              e.mapName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          "assets/images/direction.svg",
                          width: 25,
                          height: 25,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
