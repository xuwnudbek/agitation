import 'package:agitation/pages/home/view/order/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:agitation/utils/widget/tab_bar_widget/provider/tab_bar_widget_provider.dart';
import 'package:provider/provider.dart';

class TabBarWidget extends StatelessWidget {
  TabBarWidget({
    super.key,
    required this.onSelected,
    required this.colorFirstTab,
    required this.colorSecondTab,
    required this.textFirstTab,
    required this.textSecondTab,
    required this.selectItem,
    this.count = 0,
  });
  Function onSelected;
  Color colorFirstTab;
  Color colorSecondTab;
  String textFirstTab;
  String textSecondTab;
  int selectItem;
  int count;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TabBarWidgetProvider>(
      create: (context) => TabBarWidgetProvider(),
      child: Consumer<TabBarWidgetProvider>(builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: MainMaterialTabButton(
                onButton: selectItem == 0,
                color: colorFirstTab,
                onPressed: () {
                  provider.onSelectedItem(0);
                  onSelected(0);
                },
                children: [
                  Text(
                    textFirstTab,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selectItem == 0 ? Colors.white : colorFirstTab,
                    ),
                  ),
                  Consumer<OrderProvider>(
                    builder: (context, value, child) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      child: CircleAvatar(
                        backgroundColor: selectItem != 0 ? colorFirstTab : Colors.white,
                        child: value.isLoading
                            ? SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.blueGrey,
                                ),
                              )
                            : Text(
                                count > 5 ? "5+" : "$count",
                                style: TextStyle(fontSize: 12, color: selectItem == 0 ? colorFirstTab : Colors.white, fontWeight: FontWeight.w500),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: MainMaterialTabButton(
                color: colorSecondTab,
                onPressed: () {
                  provider.onSelectedItem(1);
                  onSelected(1);
                },
                onButton: selectItem == 1,
                children: [
                  Text(
                    textSecondTab,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: selectItem != 1 ? colorSecondTab : Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

class MainMaterialTabButton extends StatelessWidget {
  MainMaterialTabButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.children,
    this.borderRadius = 50,
    this.height = 34,
    required this.onButton,
  });
  Color color;
  Function onPressed;
  List<Widget> children;
  double borderRadius;
  double height;
  bool onButton;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: color), color: onButton ? color : null, borderRadius: BorderRadius.circular(borderRadius)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed(),
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            height: height,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
