import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final double buttonWidth;
  final double buttonHeight;
  final double fontSize;
  final EdgeInsetsGeometry margin;

  const LoadingButton(
      {Key key,
      this.text,
      this.buttonWidth,
      this.buttonHeight,
      this.fontSize,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.lightGrey3,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Shimmer.fromColors(
          highlightColor: AppColors.shimmerHighlight,
          baseColor: AppColors.lightGrey2,
          child: Text(
            text,
            textScaleFactor: 1,
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: fontSize,
                ),
          ),
        ),
      ),
    );
  }
}
