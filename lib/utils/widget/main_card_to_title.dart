import 'dart:async';

import 'package:agitation/models/task/task.dart';
import 'package:agitation/utils/functions/main_functions.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainCardToTitle extends StatefulWidget {
  MainCardToTitle({super.key, this.task, required this.onPressed});

  Task? task;
  Function onPressed;

  @override
  State<MainCardToTitle> createState() => _MainCardToTitleState();
}

class _MainCardToTitleState extends State<MainCardToTitle> {
  String unknown = "Unknown";

  String leftTime = "";
  late Timer timer;

  startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.task != null) {
        if (widget.task!.date != null) {
          setState(() {
            //if task date is null then it will show unknown
            leftTime = MainFunctions().checkLeftTime(
              widget.task!.date!,
              DateTime.now().toString(),
              isFinished: widget.task!.status == 1 ? true : false,
            );
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                "${widget.task != null ? widget.task!.company!.title : unknown}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                    "${widget.task != null ? widget.task!.company!.address : unknown}",
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
                    "${widget.task != null ? widget.task!.date : unknown}",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "left_time".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: HexToColor.fontBorderColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            "$leftTime",
                            style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                              // color: HexToColor.greenColor,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 30,
                    // width: 100,
                    padding: const EdgeInsets.only(bottom: 2, top: 2, right: 3, left: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: HexToColor.fontBorderColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Подробнее",
                          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white
                              // color: HexToColor.greenColor,
                              ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          // height: 25,
                          // width: 25,
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: HexToColor.fontBorderColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
