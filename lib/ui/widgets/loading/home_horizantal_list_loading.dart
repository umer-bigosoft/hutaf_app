import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeHorizantalListLoading extends StatelessWidget {
  const HomeHorizantalListLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            right: layoutSize.width * 0.035,
            left: layoutSize.width * 0.035,
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.shimmerBackground,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              width: layoutSize.width * 0.27,
              height: layoutSize.width * 0.027,
              color: AppColors.shimmerBackground,
            ),
          ),
        ),
        SizedBox(height: layoutSize.height * 0.03),
        Container(
          width: layoutSize.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              right: layoutSize.width * 0.035,
              top: layoutSize.height * 0.01,
            ),
            child: Row(
              children: [
                for (int i = 0; i < 6; i++)
                  Row(
                    children: [
                      Column(
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
                      ),
                      SizedBox(width: layoutSize.width * 0.03),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
