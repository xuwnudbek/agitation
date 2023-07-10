import 'package:agitation/pages/sign_in/sign_in_page.dart';
import 'package:agitation/pages/sign_up/sign_up_page.dart';
import 'package:agitation/utils/widget/main_material_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../../utils/hex_to_color.dart';
import 'provider/access_provider.dart';

class AccessPage extends StatelessWidget {
  const AccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccessProvider>(
      create: (context) => AccessProvider(),
      child: Consumer<AccessProvider>(builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(),
                    SvgPicture.asset("assets/images/logo.svg"),
                    const SizedBox(height: 10),
                    Text(
                      "title_access".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "subtitle_access".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "bottom_access".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 25),
                    SvgPicture.asset("assets/images/agitation_icon.svg"),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MainMaterialButton(
                  color: HexToColor.mainColor,
                  onPressed: () {
                    Get.to(() => SignUpPage());
                  },
                  text: "sign_in_button_access".tr,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text("or".tr, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                MainMaterialButton(
                  color: HexToColor.greenColor,
                  onPressed: () {
                    Get.to(() => SignInPage());
                  },
                  text: "sign_up_button_access".tr,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
