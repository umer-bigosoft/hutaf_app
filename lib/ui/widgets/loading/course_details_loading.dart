import 'package:Hutaf/ui/widgets/others/column_builder.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CourseDetailsLoading extends StatelessWidget {
  const CourseDetailsLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: layoutSize.height * 0.01),
        Container(
          margin: EdgeInsets.only(
            right: layoutSize.width * 0.035,
            left: layoutSize.width * 0.035,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.shimmerBackground,
                      highlightColor: AppColors.shimmerHighlight,
                      child: Container(
                        width: layoutSize.width * 0.55,
                        height: layoutSize.width * 0.027,
                        color: AppColors.shimmerBackground,
                      ),
                    ),
                    SizedBox(height: layoutSize.height * 0.015),
                    Shimmer.fromColors(
                      baseColor: AppColors.shimmerBackground,
                      highlightColor: AppColors.shimmerHighlight,
                      child: Container(
                        width: layoutSize.width * 0.35,
                        height: layoutSize.width * 0.027,
                        color: AppColors.shimmerBackground,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.shimmerBackground,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Icon(
                      Icons.star_rounded,
                      size: layoutSize.width * 0.05,
                      color: AppColors.shimmerBackground,
                    ),
                  ),
                  SizedBox(width: layoutSize.width * 0.02),
                  Shimmer.fromColors(
                    baseColor: AppColors.shimmerBackground,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Container(
                      width: layoutSize.width * 0.1,
                      height: layoutSize.width * 0.027,
                      color: AppColors.shimmerBackground,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: layoutSize.height * 0.04),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.shimmerBackground,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(
                  height: layoutSize.height * 0.32,
                  width: layoutSize.width,
                  margin: EdgeInsets.only(
                    right: layoutSize.width * 0.035,
                    left: layoutSize.width * 0.035,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              SizedBox(height: layoutSize.height * 0.04),
              Container(
                margin: EdgeInsets.only(
                  right: layoutSize.width * 0.045,
                  left: layoutSize.width * 0.045,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SvgPicture.asset(
                    //   'assets/images/boy.svg',
                    //   height: layoutSize.height * 0.075,
                    // ),
                    // SizedBox(width: layoutSize.width * 0.03),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: AppColors.shimmerBackground,
                            highlightColor: AppColors.shimmerHighlight,
                            child: Container(
                              width: layoutSize.width * 0.55,
                              height: layoutSize.width * 0.027,
                              color: AppColors.shimmerBackground,
                            ),
                          ),
                          SizedBox(height: 10),
                          Shimmer.fromColors(
                            baseColor: AppColors.shimmerBackground,
                            highlightColor: AppColors.shimmerHighlight,
                            child: Container(
                              width: layoutSize.width * 0.35,
                              height: layoutSize.width * 0.027,
                              color: AppColors.shimmerBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: layoutSize.height * 0.055),
              Container(
                margin: EdgeInsets.only(
                  right: layoutSize.width * 0.035,
                  left: layoutSize.width * 0.035,
                ),
                child: ColumnBuilder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Shimmer.fromColors(
                          baseColor: AppColors.shimmerBackground,
                          highlightColor: AppColors.shimmerHighlight,
                          child: Container(
                            height: layoutSize.width * 0.027,
                            color: AppColors.shimmerBackground,
                          ),
                        ),
                        SizedBox(height: layoutSize.height * 0.025),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
