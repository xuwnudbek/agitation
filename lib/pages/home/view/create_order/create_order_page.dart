import 'package:agitation/models/task/task.dart';
import 'package:agitation/pages/create_order/create_organization.dart';
import 'package:agitation/pages/create_order/provider/organization_provider.dart';
import 'package:agitation/pages/finished_order_info/finished_order_info.dart';
import 'package:agitation/pages/home/provider/home_provider.dart';
import 'package:agitation/pages/notification/notification_page.dart';
import 'package:agitation/utils/extensions.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:agitation/utils/widget/main_card_to_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrganizationProvider>(
      create: (context) => OrganizationProvider(),
      builder: (context, snapshot) {
        return Consumer<OrganizationProvider>(
          builder: (context, orderProvider, child) => Scaffold(
            body: SafeArea(
              child: Column(
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
                            const SizedBox(width: 20),
                            Text(
                              // "${provider.countTotal}",
                              "${orderProvider.tasks.length}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: HexToColor.fontBorderColor),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              // color: Colors.red,
                              width: 50,
                              height: 40,
                            ),
                            Positioned(
                              left: 10,
                              child: InkWell(
                                onTap: () {
                                  Get.to(const NotificationPage());
                                },
                                child: CircleAvatar(
                                  backgroundColor: HexToColor.detailsColor,
                                  child: Icon(
                                    Icons.notifications_none_outlined,
                                    color: Colors.white,
                                  ),
                                ).withBadge(context, showBadge: context.watch<HomeProvider>().alertCount > 0),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              // context
                              //         .watch<CenterProvider>()
                              //         .sum !=
                              //     0,
                              child: Positioned(
                                  top: 12,
                                  bottom: 11,
                                  child: Container(
                                    width: 17,
                                    // height: 10,
                                    decoration: BoxDecoration(color: HexToColor.fontBorderColor, borderRadius: BorderRadius.circular(40), border: Border.all(width: 1.5, color: Colors.white)),
                                    child: Center(
                                        child: Text(
                                      // context
                                      //     .watch<CenterProvider>()
                                      //     .sum
                                      //     .toString(),
                                      "",
                                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                                    )),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "add_new_org".tr,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        // color: HexToColor.fontBorderColor,
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    decoration: BoxDecoration(color: HexToColor.backgroundColor.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (orderProvider.hasGroup) {
                            await Get.to(() => CreateOrganization());
                            orderProvider.refresh();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: orderProvider.hasGroup ? HexToColor.fontBorderColor : HexToColor.fontBorderColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.add_circle_outline_outlined,
                            color: orderProvider.hasGroup ? Colors.white : Colors.white.withOpacity(0.5),
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  ),
                  orderProvider.isLoading
                      ? Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: CPIndicator(),
                        )
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async => orderProvider.refresh(),
                            child: ListView.builder(
                              itemCount: orderProvider.tasks.length,
                              itemBuilder: (BuildContext context, int index) {
                                Task task = orderProvider.tasks[index];
                                return orderProvider.tasks.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Center(child: Text("Нет данных")),
                                      )
                                    : MainCardToTitle(
                                        task: task,
                                        onPressed: () {
                                          Get.to(FinishedOrderInfo(id: task.id));
                                        },
                                      );
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
