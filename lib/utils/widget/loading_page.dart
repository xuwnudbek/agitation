import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({super.key, this.color});

  Color? color = Colors.white.withOpacity(0.1);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Container(
        width: 65,
        height: 65,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: LoadingIndicator(
          color: HexToColor.fontBorderColor,
        ),
        // child: CircularProgressIndicator(
        //   color: HexToColor.blackColor,
        // ),
      ),
    );
  }
}
