import 'package:agitation/models/task/task.dart';
import 'package:agitation/pages/finished_order_info/finished_order_info.dart';
import 'package:agitation/pages/home/view/order/provider/order_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:agitation/utils/widget/main_card_to_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FinishedOrderPage extends StatelessWidget {
  const FinishedOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OrderProvider>(
        create: (context) => OrderProvider(),
        builder: (context, snapshot) {
          return Scaffold(
            body: SafeArea(
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
                                const SizedBox(width: 20),
                                Text(
                                  // "${provider.countTotal}",
                                  "${orderProvider.finTasks.length}",
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
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "finished_tasks".tr,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            // color: HexToColor.fontBorderColor,
                          ),
                        ),
                      ),
                      orderProvider.isLoading
                          ? Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: CPIndicator(),
                            )
                          : Expanded(
                              child: RefreshIndicator(
                                onRefresh: () => orderProvider.refresh(),
                                child: orderProvider.finTasks.isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "no_finished_tasks".tr,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: HexToColor.fontBorderColor),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: orderProvider.finTasks.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          Task task = Task.fromJson(orderProvider.finTasks[index]);
                                          return MainCardToTitle(
                                            task: task,
                                            isFinished: true,
                                            onPressed: () {
                                              Get.to(() => FinishedOrderInfo(id: task.id));
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
        });
  }
}
