
import 'package:flutter/material.dart';

class MainMaterialIconButton extends StatelessWidget {
  MainMaterialIconButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.children,
  });
  Color color;
  Function onPressed;
  List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onPressed(),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 45,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
