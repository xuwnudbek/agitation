import 'package:agitation/models/task/task.dart';
import 'package:agitation/pages/about_order/about_order_page.dart';
import 'package:agitation/pages/chat/chat_page.dart';
import 'package:agitation/pages/home/provider/home_provider.dart';
import 'package:agitation/pages/home/view/order/provider/order_provider.dart';
import 'package:agitation/pages/notification/notification_page.dart';
import 'package:agitation/utils/extensions.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:agitation/utils/widget/main_card_to_title.dart';
import 'package:agitation/utils/widget/tab_bar_widget/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:badges/badges.dart' as badge;

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeProvider>(create: (context) => HomeProvider()),
          ChangeNotifierProvider<OrderProvider>(create: (context) => OrderProvider()),
        ],
        builder: (context, snapshot) {
          // Function moderation = Provider.of<ModerationProvider>(context, listen: false).onInit;
          return Consumer<HomeProvider>(
            builder: (context, homeProvider, _) {
              //OrderProvider
              return Scaffold(
                body: SafeArea(
                  //HomeProvider
                  child: Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/icon_order.svg",
                                      color: HexToColor.fontBorderColor,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "order".tr,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      "${orderProvider.countTotal ?? 0}",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: HexToColor.fontBorderColor),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => NotificationPage());
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: HexToColor.detailsColor,
                                        child: Icon(
                                          Icons.notifications_none_outlined,
                                          color: Colors.white,
                                        ),
                                      ).withBadge(
                                        context,
                                        showBadge: context.watch<HomeProvider>().alertCount > 0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => ChatPage());
                                      },
                                      child: badge.Badge(
                                        showBadge: context.watch<HomeProvider>().msgCount > 0,
                                        badgeStyle: badge.BadgeStyle(
                                          badgeColor: Colors.transparent,
                                        ),
                                        badgeContent: DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.red,
                                          ),
                                          child: SizedBox(
                                            width: 7,
                                            height: 7,
                                          ).marginOnly(right: 10, top: 10),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: HexToColor.detailsColor,
                                          child: SvgPicture.asset(
                                            "assets/images/icon_comment.svg",
                                            color: Colors.white,
                                          ),
                                        ).withBadge(
                                          context,
                                          showBadge: context.watch<HomeProvider>().msgCount > 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          orderProvider.groupName == null
                              ? SizedBox.shrink()
                              : Text(
                                  "${orderProvider.groupName}",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: HexToColor.fontBorderColor,
                                  ),
                                ),
                          SizedBox(height: 10),
                          Text(
                            "${"command_statistic".tr}:",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              // color: HexToColor.fontBorderColor,
                            ),
                          ),
                          Container(
                            height: 120,
                            margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 16),
                            decoration: BoxDecoration(color: HexToColor.backgroundColor, borderRadius: BorderRadius.circular(100)),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Positioned(
                                      left: 12,
                                      bottom: 7,
                                      child: Container(
                                        height: 106,
                                        width: 106,
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                                      ),
                                    ),
                                    Container(
                                      height: 130,
                                      width: 130,
                                      child: SfCircularChart(borderWidth: 0, margin: const EdgeInsets.symmetric(vertical: 0), enableMultiSelection: true, series: <PieSeries<_PieData, String>>[
                                        PieSeries<_PieData, String>(
                                          // explode: true,
                                          explodeIndex: 0,
                                          dataSource: orderProvider.isLoading
                                              ? []
                                              : orderProvider.allTasks.length == orderProvider.finTasks.length
                                                  ? orderProvider.allTasks.length == 0
                                                      ? [
                                                          _PieData("aa", 1, "0%", Colors.red),
                                                        ]
                                                      : [
                                                          _PieData("aa", 1, "100%", HexToColor.greenColor),
                                                        ]
                                                  : [
                                                      _PieData(
                                                        "aa",
                                                        100 / orderProvider.allTasks.length * orderProvider.finTasks.length,
                                                        "${(100 / orderProvider.allTasks.length * orderProvider.finTasks.length).toStringAsFixed(1)}%",
                                                        HexToColor.fontBorderColor,
                                                      ),
                                                      _PieData(
                                                        "a",
                                                        100 / orderProvider.allTasks.length * (orderProvider.allTasks.length - orderProvider.finTasks.length),
                                                        "${(100 / orderProvider.allTasks.length * (orderProvider.allTasks.length - orderProvider.finTasks.length)).toStringAsFixed(1)}%",
                                                        HexToColor.detailsColor,
                                                      ),
                                                    ], // pieData,
                                          xValueMapper: (_PieData data, _) => data.xData,
                                          yValueMapper: (_PieData data, _) => data.yData,
                                          dataLabelMapper: (_PieData data, _) => data.text,
                                          pointColorMapper: (_PieData data, _) => data.color,
                                          dataLabelSettings: const DataLabelSettings(
                                            isVisible: true,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: ScrollConfiguration(
                                    behavior: MyScrollBehavior(),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                                        child: orderProvider.isNull
                                            ? Center(
                                                child: Text(
                                                  "group_not_found".tr,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: HexToColor.fontBorderColor,
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: orderProvider.teamWorkers.map((e) {
                                                  return Container(
                                                    constraints: BoxConstraints(minWidth: 200),
                                                    margin: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                                                    padding: EdgeInsets.only(left: 1),
                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                      Icon(
                                                        Icons.account_circle_outlined,
                                                        color: HexToColor.fontBorderColor,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "${e.name![0] + "." + e.surname!}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: HexToColor.fontBorderColor,
                                                        ),
                                                      )
                                                    ]),
                                                  );
                                                }).toList(),
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: TabBarWidget(
                              colorFirstTab: HexToColor.fontBorderColor,
                              colorSecondTab: HexToColor.fontBorderColor,
                              onSelected: (value) {
                                homeProvider.onTab(value);
                              },
                              textFirstTab: "new".tr,
                              textSecondTab: "performed".tr,
                              selectItem: homeProvider.indexItem,
                              count1: orderProvider.newTasks.length,
                              count2: orderProvider.allTasks.length - orderProvider.finTasks.length,
                            ),
                          ),
                          orderProvider.isLoading
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CPIndicator(),
                                )
                              : homeProvider.indexItem == 0
                                  ? Expanded(
                                      child: orderProvider.newTasks.isEmpty
                                          ? RefreshIndicator(
                                              onRefresh: () => orderProvider.refresh(),
                                              child: ListView.builder(
                                                itemCount: 1,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 20.0),
                                                        child: Text(
                                                          "no_tasks".tr,
                                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: HexToColor.fontBorderColor),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            )
                                          : RefreshIndicator(
                                              onRefresh: () => orderProvider.refresh(),
                                              child: ListView.builder(
                                                itemCount: orderProvider.newTasks.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  Task task = Task.fromJson(orderProvider.newTasks[index]);
                                                  return MainCardToTitle(
                                                    task: task,
                                                    onPressed: () async {
                                                      var res = await Get.to(() => AboutOrderPage(id: task.id));
                                                      (res);
                                                      if (res == true) {
                                                        orderProvider.refresh();
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                    )
                                  : Expanded(
                                      child: orderProvider.progTasks.isEmpty
                                          ? RefreshIndicator(
                                              onRefresh: () => orderProvider.refresh(),
                                              child: ListView.builder(
                                                itemCount: 1,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 20),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "no_tasks".tr,
                                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: HexToColor.fontBorderColor),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : RefreshIndicator(
                                              onRefresh: () => orderProvider.refresh(),
                                              child: ListView.builder(
                                                itemCount: orderProvider.progTasks.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  Task task = Task.fromJson(orderProvider.progTasks[index]);
                                                  return MainCardToTitle(
                                                    task: task,
                                                    onPressed: () async {
                                                      var res = await Get.to(() => AboutOrderPage(id: task.id));
                                                      if (res ?? true) {
                                                        orderProvider.refresh();
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                    ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text, this.color);
  final String xData;
  final num yData;
  final String text;
  final Color color;
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    // This method is responsible for customizing the scroll color
    return GlowingOverscrollIndicator(
      child: child,
      axisDirection: axisDirection,
      color: Colors.transparent, // Specify your desired scroll color here
      showLeading: false,
      showTrailing: false,
    );
  }
}
