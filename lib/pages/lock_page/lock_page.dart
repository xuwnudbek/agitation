import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:get/get.dart';
import 'package:agitation/models/lock_indicator.dart';
import 'package:agitation/pages/lock_page/provider/lock_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/active_indicator.dart';

import 'package:agitation/utils/widget/number_panel.dart';
import 'package:provider/provider.dart';

class LockPage extends StatelessWidget {
  LockPage({super.key, required this.indicator});
  LockIndicator indicator;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LockProvider>(
      create: (context) => LockProvider(indicator),
      child: Consumer<LockProvider>(builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: HexToColor.fontBorderColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("${Hive.box("db").get("lock")}"),
                // Text("${provider.configurationButton}"),
                Visibility(
                  visible: provider.indicator != LockIndicator.ON,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                        child: Text(
                  provider.titleText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ))),
                ShakeWidget(
                  autoPlay: provider.animateError,
                  duration: const Duration(milliseconds: 500),
                  shakeConstant: ShakeRotateConstant1(),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(10), color: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        provider.isText
                            ? Text(
                                provider.getPassword(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                children: [
                                  ActiveIndicator(
                                    visible: provider.lockPassword[0] != "",
                                  ),
                                  ActiveIndicator(
                                    visible: provider.lockPassword[1] != "",
                                  ),
                                  ActiveIndicator(
                                    visible: provider.lockPassword[2] != "",
                                  ),
                                  ActiveIndicator(
                                    visible: provider.lockPassword[3] != "",
                                  ),
                                ],
                              ),
                        GestureDetector(
                            onTap: () => provider.onEyeOnPressed(),
                            child: Icon(
                              provider.isText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: InkWell(
                          onTap: () => provider.onReset(),
                          child: Visibility(
                            visible: provider.reset,
                            child: Text(
                              "reset".tr,
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          )),
                    )
                  ],
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: provider.configurationButton,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(color: provider.lockPassword[3] == "" ? Colors.grey : HexToColor.greenColor, borderRadius: BorderRadius.circular(10)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => provider.configuration(),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 45,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  "confirmation".tr,
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    NumberPanel(
                        backgroundColor: HexToColor.fontBorderColor,
                        textColor: Colors.white,
                        onPressed: (value) {
                          if (value == "-") {
                            provider.onPressedBackspace();
                          } else if (value != "*") {
                            provider.onPressedNumber(value);
                          } else {
                            provider.checkFingerprint();
                          }
                        }),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
