import 'package:flutter/material.dart';
import 'package:agitation/utils/hex_to_color.dart';

class MainTextField extends StatelessWidget {
  MainTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.title,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });
  String title;
  String hintText;
  TextEditingController? controller;
  TextInputType keyboardType;
  var inputFormatters;

  @override
  Widget build(BuildContext context) {
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
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            controller: controller,
            validator: (string) {
              return "";
            },
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              hintText: hintText,
              fillColor: HexToColor.greyTextFieldColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
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
                borderSide: BorderSide(color: HexToColor.mainColor, width: 1),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MainTextFieldNumber extends StatelessWidget {
  MainTextFieldNumber({
    super.key,
    this.controller,
    required this.hintText,
    required this.title,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });
  String title;
  String hintText;
  TextEditingController? controller;
  TextInputType keyboardType;
  var inputFormatters;

  @override
  Widget build(BuildContext context) {
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
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            controller: controller,
            validator: (string) {
              return "";
            },
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              hintText: hintText,
              fillColor: HexToColor.greyTextFieldColor,
              filled: true,
              prefixText: "+998 ",
              
              prefixStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  // color: Colors.black,
                  ),
              // prefix: Text(
              //   "sd",
              // ),
              enabledBorder: OutlineInputBorder(
                // gapPadding: 10,
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
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
                borderSide: BorderSide(color: HexToColor.mainColor, width: 1),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
