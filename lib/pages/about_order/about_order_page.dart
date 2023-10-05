import 'dart:convert';

import 'package:agitation/controller/https/https.dart';
import 'package:agitation/models/client.dart';

import 'package:agitation/models/workman.dart';
import 'package:agitation/pages/about_order/provider/about_order_provider.dart';
import 'package:agitation/pages/add_client/add_client_page.dart';
import 'package:agitation/pages/chat/chat_page.dart';
import 'package:agitation/pages/map_add/map_page.dart';
import 'package:agitation/utils/functions/main_functions.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:agitation/utils/widget/image_viewer.dart';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:agitation/utils/widget/loading_page.dart';
import 'package:agitation/utils/widget/main_material_button.dart';
import 'package:agitation/utils/widget/maps_bottom_sheet/maps_bottom_sheet.dart';
import 'package:agitation/utils/widget/maps_bottom_sheet/provider/maps_bottom_sheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';

class AboutOrderPage extends StatelessWidget {
  AboutOrderPage({super.key, required this.id});

  final int id;
  var user = jsonDecode(Hive.box("db").get("user"));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AboutOrderProvider(id: id, workerId: user["id"])),
        ChangeNotifierProvider(create: (context) => MapsBottomSheetProvider()),
      ],
      builder: (context, child) {
        return Scaffold(
          bottomNavigationBar: user["job_title"] == null //if job title equals 1 the worker is Admin
              ? null
              : Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
                  child: Consumer<AboutOrderProvider>(builder: (context, provider, child) {
                    return MainMaterialButton(
                      enabled: !provider.isLoading,
                      onPressed: () {
                        MainFunctions.customDialog(
                          title: "finish_task".tr,
                          subtitle: "really_want".tr,
                          onConfirm: () async {
                            var res = await provider.finishTask(id);
                            if (res) {
                              MainSnackBar.successful("${provider.task!.company!.title} task_finished".tr);
                              Get.back(result: true);
                            } else {
                              MainSnackBar.error("task_dont_finished".tr);
                              Get.back();
                            }
                          },
                        );
                      },
                      color: HexToColor.mainColor,
                      text: "finish_task".tr,
                    );
                  }),
                ),
          body: Consumer<AboutOrderProvider>(
            builder: (context, provider, child) => provider.isLoading || provider.task == null
                ? LoadingPage()
                : SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(Icons.arrow_back),
                              ),
                              GestureDetector(
                                onTap: () => Get.to(() => ChatPage()),
                                child: CircleAvatar(
                                  backgroundColor: HexToColor.detailsColor,
                                  child: SvgPicture.asset("assets/images/icon_comment.svg"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${provider.task!.company!.title}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => provider.getTask(id),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                    // height: 200,
                                    decoration: BoxDecoration(color: HexToColor.backgroundColor.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 42,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 16),
                                          width: double.infinity,
                                          decoration: BoxDecoration(color: HexToColor.fontBorderColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                          child: Text(
                                            "reference".tr,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15, top: 12),
                                          child: Wrap(
                                            // alignment: WrapAlignment.start,
                                            // crossAxisAlignment: WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                "address".tr + ": ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: HexToColor.fontBorderColor,
                                                ),
                                              ),
                                              Text(
                                                "${provider.task!.company!.address}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  // color: HexToColor.greenColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15, top: 12),
                                          child: Wrap(
                                            // alignment: WrapAlignment.start,
                                            // crossAxisAlignment: WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                "created_at".tr + ": ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: HexToColor.fontBorderColor,
                                                ),
                                              ),
                                              Text(
                                                "${provider.task!.date}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  // color: HexToColor.greenColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12, top: 12, bottom: 16, right: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.timer_outlined,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "${provider.leftTime}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 1.5,
                                                      // color: HexToColor.greenColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //Add Location
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MainMaterialButton(
                                            enabled: provider.canAddLocation,
                                            onPressed: () async {
                                              var data = await Get.to(() => MapPage(isGetCurrent: true));
                                              if (data != null) {
                                                await provider.addLocation(data);
                                              } else {
                                                MainSnackBar.error("no_location".tr);
                                              }
                                            },
                                            color: HexToColor.fontBorderColor,
                                            text: provider.canAddLocation ? "add_location".tr : "location_added".tr,
                                          ),
                                        ),
                                        SizedBox(width: 17),
                                        CircleAvatar(
                                          backgroundColor: provider.canAddLocation ? HexToColor.fontBorderColor : HexToColor.disableColor,
                                          radius: 18,
                                          child: provider.isLocationLoading
                                              ? Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: LoadingIndicator(color: Colors.white),
                                                )
                                              : SvgPicture.asset(
                                                  "assets/images/icon_location.svg",
                                                ),
                                        ),
                                        Visibility(
                                          visible: provider.task!.company!.latitude != null && provider.task!.company!.longitude != null,
                                          child: Row(
                                            children: [
                                              SizedBox(width: 17),
                                              Consumer<MapsBottomSheetProvider>(builder: (context, mapsBottomSheetProvider, _) {
                                                return CircleAvatar(
                                                  backgroundColor: HexToColor.fontBorderColor,
                                                  radius: 18,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return BottomSheetX(
                                                            provider: mapsBottomSheetProvider,
                                                            coords: Coords(
                                                              double.parse(provider.task!.company!.latitude),
                                                              double.parse(provider.task!.company!.longitude),
                                                            ),
                                                          );
                                                        },
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(30),
                                                            topRight: Radius.circular(30),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/images/direction.svg",
                                                      width: 24,
                                                      // color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //Location added workers
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: provider.locAddedWorkers.isEmpty
                                            ? [Text("no_location".tr)]
                                            : provider.locAddedWorkers.map((e) {
                                                return _buildClientLocationStatus(e);
                                              }).toList(),
                                      ),
                                    ),
                                  ),
                                  //Add images
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MainMaterialButton(
                                            onPressed: () async {
                                              var user = jsonDecode(await Hive.box("db").get("user"));
                                              await provider.uploadImage(taskId: provider.task!.id, workerId: user["id"]);
                                            },
                                            color: HexToColor.fontBorderColor,
                                            text: "add_photo".tr,
                                          ),
                                        ),
                                        SizedBox(width: 17),
                                        GestureDetector(
                                          onTap: () async {
                                            var user = jsonDecode(await Hive.box("db").get("user"));
                                            await provider.uploadImage(taskId: provider.task!.id, workerId: user["id"], isCamera: true);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: HexToColor.fontBorderColor,
                                            radius: 18,
                                            child: SvgPicture.asset(
                                              "assets/images/camera.svg",
                                              // color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 17),
                                        CircleAvatar(
                                          backgroundColor: HexToColor.fontBorderColor,
                                          radius: 18,
                                          child: provider.isImageLoading
                                              ? Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: LoadingIndicator(color: Colors.white),
                                                )
                                              : SvgPicture.asset(
                                                  "assets/images/icon_download.svg",
                                                  // color: Colors.white,
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //images
                                  Container(
                                    height: 100,
                                    // color: Colors.red,
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: provider.images.isEmpty
                                            ? [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 30),
                                                  child: Text("no_image".tr),
                                                )
                                              ]
                                            : provider.images.map((e) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                                                      ),
                                                      isScrollControlled: true,
                                                      builder: (ctx) {
                                                        return ImageViewer(
                                                          path: "${HttpService.image}/${e.image}",
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                                    decoration: BoxDecoration(
                                                      color: HexToColor.disableColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(0.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10),
                                                        child: Image.network(
                                                          "${HttpService.image}/${e.image}",
                                                          // "https://blog.logrocket.com/wp-content/uploads/2021/07/networking-flutter-http-package.png",
                                                          frameBuilder: (ctx, child, _, __) {
                                                            return child;
                                                          },
                                                          loadingBuilder: (ctx, child, loadingProgress) {
                                                            if (loadingProgress != null) {
                                                              return Padding(
                                                                padding: EdgeInsets.all(20.0),
                                                                child: LoadingIndicator(color: Colors.white),
                                                              );
                                                            } else {
                                                              return child;
                                                            }
                                                          },
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                      ),
                                    ),
                                  ),
                                  //Add Client
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MainMaterialButton(
                                              onPressed: () async {
                                                var status = await Get.to(() => AddClientPage(taskId: id));
                                                if (status != null) {
                                                  provider.onInit();
                                                } else {
                                                  print(12312312);
                                                }
                                              },
                                              color: HexToColor.fontBorderColor,
                                              text: "add_client".tr),
                                        ),
                                        SizedBox(width: 17),
                                        CircleAvatar(
                                          backgroundColor: HexToColor.fontBorderColor,
                                          radius: 18,
                                          child: SvgPicture.asset(
                                            "assets/images/icon_add_contacts.svg",
                                            // color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //Clients
                                  Column(
                                    children: provider.clients.isEmpty
                                        ? [
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 30),
                                              child: Text("no_client".tr),
                                            )
                                          ]
                                        : provider.clients.map((e) {
                                            return _buildClientCard(e);
                                          }).toList(),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildClientCard(Client client) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 22, right: 16, bottom: 5, top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexToColor.fontBorderColor.withOpacity(0.05),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset("assets/images/icon_user.svg", color: HexToColor.fontBorderColor),
                            SizedBox(width: 9),
                            Text(
                              "${client.title}",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            SvgPicture.asset("assets/images/icon_call.svg", color: HexToColor.fontBorderColor),
                            SizedBox(width: 9),
                            Text(
                              "${client.phone}",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(height: 7),
                        RichText(
                            textDirection: TextDirection.ltr,
                            text: TextSpan(
                              text: "Комментарий: ",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: HexToColor.fontBorderColor),
                              children: <TextSpan>[
                                TextSpan(text: " ${client.comment} ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: HexToColor.blackColor)),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 14,
                    child: Container(
                      height: 30,
                      width: 85,
                      margin: EdgeInsets.only(right: 14),
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      decoration: BoxDecoration(color: HexToColor.fontBorderColor, borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/icon_cart.svg",
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Consumer<AboutOrderProvider>(
                            builder: (context, value, child) => value.listStatus.isEmpty
                                ? CPIndicator(color: Colors.white, weight: 2, size: Size(10, 10))
                                : Expanded(
                                    child: Text(
                                    "${value.listStatus.firstWhere((element) => element.id == client.statusId).title}",
                                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.white),
                                  )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
            top: 0,
            bottom: 0,
            left: 10,
            child: CircleAvatar(
              backgroundColor: HexToColor.detailsColor,
              radius: 10,
              child: Text(
                "${client.id}",
                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ))
      ],
    );
  }

  Widget _buildClientLocationStatus(Workman workman) {
    return Container(
      decoration: BoxDecoration(
        color: HexToColor.fontBorderColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: HexToColor.fontBorderColor.withOpacity(0.2),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Row(
        children: [
          Text("${workman.name} ${workman.surname}",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              )),
          SizedBox(width: 3),
          SvgPicture.asset(
            "assets/images/icon_location.svg",
            color: Colors.green,
            width: 12,
          ),
        ],
      ),
    );
  }
}
