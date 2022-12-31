import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double lineWidth;
  final Color lineColor;
  final double marginBottom, marginTop, marginRight, marginLeft;

  const CustomDivider(
      {Key key,
      this.lineWidth,
      this.lineColor,
      this.marginBottom = 0,
      this.marginTop = 0,
      this.marginRight = 0,
      this.marginLeft = 0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
            bottom: marginBottom,
            top: marginTop,
            right: marginRight,
            left: marginLeft),
        width: lineWidth,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: lineColor,
            ),
          ),
        ),
      ),
    );
  }
}
