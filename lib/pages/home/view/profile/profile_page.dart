// ignore_for_file: prefer_const_constructors

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:agitation/models/lock_indicator.dart';
import 'package:agitation/pages/camera/camera_page.dart';
import 'package:agitation/pages/edit_other/edit_other_page.dart';
import 'package:agitation/pages/edit_password/edit_password_page.dart';
import 'package:agitation/pages/home/view/profile/provider/profile_provider.dart';
import 'package:agitation/pages/lock_page/lock_page.dart';
import 'package:agitation/pages/select_language/select_language.dart';

import 'package:agitation/utils/hex_to_color.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileProvider>(
      create: (context) => ProfileProvider(),
      child: Consumer<ProfileProvider>(builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: provider.isLoading
                ? Center(
                    child: LoadingIndicator(color: HexToColor.fontBorderColor),
                  )
                : Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: HexToColor.fontBorderColor,
                                            child: Text(
                                              "${provider.workman?.todayFinishedTasks ?? 0}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "today_finished".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 12, color: HexToColor.fontBorderColor, fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(50),
                                          onTap: () {
                                            _selectCameraOrGallery(context, provider);
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
                                                    child: provider.workman!.image == null
                                                        ? Image.asset(
                                                            "assets/images/image_person.png",
                                                            height: 100,
                                                            width: 100,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.network(
                                                            "${HttpService.image}/${provider.workman!.image!}",
                                                            height: 100.0,
                                                            width: 100.0,
                                                            fit: BoxFit.cover,
                                                            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                              return child;
                                                            },
                                                            loadingBuilder: (context, child, loadingProgress) {
                                                              return loadingProgress == null
                                                                  ? child
                                                                  : SizedBox(
                                                                      width: 100,
                                                                      height: 100,
                                                                      child: CPIndicator(color: HexToColor.fontBorderColor),
                                                                    );
                                                            },
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
                                            backgroundColor: HexToColor.detailsColor,
                                            child: Text(
                                              "${provider.workman?.allFinishedTasks ?? 0}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "month_finished".tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 12, color: HexToColor.detailsColor, fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${provider.workman?.name ?? "unknown"}".toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "job".tr,
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: HexToColor.detailsColor),
                                ),
                                Container(
                                  constraints: BoxConstraints.expand(
                                    width: Get.size.width * 0.2,
                                    height: 25,
                                  ),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(color: HexToColor.detailsColor, borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "${provider.isAdmin ? "admin".tr : "workman".tr}".toUpperCase(),
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                ListTile(
                                  onTap: () => provider.onNotificationChange(!provider.notification),
                                  title: Text(
                                    "notification".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.black,
                                  ),
                                  trailing: Switch(
                                    value: provider.notification,
                                    onChanged: provider.onNotificationChange,
                                    activeColor: HexToColor.detailsColor,
                                  ),
                                ),
                                ListTile(
                                  onTap: () async {
                                    var res = await Get.to(LockPage(indicator: LockIndicator.EDIT));
                                    if (res ?? false) provider.onPin(true);
                                  },
                                  title: Text(
                                    "pin_code".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.black87,
                                  ),
                                  trailing: Switch(
                                    value: provider.pin,
                                    onChanged: provider.onPinChange,
                                    activeColor: HexToColor.detailsColor,
                                  ),
                                ),
                                ListTile(
                                  onTap: () => provider.onFingerPrintChange(provider.fingerprint),
                                  title: Text(
                                    "finger".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  leading: SvgPicture.asset("assets/images/fingerprint.svg"),
                                  trailing: Switch(
                                    value: provider.fingerprint,
                                    onChanged: provider.onFingerPrintChange,
                                    activeColor: HexToColor.detailsColor,
                                  ),
                                ),
                                ListTile(
                                  onTap: () async {
                                    await Get.to(EditOtherPage(workman: provider.workman!))!.then((value) {
                                      if (value != null) {
                                        provider.onInit();
                                      }
                                    });
                                  },
                                  title: Text(
                                    "edit_data".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  leading: SvgPicture.asset("assets/images/icon_user_edit.svg"),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                                ListTile(
                                  onTap: () async {
                                    await Get.to(EditPasswordPage(workman: provider.workman!))!.then((value) {
                                      if (value != null) provider.onInit();
                                    });
                                  },
                                  title: Text(
                                    "edit_password".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  leading: SvgPicture.asset("assets/images/icon_edit.svg"),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                                ListTile(
                                  onTap: () async {
                                    await Get.to(SelectLanguage())?.then((value) {
                                      if (value != null) {
                                        provider.onInit();
                                      }
                                    });
                                  },
                                  title: Text(
                                    "edit_language".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(provider.language),
                                  leading: Icon(
                                    Icons.language,
                                    color: Colors.black87,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.black,
                                    size: 15,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Version",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(provider.version),
                                  leading: Icon(
                                    Icons.verified_sharp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                          child: InkWell(
                            onTap: () => _buildDialog(context).then((value) => value ? provider.logout() : null),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  "logout".tr,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      }),
    );
  }

  Future<bool> _buildDialog(BuildContext context) async {
    var res = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: Colors.white,
          title: SvgPicture.asset(
            "assets/images/cross.svg",
            width: 75,
          ),
          content: Text(
            "logout_msg".tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text("no".tr, style: TextStyle(fontSize: 17, color: Colors.black)),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red),
              ),
              onPressed: () {
                Get.back(result: true);
              },
              child: Text(
                "yes".tr,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    return res ?? false;
  }

  Future _selectCameraOrGallery(context, ProfileProvider provider) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: HexToColor.fontBorderColor,
            // HexToColor.mainColor.withOpacity(0.7),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "select_image".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Container(
              width: Get.size.width * 0.8,
              height: Get.size.width * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(25),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ]),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, 1);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                          child: Icon(
                        Icons.image,
                        size: Get.size.height * 0.08,
                        color: HexToColor.fontBorderColor,
                      )),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(25),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, 0);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                          child: Icon(
                        Icons.camera_alt,
                        size: Get.size.height * 0.08,
                        color: HexToColor.fontBorderColor,
                      )),
                    ),
                  )),
                ],
              ),
            ),
          );
        })) {
      case 0:
        Get.to(const CameraPage())!.then((value) {
          if (value != null) {
            provider.onSaveImage(value);
          }
        });
        break;
      case 1:
        final ImagePicker _picker = ImagePicker();
        final imageFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 1000,
          maxWidth: 500,
          imageQuality: 90,
        );
        if (imageFile != null) {
          final path = imageFile.path;

          provider.onSaveImage(path);
        }

        break;
    }
  }
}

class MyArc extends StatelessWidget {
  final double diameter;

  const MyArc({super.key, this.diameter = 100});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black.withOpacity(0.3);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.height / 2),
        height: 100,
        width: 100,
      ),
      0.48,
      // math.pi,
      2.2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
