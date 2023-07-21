import 'package:agitation/pages/main_page/main_page.dart';
import 'package:agitation/pages/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/main_button_navigation_bar/provider/main_button_navigation_bar_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class MainButtonNavigationBar extends StatelessWidget {
  MainButtonNavigationBar({
    super.key,
    required this.onSelected,
  });
  Function onSelected;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainButtonNavigationBarProvider>(
      create: (context) => MainButtonNavigationBarProvider(),
      child: Consumer<MainButtonNavigationBarProvider>(builder: (context, provider, child) {
        return Container(
          // margin:
          //     const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          height: 66,
          decoration: BoxDecoration(color: HexToColor.detailsOtherColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainButtonNavigationBarItem(
                svgIcon: "assets/images/icon_order.svg",
                title: "order".tr,
                onTap: (value) {
                  provider.onTab(value);
                  onSelected(value);
                },
                item: 0,
                selectItem: provider.indexItem,
              ),
              MainButtonNavigationBarItem(
                svgIcon: "assets/images/icon_ready.svg",
                title: "finished".tr,
                onTap: (value) {
                  provider.onTab(value);
                  onSelected(value);
                },
                item: 1,
                selectItem: provider.indexItem,
              ),
              MainButtonNavigationBarItem(
                svgIcon: "assets/images/icon_add_order.svg",
                title: "add_order".tr,
                onTap: (value) {
                  provider.onTab(value);
                  onSelected(value);
                },
                item: 2,
                selectItem: provider.indexItem,
              ),
              MainButtonNavigationBarItem(
                svgIcon: "assets/images/icon_person.svg",
                title: "profile".tr,
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("exit".tr),
                        content: Text("exit_text".tr),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text("no".tr),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              await Hive.box("db").clear();
                              await Future.delayed(Duration(milliseconds: 500));
                              Get.offAll(() => MainPage());
                            },
                            child: Text("yes".tr),
                          ),
                        ],
                      );
                    },
                  );
                },
                onTap: (value) {
                  provider.onTab(value);
                  onSelected(value);
                },
                item: 3,
                selectItem: provider.indexItem,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class MainButtonNavigationBarItem extends StatelessWidget {
  MainButtonNavigationBarItem({
    super.key,
    required this.onTap,
    required this.selectItem,
    required this.svgIcon,
    required this.title,
    required this.item,
    this.onLongPress,
  });
  Function onTap;
  Function? onLongPress;
  String svgIcon;
  String title;
  int selectItem;
  int item;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onLongPress: () => onLongPress?.call(),
        onTap: () => onTap(item),
        child: Column(
          children: [
            const SizedBox(height: 5),
            CircleAvatar(
              // margin: const EdgeInsets.all(5),
              // padding: ,
              // decoration: BoxDecoration(
              //   color: item == selectItem ? Colors.white : Colors.transparent,
              //   borderRadius: BorderRadius.circular(50),
              // ),
              backgroundColor: item == selectItem ? Colors.white : Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      svgIcon,
                      color: item == selectItem ? HexToColor.fontBorderColor : Colors.white,
                    ),
                    const SizedBox(height: 3),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 1),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
