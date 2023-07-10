import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:agitation/pages/select_language/provider/select_language_provider.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:provider/provider.dart';

class SelectLanguage extends StatelessWidget {
  const SelectLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectLanguageProvider(),
      child:
          Consumer<SelectLanguageProvider>(builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: HexToColor.mainColor,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.arrow_back)),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "edit_language".tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ButtonMainMaterial(
                            onPressed: () => provider.editLanguage("uz"),
                            text: "O'zbek",
                          ),
                          ButtonMainMaterial(
                            onPressed: () => provider.editLanguage("ru"),
                            text: "Русский",
                          ),
                        ],
                      ),
                      const SizedBox(),
                    ],
                  ),
          ),
        );
      }),
    );
  }
}

class ButtonMainMaterial extends StatelessWidget {
  ButtonMainMaterial({
    super.key,
    required this.onPressed,
    required this.text,
  });
  String text;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
          color: HexToColor.mainColor, borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => onPressed(),
        borderRadius: BorderRadius.circular(10),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        )),
      ),
    );
  }
}
