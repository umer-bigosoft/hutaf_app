import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookLoading extends StatelessWidget {
  const BookLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: AppColors.shimmerBackground,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            width: layoutSize.height * 0.18,
            height: layoutSize.height * 0.23,
            decoration: BoxDecoration(
              color: AppColors.shimmerBackground,
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
        SizedBox(height: 15),
        Shimmer.fromColors(
          baseColor: AppColors.shimmerBackground,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            width: layoutSize.width * 0.24,
            height: layoutSize.width * 0.027,
            color: AppColors.shimmerBackground,
          ),
        ),
        SizedBox(height: 7),
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
    );
  }
}
