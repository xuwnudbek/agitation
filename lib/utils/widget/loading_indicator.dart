import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({super.key, this.color = const Color.fromARGB(255, 255, 94, 0), this.size = 40});
  var color;
  double size;
  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.threeArchedCircle(
      color: color ?? Color.fromARGB(255, 255, 94, 0),
      size: size,
    );
  }
}
