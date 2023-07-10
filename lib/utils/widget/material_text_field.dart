import 'package:flutter/material.dart';
import 'package:agitation/utils/hex_to_color.dart';

class MaterialTextField extends StatelessWidget {
  MaterialTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.title,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLines = 1,
  });
  String title;
  String hintText;
  TextEditingController? controller;
  TextInputType keyboardType;
  var inputFormatters;
  int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, color: HexToColor.fontBorderColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexToColor.fontBorderColor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MaterialTextFieldComment extends StatelessWidget {
  MaterialTextFieldComment({
    super.key,
    this.controller,
    required this.hintText,
    required this.title,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLines = 1,
  });
  String title;
  String hintText;
  TextEditingController? controller;
  TextInputType keyboardType;
  var inputFormatters;
  int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, color: HexToColor.fontBorderColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              hintText: hintText,
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexToColor.fontBorderColor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MainMaterialTextFieldNumber extends StatelessWidget {
  MainMaterialTextFieldNumber({
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, color: HexToColor.fontBorderColor),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              hintText: hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              fillColor: Colors.white,
              filled: true,
              // prefixText: "+998 ",

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
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: HexToColor.fontBorderColor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
