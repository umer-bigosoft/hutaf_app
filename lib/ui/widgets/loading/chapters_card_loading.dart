import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChaptersCardLoading extends StatelessWidget {
  const ChaptersCardLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
        bottom: layoutSize.height * 0.025,
      ),
      padding: EdgeInsets.only(
        right: layoutSize.width * 0.015,
        left: layoutSize.width * 0.015,
        bottom: layoutSize.height * 0.015,
        top: layoutSize.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.shimmerBackground,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(
                    height: 50,
                    width: 70,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBackground,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
                SizedBox(width: layoutSize.width * 0.03),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: AppColors.shimmerBackground,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Container(
                      width: layoutSize.width * 0.4,
                      height: layoutSize.width * 0.027,
                      color: AppColors.shimmerBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBackground,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(
                  width: layoutSize.width * 0.15,
                  height: layoutSize.width * 0.027,
                  color: AppColors.shimmerBackground,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.shimmerBackground,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Icon(Icons.download_rounded,
                        size: layoutSize.width * 0.03,
                        color: AppColors.shimmerBackground),
                  ),
                  SizedBox(width: 3),
                  Shimmer.fromColors(
                    baseColor: AppColors.shimmerBackground,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Container(
                      width: layoutSize.width * 0.2,
                      height: layoutSize.width * 0.027,
                      color: AppColors.shimmerBackground,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
