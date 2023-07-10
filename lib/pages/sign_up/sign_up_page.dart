// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agitation/pages/sign_up/provider/sign_up_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/main_material_button.dart';
import 'package:agitation/utils/widget/main_text_field.dart';
import 'package:agitation/utils/widget/main_text_field_password/main_text_field_password.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpProvider>(
      create: (context) => SignUpProvider(context),
      child: Consumer<SignUpProvider>(builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          // resizeToAvoidBottomInset: false,
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          child: Text(
                            "sign_up_title".tr,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: MainTextField(
                                  title: "name".tr,
                                  hintText: "your_name".tr,
                                  keyboardType: TextInputType.text,
                                  controller: provider.name,
                                ),
                              ),
                              Expanded(
                                child: MainTextField(
                                  title: "last_name".tr,
                                  hintText: "your_last_name".tr,
                                  controller: provider.lastName,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: MainTextFieldNumber(
                            title: "phone".tr,
                            hintText: "(xx)xxx xx xx",
                            inputFormatters: [provider.maskFormatter],
                            keyboardType: TextInputType.phone,
                            controller: provider.phone,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: MainTextField(
                            title: "Username",
                            hintText: "username",
                            controller: provider.username,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                child: Text(
                                  "city".tr,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  iconStyleData: IconStyleData(
                                      icon: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(Icons.keyboard_arrow_down_sharp),
                                  )),
                                  hint: Text(
                                    "     ${"city".tr}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: provider.listBranch
                                      .map((item) => DropdownMenuItem<Map>(
                                            value: item,
                                            child: Text(
                                              "    " + item['name'],
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            ),
                                          ))
                                      .toList(),
                                  value: provider.selectBranchItem,
                                  onChanged: provider.onSelectItem,
                                  buttonStyleData: ButtonStyleData(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                      color: Colors.grey.shade300,
                                    ),
                                    width: Get.width,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                              // DropdownButtonFormField(
                              //   icon:
                              //       const Icon(Icons.keyboard_arrow_down_sharp),
                              //   decoration: InputDecoration(
                              //     contentPadding: const EdgeInsets.symmetric(
                              //         vertical: 0, horizontal: 20),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //           color: Colors.grey, width: 1),
                              //       borderRadius: BorderRadius.circular(50),
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderSide: const BorderSide(
                              //           color: Colors.red, width: 1),
                              //       borderRadius: BorderRadius.circular(50),
                              //     ),
                              //     filled: true,
                              //     fillColor: HexToColor.greyTextFieldColor,
                              //   ),
                              //   // dropdownColor: HexToColor.greyTextFieldColor,

                              //   onChanged: (newValue) {
                              //     provider.selectBranch =
                              //         provider.listBranch.indexOf(newValue);
                              //   },
                              //   items: provider.listBranch
                              //       .map<DropdownMenuItem<Map>>((value) {
                              //     return DropdownMenuItem<Map>(

                              //       value: value,
                              //       child: Text(
                              //         value['name'],
                              //         style: TextStyle(
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.w600),
                              //       ),
                              //     );
                              //   }).toList(),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: MainTextField(
                            title: "address".tr,
                            hintText: "Алишера навои 42",
                            controller: provider.address,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: MainTextFieldPassword(
                            title: "password".tr,
                            hintText: "",
                            controller: provider.password,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: MainTextFieldPassword(
                            title: "confirm_password".tr,
                            hintText: "",
                            controller: provider.password1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
                          child: MainMaterialButton(
                              onPressed: () {
                                provider.onPressedRegistration();
                              },
                              color: HexToColor.mainColor,
                              text: "sign_up_button".tr),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
