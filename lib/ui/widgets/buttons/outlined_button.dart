import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutlinedButton extends StatelessWidget {
  final Function handler;
  final String text;
  final double buttonWidth;
  final double buttonHeight;
  final double fontSize;
  final TextStyle textStyle;
  final EdgeInsetsGeometry margin;

  const OutlinedButton(
      {Key key,
      this.handler,
      this.text,
      this.buttonWidth,
      this.buttonHeight,
      this.fontSize,
      this.textStyle,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 1,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: AppColors.darkPink,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            textScaleFactor: 1,
            style: textStyle == null
                ? Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: fontSize,
                    )
                : textStyle,
          ),
        ),
      ),
      onPressed: handler,
    );
  }
}
