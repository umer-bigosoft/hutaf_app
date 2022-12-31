import 'package:Hutaf/ui/widgets/others/column_builder.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:easy_localization/easy_localization.dart';

import 'button_loading.dart';
import 'home_horizantal_list_loading.dart';

class BookDetailsLoading extends StatelessWidget {
  const BookDetailsLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(height: layoutSize.height * 0.03),
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
                child: Shimmer.fromColors(
                  baseColor: AppColors.shimmerBackground,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(
                    height: layoutSize.height * 0.35,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBackground,
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              SizedBox(width: layoutSize.width * 0.02),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBackground,
                                  highlightColor: AppColors.shimmerHighlight,
                                  child: Container(
                                    width: layoutSize.width,
                                    height: layoutSize.width * 0.027,
                                    color: AppColors.shimmerBackground,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Shimmer.fromColors(
                                  baseColor: AppColors.shimmerBackground,
                                  highlightColor: AppColors.shimmerHighlight,
                                  child: Container(
                                    width: layoutSize.width,
                                    height: layoutSize.width * 0.027,
                                    color: AppColors.shimmerBackground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: layoutSize.height * 0.04),
                    LoadingButton(
                      text: 'book_details.listen'.tr(),
                      buttonHeight: layoutSize.width * 0.1,
                      buttonWidth: layoutSize.width,
                      fontSize: layoutSize.width * 0.045,
                    ),
                    SizedBox(height: layoutSize.height * 0.02),
                    LoadingButton(
                      text: 'book_details.pay'.tr(),
                      buttonHeight: layoutSize.width * 0.1,
                      buttonWidth: layoutSize.width,
                      fontSize: layoutSize.width * 0.045,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: layoutSize.height * 0.045),
        Container(
          margin: EdgeInsets.only(
            right: layoutSize.width * 0.035,
            left: layoutSize.width * 0.035,
          ),
          child: ColumnBuilder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Shimmer.fromColors(
                  baseColor: AppColors.shimmerBackground,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(
                    width: layoutSize.width,
                    height: layoutSize.width * 0.027,
                    color: AppColors.shimmerBackground,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: layoutSize.height * 0.045),
        CustomDivider(
          lineWidth: layoutSize.width * 0.6,
          lineColor: AppColors.lightGrey3,
        ),
        SizedBox(height: layoutSize.height * 0.045),
        HomeHorizantalListLoading(),
        SizedBox(height: layoutSize.height * 0.03),
      ],
    );
  }
}
