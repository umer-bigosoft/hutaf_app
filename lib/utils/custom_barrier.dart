import 'package:flutter/material.dart';

class CustomBarrier extends StatelessWidget {
  final double opacity;
  final Color color;

  CustomBarrier({this.opacity = 0.65, this.color = Colors.black, key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: opacity,
        child: ModalBarrier(
          dismissible: false,
          color: color,
        ));
  }
}
