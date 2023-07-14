import 'dart:ui';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/workman.dart';
import 'package:agitation/pages/home/view/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:agitation/pages/edit_other/provider/edit_other_provider.dart';
import 'package:agitation/pages/home/view/profile/profile_page.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/main_material_icon_button.dart';
import 'package:provider/provider.dart';

class EditOtherPage extends StatelessWidget {
  EditOtherPage({super.key, required this.workman});
  Workman workman;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EditOtherProvider>(
          create: (context) => EditOtherProvider(workman),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
      ],
      builder: (context, child) => Consumer<EditOtherProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Scaffold(
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
                  child: MainMaterialIconButton(
                    onPressed: () => provider.onEditData(),
                    color: HexToColor.greenColor,
                    children: [
                      Text(
                        "save".tr,
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: HexToColor.mainColor,
                                    child: Text(
                                      "${workman.todayFinishedTasks}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "today_finished".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12, color: HexToColor.mainColor, fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    // _selectCameraOrGallery(context, provider);
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50.0),
                                        child: workman.image == null
                                            ? Image.asset(
                                                "assets/images/image_person.png",
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                "${HttpService.image}/${workman.image!}",
                                                height: 100.0,
                                                width: 100.0,
                                              ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Stack(
                                          children: [
                                            MyArc(
                                              diameter: 100,
                                            ),
                                            Positioned(
                                              bottom: 5,
                                              left: 0,
                                              right: 0,
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: HexToColor.greenColor,
                                    child: Text(
                                      "${workman.allFinishedTasks}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "month_finished".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12, color: HexToColor.greenColor, fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${workman.name}".toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "job".tr,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: HexToColor.mainColor),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(color: HexToColor.mainColor, borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "${profileProvider.isAdmin ? "admin".tr : "workman".tr}".toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                //Edit Name
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  child: TextField(
                                    controller: provider.name,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "${"name".tr}:",
                                      ),
                                      labelStyle: TextStyle(color: HexToColor.mainColor),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: HexToColor.mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Edit Surname
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  child: TextField(
                                    controller: provider.surname,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "${"surname".tr}:",
                                      ),
                                      labelStyle: TextStyle(color: HexToColor.mainColor),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: HexToColor.mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Edit Username
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  child: TextField(
                                    controller: provider.username,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "${"username".tr}:",
                                      ),
                                      labelStyle: TextStyle(color: HexToColor.mainColor),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: HexToColor.mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Edit Address
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  child: TextField(
                                    controller: provider.address,
                                    decoration: InputDecoration(
                                      label: Text(
                                        "${"address".tr}:",
                                      ),
                                      labelStyle: TextStyle(color: HexToColor.mainColor),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          color: HexToColor.mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Edit City
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${"city".tr}:",
                                        style: TextStyle(
                                          color: HexToColor.mainColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: HexToColor.mainColor,
                                            ),
                                          ),
                                        ),
                                        value: provider.city_id,
                                        items: provider.regions.map((e) {
                                          return DropdownMenuItem(
                                            child: Text("${e.name}"),
                                            value: e.id,
                                          );
                                        }).toList(),
                                        onChanged: (e) {
                                          provider.city_id = e as int;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              Visibility(
                visible: provider.isLoading,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                      child: Center(
                        child: CircularProgressIndicator(color: HexToColor.mainColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
