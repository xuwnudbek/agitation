import 'package:agitation/pages/sign_in/provider/sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/main_material_button.dart';
import 'package:agitation/utils/widget/main_text_field.dart';
import 'package:agitation/utils/widget/main_text_field_password/main_text_field_password.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInProvider>(
      create: (context) => SignInProvider(context),
      child: Consumer<SignInProvider>(builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          body: provider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: HexToColor.mainColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Text(
                          "sign_in_title".tr,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: MainTextField(
                          title: "username".tr,
                          hintText: "username".tr,
                          controller: provider.username,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: MainTextFieldPassword(
                          title: "password".tr,
                          hintText: "",
                          controller: provider.password,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
                        child: MainMaterialButton(
                            onPressed: () {
                              provider.onSignIn();
                            },
                            color: HexToColor.greenColor,
                            text: "sign_up_button_access".tr),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
