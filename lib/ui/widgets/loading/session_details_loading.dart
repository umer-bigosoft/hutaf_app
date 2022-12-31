import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SessionDetailsLoading extends StatelessWidget {
  const SessionDetailsLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: layoutSize.height * 0.03,
      ),
      children: [
        Shimmer.fromColors(
          baseColor: AppColors.shimmerBackground,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            width: layoutSize.width,
            height: layoutSize.height * 0.3,
            color: AppColors.shimmerBackground,
          ),
        ),
        SizedBox(height: layoutSize.height * 0.053),
        Shimmer.fromColors(
          baseColor: AppColors.shimmerBackground,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            width: layoutSize.width * 0.4,
            height: layoutSize.width * 0.027,
            margin: EdgeInsets.only(
              right: layoutSize.width * 0.035,
              left: layoutSize.width * 0.035,
            ),
            color: AppColors.shimmerBackground,
          ),
        ),
        SizedBox(height: layoutSize.height * 0.03),
        Shimmer.fromColors(
          baseColor: AppColors.shimmerBackground,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            width: layoutSize.width * 0.4,
            height: layoutSize.width * 0.027,
            margin: EdgeInsets.only(
              right: layoutSize.width * 0.035,
              left: layoutSize.width * 0.035,
            ),
            color: AppColors.shimmerBackground,
          ),
        ),
        SizedBox(height: layoutSize.height * 0.03),
        Shimmer.fromColors(
          baseColor: AppColors.shimmerBackground,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(
            width: layoutSize.width * 0.4,
            height: layoutSize.width * 0.027,
            margin: EdgeInsets.only(
              right: layoutSize.width * 0.035,
              left: layoutSize.width * 0.035,
            ),
            color: AppColors.shimmerBackground,
          ),
        ),
      ],
    );
  }
}
