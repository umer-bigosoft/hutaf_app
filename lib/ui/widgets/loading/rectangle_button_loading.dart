import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RectangleButtonLoading extends StatelessWidget {
  final String text;
  const RectangleButtonLoading({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(
          top: layoutSize.height * 0.027,
          bottom: layoutSize.height * 0.027,
        ),
        color: AppColors.lightGrey3,
        child: Center(
          child: Shimmer.fromColors(
            highlightColor: AppColors.shimmerHighlight,
            baseColor: AppColors.lightGrey2,
            child: Text(
              text,
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: layoutSize.width * 0.05,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
