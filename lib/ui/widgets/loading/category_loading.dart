import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryLoading extends StatelessWidget {
  const CategoryLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Container(
      width: layoutSize.width * 0.6,
      // padding: EdgeInsets.only(right: 20, left: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.shimmerBackground,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.shimmerBackground,
            highlightColor: AppColors.shimmerHighlight,
            child: Icon(
              Icons.circle,
              size: layoutSize.width * 0.07,
              color: AppColors.shimmerBackground,
            ),
          ),
          SizedBox(height: layoutSize.height * 0.01),
          Shimmer.fromColors(
            baseColor: AppColors.shimmerBackground,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              width: layoutSize.width * 0.15,
              height: layoutSize.width * 0.027,
              color: AppColors.shimmerBackground,
            ),
          ),
        ],
      ),
    );
  }
}
