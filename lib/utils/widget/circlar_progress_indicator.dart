import 'package:agitation/utils/hex_to_color.dart';
import 'package:agitation/utils/widget/loading_indicator.dart';
import 'package:flutter/material.dart';

class CPIndicator extends StatelessWidget {
  CPIndicator({super.key, this.color, this.weight = 4, this.size = const Size(20, 20)});

  Color? color = HexToColor.fontBorderColor;
  double weight;
  Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: LoadingIndicator(
        color: color == HexToColor.mainColor ? color : HexToColor.fontBorderColor,
        size: size.width,
      ),

      // child: CircularProgressIndicator(
      //   color: color,
      //   strokeWidth: weight,
      // ),
    );
  }
}
