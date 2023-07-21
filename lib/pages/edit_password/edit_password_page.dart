import 'dart:ui';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/workman.dart';
import 'package:agitation/pages/home/view/profile/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agitation/pages/edit_password/provider/edit_password_provider.dart';

import 'package:agitation/pages/home/view/profile/profile_page.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/main_material_icon_button.dart';
import 'package:provider/provider.dart';

class EditPasswordPage extends StatelessWidget {
  EditPasswordPage({super.key, required this.workman});
  Workman workman;

  @override
  Widget build(BuildContext context) {
    print(workman.name);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EditPasswordProvider>(
          create: (context) => EditPasswordProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
      ],
      child: Consumer<EditPasswordProvider>(builder: (context, provider, child) {
        return Stack(
          children: [
            Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
              return Scaffold(
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 19),
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
                  child: Column(
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
                                    "${profileProvider.workman?.todayFinishedTasks}",
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
                                    CircleAvatar(
                                      maxRadius: 50,
                                      backgroundColor: HexToColor.fontBorderColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50.0),
                                          child: profileProvider.workman?.image == null
                                              ? Image.asset(
                                                  "assets/images/image_person.png",
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  "${HttpService.image}/${profileProvider.workman?.image}",
                                                  height: 100.0,
                                                  width: 100.0,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
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
                                              ))
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
                                    "${profileProvider.workman?.allFinishedTasks}",
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
                        "${profileProvider.workman?.name ?? "Unknown"}".toUpperCase(),
                        textAlign: TextAlign.center,
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
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(color: HexToColor.mainColor, borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "${profileProvider.isAdmin ? "admin".tr : "workman".tr}".toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white),
                        ),
                      ),

                      //Form
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: TextField(
                          obscureText: true,
                          controller: provider.oldPassword,
                          decoration: InputDecoration(
                            label: Text(
                              "${"old_password".tr}:",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: TextField(
                          obscureText: true,
                          controller: provider.newPassword,
                          decoration: InputDecoration(
                            label: Text(
                              "${"new_password".tr}:",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: TextField(
                          controller: provider.newPassword1,
                          obscureText: true,
                          decoration: InputDecoration(
                            label: Text(
                              "${"config_new_password".tr}:",
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
                      )
                    ],
                  ),
                ),
              );
            }),
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
      }),
    );
  }
}
