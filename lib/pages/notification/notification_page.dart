import 'package:agitation/pages/notification/provider/notification_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationProvider>(
        create: (context) => NotificationProvider(),
        builder: (context, snapshot) {
          return Consumer<NotificationProvider>(builder: (ctx, provider, _) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: HexToColor.fontBorderColor,
                title: Row(
                  children: [
                    // Icon(Icons.notifications_rounded),
                    // SizedBox(width: 10),
                    Text(
                      "notification".tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await _buildDialog(context).then((value) {
                        if (value) provider.deleteAllNotification();
                      });
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await provider.getNotifications();
                },
                child: ListView(
                  children: provider.notifications.map((e) {
                    return _notificationTile(e, provider.isTodayRecieved(e["date"]));
                  }).toList(),
                ),
              ),
            );
          });
        });
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
            "assets/images/delete.svg",
            width: 75,
          ),
          content: Text(
            "delete_msg".tr,
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

  Widget _notificationTile(Map notification, bool isTodayRecieved) {
    // isTodayRecieved = false;

    return Container(
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isTodayRecieved ? HexToColor.fontBorderColor : HexToColor.fontBorderColor.withOpacity(0.8),
        boxShadow: isTodayRecieved
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ListTile(
        onTap: () {},
        minLeadingWidth: 30,
        leading: Icon(
          isTodayRecieved ? Icons.notifications_rounded : Icons.notifications_none_rounded,
          size: 30,
          color: isTodayRecieved ? Colors.white : Colors.grey[50],
          shadows: isTodayRecieved
              ? [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  ),
                ]
              : null,
        ),
        title: Text(
          "${notification["text"]}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5),
              Text(
                "${notification["type"]} | ${notification["date"]}",
                style: TextStyle(
                  color: isTodayRecieved ? Colors.white : Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
