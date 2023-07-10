import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:agitation/pages/sign_in/sign_in_page.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/main_material_button.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset("assets/images/logo.svg"),
              const SizedBox(
                height: 32,
              ),
              Container(
                height: Get.height * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: HexToColor.redContainerColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "confirmation_title".tr,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Image.asset("assets/images/confirmation1.png"),
                    SvgPicture.asset(
                      "assets/images/agitation_icon.svg",
                      height: Get.height * 0.2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 23, horizontal: 40),
                      child: Text(
                        "confirmation_subtitle_title".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Padding(
                padding: const EdgeInsets.all(10),
                child: MainMaterialButton(
                  color: HexToColor.greenColor,
                  onPressed: () {
                    Get.offAll(const SignInPage());
                  },
                  text: "confirmation_button".tr,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
