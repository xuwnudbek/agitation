import 'package:agitation/models/task/status.dart';
import 'package:agitation/pages/add_client/provider/add_client_provider.dart';
import 'package:agitation/utils/widget/circlar_progress_indicator.dart';
import 'package:agitation/utils/widget/main_material_button.dart';
import 'package:agitation/utils/widget/material_text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../utils/hex_to_color.dart';

class AddClientPage extends StatelessWidget {
  AddClientPage({super.key, required this.taskId});

  final int taskId;
  var _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddClientProvider>(
      create: (context) => AddClientProvider(),
      child: Consumer<AddClientProvider>(builder: (context, provider, child) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: MainMaterialButton(
              onPressed: () {
                var id = provider.addClient(taskId);
                if (id != null) {
                  Get.back(result: id);
                }
              },
              color: HexToColor.fontBorderColor,
              text: "save".tr,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back)),
                        CircleAvatar(
                          backgroundColor: HexToColor.detailsColor,
                          child: SvgPicture.asset("assets/images/icon_comment.svg"),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _globalKey,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      // height: 200,
                      decoration: BoxDecoration(color: HexToColor.backgroundColor.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 42,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 16),
                            width: double.infinity,
                            decoration: BoxDecoration(color: HexToColor.fontBorderColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                            child: Center(
                              child: Text(
                                "Заполните форму",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: Column(
                              children: [
                                const SizedBox(height: 9),
                                MaterialTextField(
                                  hintText: "F.I.O",
                                  title: "Фамилия Имя Отчество:",
                                  controller: provider.fioController,
                                ),
                                SizedBox(height: 9),
                                MainMaterialTextFieldNumber(
                                  hintText: "+998 (xx) xxx xx xx",
                                  title: "Номер телефона:",
                                  keyboardType: TextInputType.phone,
                                  controller: provider.phoneController,
                                  inputFormatters: [
                                    provider.maskFormatter,
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                                  child: Text(
                                    "Статус:",
                                    style: TextStyle(fontWeight: FontWeight.w600, color: HexToColor.fontBorderColor),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                                  child: DropdownButtonHideUnderline(
                                    child: provider.listStatus.isEmpty
                                        ? OutlinedButton(
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              side: BorderSide(color: Colors.grey.shade400),
                                              backgroundColor: Colors.white,
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(padding: EdgeInsets.symmetric(vertical: 15), child: CPIndicator(color: HexToColor.fontBorderColor, weight: 2)),
                                              ],
                                            ),
                                          )
                                        : DropdownButton2(
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
                                            items: provider.listStatus
                                                .map((status) => DropdownMenuItem<Status>(
                                                      value: status,
                                                      child: Text(
                                                        "    " + status.title,
                                                        style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: provider.status,
                                            onChanged: (status) => provider.onSelectedStatus(status!),
                                            buttonStyleData: ButtonStyleData(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                ),
                                                color: Colors.white,
                                              ),
                                              width: Get.width,
                                            ),
                                            menuItemStyleData: const MenuItemStyleData(
                                              height: 40,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 9),
                                MaterialTextFieldComment(
                                  hintText: "",
                                  title: "Комментарий:",
                                  controller: provider.commentController,
                                  maxLines: 5,
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
