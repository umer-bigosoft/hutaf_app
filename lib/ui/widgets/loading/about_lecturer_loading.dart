import 'package:Hutaf/ui/widgets/loading/home_horizantal_list_loading.dart';
import 'package:Hutaf/ui/widgets/others/column_builder.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AboutLecturerLoading extends StatelessWidget {
  const AboutLecturerLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.shimmerBackground,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(
                    height: layoutSize.height * 0.17,
                    width: layoutSize.width * 0.3,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: layoutSize.height * 0.03),
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
          SizedBox(height: layoutSize.height * 0.065),
          ColumnBuilder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.shimmerBackground,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Container(
                      margin: EdgeInsets.only(
                        right: layoutSize.width * 0.045,
                        left: layoutSize.width * 0.045,
                      ),
                      width: layoutSize.width,
                      height: layoutSize.width * 0.027,
                      color: AppColors.shimmerBackground,
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              );
            },
          ),
          CustomDivider(
            lineWidth: layoutSize.width * 0.8,
            lineColor: AppColors.lightGrey3,
            marginTop: layoutSize.height * 0.04,
            marginBottom: layoutSize.height * 0.04,
          ),
          HomeHorizantalListLoading(),
          SizedBox(height: layoutSize.height * 0.05),
        ],
      ),
    );
  }
}
