import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NoteListItemLoading extends StatelessWidget {
  const NoteListItemLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          top: layoutSize.height * 0.03, bottom: layoutSize.height * 0.03),
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
                  child: Icon(
                    Icons.book_rounded,
                    color: AppColors.shimmerBackground,
                    size: layoutSize.width * 0.055,
                  ),
                ),
                SizedBox(width: layoutSize.width * 0.02),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: AppColors.shimmerBackground,
                        highlightColor: AppColors.shimmerHighlight,
                        child: Container(
                          width: layoutSize.width * 0.4,
                          height: layoutSize.width * 0.027,
                          color: AppColors.shimmerBackground,
                        ),
                      ),
                      SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: AppColors.shimmerBackground,
                        highlightColor: AppColors.shimmerHighlight,
                        child: Container(
                          width: layoutSize.width * 0.25,
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
          SizedBox(width: layoutSize.width * 0.02),
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
              SizedBox(height: 8),
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
          )
        ],
      ),
    );
  }
}
