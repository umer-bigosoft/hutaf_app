import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SearchLoading extends StatelessWidget {
  const SearchLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: layoutSize.width * 0.01,
                    left: layoutSize.width * 0.01,
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
                                height: 40,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.shimmerBackground,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                            SizedBox(width: layoutSize.width * 0.03),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerBackground,
                                    highlightColor: AppColors.shimmerHighlight,
                                    child: Container(
                                      width: layoutSize.width * 0.45,
                                      height: layoutSize.width * 0.027,
                                      color: AppColors.shimmerBackground,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerBackground,
                                    highlightColor: AppColors.shimmerHighlight,
                                    child: Container(
                                      width: layoutSize.width * 0.3,
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
                      SizedBox(width: layoutSize.width * 0.05),
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       '4.5',
                          //       textScaleFactor: 1,
                          //       style: Theme.of(context).textTheme.headline6.copyWith(
                          //             fontSize: layoutSize.width * 0.032,
                          //             fontFamily: Assets.englishFontName,
                          //           ),
                          //     ),
                          //     Icon(
                          //       Icons.star_rounded,
                          //       size: layoutSize.width * 0.035,
                          //       color: AppColors.orange,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: layoutSize.height * 0.03),
              ],
            );
          },
        ),
      ),
    );
  }
}
