import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/main_text_field_password/provider/main_text_field_password_provider.dart';
import 'package:provider/provider.dart';

class MainTextFieldPassword extends StatelessWidget {
  MainTextFieldPassword({
    super.key,
    this.controller,
    required this.hintText,
    required this.title,
  });
  String title;
  String hintText;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainTextFieldPasswordProvider>(
      create: (context) => MainTextFieldPasswordProvider(),
      child: Consumer<MainTextFieldPasswordProvider>(
          builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: TextFormField(
                controller: controller,
                obscureText: provider.obscureText,
                validator: (string) {
                  return "";
                },
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  suffixIcon: IconButton(
                    icon: SvgPicture.asset(provider.selectedSvg),
                    onPressed: () =>provider.onPressedEye(),
                  ),
                  suffixIconColor: Colors.black,
                  hintText: hintText,
                  fillColor: HexToColor.greyTextFieldColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: HexToColor.mainColor, width: 1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
