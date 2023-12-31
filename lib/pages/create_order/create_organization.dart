import 'dart:io';

import 'package:agitation/pages/chat/chat_page.dart';
import 'package:agitation/pages/create_order/provider/organization_provider.dart';
import 'package:agitation/pages/map_add/map_page.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/snack_bar/main_snack_bar.dart';
import 'package:agitation/utils/widget/loading_page.dart';
import 'package:agitation/utils/widget/main_material_button.dart';
import 'package:agitation/utils/widget/material_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CreateOrganization extends StatelessWidget {
  const CreateOrganization({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrganizationProvider>(
        create: (context) => OrganizationProvider(),
        builder: (context, snapshot) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Consumer<OrganizationProvider>(
                builder: (ctx, provider, _) => MainMaterialButton(
                  enabled: !provider.isLoading,
                  onPressed: () {
                    if (provider.isValid) {
                      provider.createCompany();
                    } else {
                      MainSnackBar.error("fill_all_fields".tr);
                    }
                  },
                  color: HexToColor.fontBorderColor,
                  text: "save".tr,
                ),
              ),
            ),
            body: SafeArea(
              child: Consumer<OrganizationProvider>(
                builder: (context, provider, child) {
                  return provider.isLoading
                      ? LoadingPage()
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(Icons.arrow_back)),
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
                              "add_organization".tr,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                      // height: 200,
                                      decoration: BoxDecoration(color: HexToColor.backgroundColor.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 42,
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.only(left: 16),
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
                                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                            child: MaterialTextField(
                                              hintText: "",
                                              title: "${"org_name".tr}:",
                                              controller: provider.title,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: MainMaterialButton(
                                              onPressed: () async {
                                                var result = await Get.to(() => MapPage());
                                                if (result != null) {
                                                  provider.setLocAdd = result;
                                                }
                                              },
                                              color: HexToColor.fontBorderColor,
                                              text: "add_location".tr,
                                            ),
                                          ),
                                          const SizedBox(width: 17),
                                          CircleAvatar(
                                            backgroundColor: HexToColor.fontBorderColor,
                                            radius: 18,
                                            child: SvgPicture.asset(
                                              "assets/images/icon_location.svg",
                                              // color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    //Add location
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                                      child: Text(
                                        "${provider.address.isEmpty ? "no_location".tr : provider.address}",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    //Calendar and dedline
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                    //   child: Row(
                                    //     children: [
                                    //       Expanded(
                                    //         child: MainMaterialButton(
                                    //           onPressed: () async {
                                    //             var res = await showDatePicker(
                                    //               context: context,
                                    //               initialDate: provider.date != null ? DateTime.parse(provider.date!) : DateTime.now(),
                                    //               firstDate: DateTime.now(),
                                    //               lastDate: DateTime(2025),
                                    //             );
                                    //             if (res != null) {
                                    //               provider.setDate = res.toString().split(" ")[0];
                                    //             }
                                    //           },
                                    //           color: HexToColor.fontBorderColor,
                                    //           text: provider.date != null ? provider.date : "completing_time".tr,
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 17),
                                    //       CircleAvatar(
                                    //         backgroundColor: HexToColor.fontBorderColor,
                                    //         radius: 18,
                                    //         child: Padding(
                                    //           padding: EdgeInsets.all(7),
                                    //           child: SvgPicture.asset(
                                    //             "assets/images/calendar.svg",
                                    //           ),
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: MainMaterialButton(
                                              onPressed: () async {
                                                await provider.pickImage().then((value) {
                                                  if (value) {
                                                    MainSnackBar.successful("photo_added".tr);
                                                  } else {
                                                    MainSnackBar.error("photo_not_added".tr);
                                                  }
                                                });
                                              },
                                              color: HexToColor.fontBorderColor,
                                              text: "add_photo".tr,
                                            ),
                                          ),
                                          const SizedBox(width: 17),
                                          GestureDetector(
                                            onTap: () async {
                                              await provider.pickImage(isCamera: true).then((value) {
                                                if (value) {
                                                  MainSnackBar.successful("photo_added".tr);
                                                } else {
                                                  MainSnackBar.error("photo_not_added".tr);
                                                }
                                              });
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
                                          const SizedBox(width: 17),
                                          CircleAvatar(
                                            backgroundColor: HexToColor.fontBorderColor,
                                            radius: 18,
                                            child: SvgPicture.asset(
                                              "assets/images/icon_download.svg",
                                              // color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      // color: Colors.red,
                                      child: provider.images.isEmpty
                                          ? Padding(padding: EdgeInsets.only(top: 20.0), child: Text("no_photo".tr))
                                          : ListView.builder(
                                              itemCount: provider.images.length > 0 ? provider.images.length : 1,
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (BuildContext context, int index) {
                                                var image = provider.images[index];

                                                return Stack(children: [
                                                  Container(
                                                    height: 80,
                                                    width: 80,
                                                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                                    decoration: BoxDecoration(
                                                      color: HexToColor.disableColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                      image: DecorationImage(
                                                        image: FileImage(File(image.path)),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -0.5,
                                                    right: 0.0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        provider.removeImage(index);
                                                      },
                                                      child: SvgPicture.asset(
                                                        "assets/images/cross.svg",
                                                        color: Colors.red,
                                                        height: 25,
                                                        width: 205,
                                                      ),
                                                    ),
                                                  ),
                                                ]);
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                },
              ),
            ),
          );
        });
  }
}
