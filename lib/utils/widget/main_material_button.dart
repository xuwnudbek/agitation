import 'package:agitation/utils/hex_to_color.dart';
import 'package:flutter/material.dart';

class MainMaterialButton extends StatelessWidget {
  MainMaterialButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.text,
    this.enabled = true,
  });
  Color color;
  Function onPressed;
  String text;
  bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: enabled ? color : HexToColor.disableColor, borderRadius: BorderRadius.circular(50)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => enabled ? onPressed() : null,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 45,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
