import 'package:flutter/material.dart';

class ActiveIndicator extends StatelessWidget {
  ActiveIndicator({super.key, required this.visible});
  bool visible;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      width: 17,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(50)),
      child: Visibility(
        visible: visible,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white70, borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}
