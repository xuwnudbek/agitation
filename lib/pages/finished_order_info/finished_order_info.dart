
import 'package:agitation/controller/https/https.dart';
import 'package:agitation/pages/finished_order_info/provider/finished_order_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FinishedOrderInfo extends StatelessWidget {
  FinishedOrderInfo({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FinishedOrderProvider>(
        create: (context) => FinishedOrderProvider(id),
        builder: (context, snapshot) {
          return Scaffold(
            body: SafeArea(
              child: Consumer<FinishedOrderProvider>(builder: (context, provider, child) {
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
                                CircleAvatar(
                                  backgroundColor: HexToColor.detailsColor,
                                  child: SvgPicture.asset("assets/images/icon_comment.svg"),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${provider.task!.company!.title ?? "title"}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            "Справка",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15, top: 12),
                                          child: Wrap(
                                            // alignment: WrapAlignment.start,
                                            // crossAxisAlignment: WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                "Адрес: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: HexToColor.fontBorderColor,
                                                ),
                                              ),
                                              Text(
                                                "${provider.task!.company!.address ?? "address"}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  // color: HexToColor.greenColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15, top: 12),
                                          child: Wrap(
                                            // alignment: WrapAlignment.start,
                                            // crossAxisAlignment: WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                "Дата создания: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: HexToColor.fontBorderColor,
                                                ),
                                              ),
                                              Text(
                                                "${provider.task!.date ?? "date"}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  // color: HexToColor.greenColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12, top: 12, bottom: 16, right: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.timer_outlined,
                                                    size: 20,
                                                  ),
                                                  Text(
                                                    "  ${provider.task!.time ?? "00:00:00"}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
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
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                  //   child: Row(
                                  //     children: [
                                  //       Text(
                                  //         "Локацию",
                                  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HexToColor.fontBorderColor),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                                  //   child: Text(
                                  //     "${provider.task.company!.address}",
                                  //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Фото",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: HexToColor.fontBorderColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  provider.images.isEmpty
                                      ? Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Фото отсутствует",
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Container(
                                          height: 100,
                                          // color: Colors.red,
                                          child: ListView.builder(
                                            itemCount: provider.images.length,
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                height: 80,
                                                width: 80,
                                                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                                decoration: BoxDecoration(
                                                  color: HexToColor.disableColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.network(
                                                    "${HttpService.image}/${provider.images[index].image}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Клиент",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: HexToColor.fontBorderColor, fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  provider.images.isEmpty
                                      ? Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Клиент отсутствует",
                                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Column(
                                          children: provider.clients.map((e) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  // height: 100,
                                                  width: double.infinity,
                                                  margin: const EdgeInsets.only(left: 22, right: 16, bottom: 5, top: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: HexToColor.fontBorderColor.withOpacity(0.05),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SvgPicture.asset("assets/images/icon_user.svg", color: HexToColor.fontBorderColor),
                                                                    const SizedBox(width: 9),
                                                                    Text(
                                                                      "${e.title}",
                                                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 2),
                                                                Row(
                                                                  children: [
                                                                    SvgPicture.asset("assets/images/icon_call.svg", color: HexToColor.fontBorderColor),
                                                                    const SizedBox(width: 9),
                                                                    Text(
                                                                      "${e.phone}",
                                                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 7),
                                                                RichText(
                                                                    textDirection: TextDirection.ltr,
                                                                    text: TextSpan(
                                                                      text: "Комментарий: ",
                                                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: HexToColor.fontBorderColor),
                                                                      children: <TextSpan>[
                                                                        TextSpan(text: " ${e.comment} ", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: HexToColor.blackColor)),
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
                                                              margin: const EdgeInsets.only(right: 14),
                                                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                                              decoration: BoxDecoration(color: HexToColor.fontBorderColor, borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
                                                              child: Row(
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    "assets/images/icon_cart.svg",
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Expanded(
                                                                      child: Text(
                                                                    "${provider.listStatus.firstWhere((element) => element.id == e.statusId).title}",
                                                                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.white),
                                                                  ))
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
                                                        "${e.id}",
                                                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                                                      ),
                                                    ))
                                              ],
                                            );
                                          }).toList(),
                                        )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
              }),
            ),
          );
        });
  }
}
