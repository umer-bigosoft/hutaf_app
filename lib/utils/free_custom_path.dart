import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.moveTo(0.5 * size.width, size.height);
    path.lineTo(size.width, 0.5 * size.height);
    path.lineTo(size.width, 0.8 * size.height);
    path.lineTo(0.8 * size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
