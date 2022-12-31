import 'package:Hutaf/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeCarouselSliderLoading extends StatelessWidget {
  const HomeCarouselSliderLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 1,
        autoPlay: false,
      ),
      items: [
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          child: Stack(
            children: <Widget>[
              Shimmer.fromColors(
                highlightColor: AppColors.shimmerHighlight,
                baseColor: AppColors.shimmerBackground,
                child: Container(
                  color: AppColors.shimmerBackground,
                  width: 1000.0,
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          child: Stack(
            children: <Widget>[
              Shimmer.fromColors(
                highlightColor: AppColors.shimmerHighlight,
                baseColor: AppColors.shimmerBackground,
                child: Container(
                  color: AppColors.shimmerBackground,
                  width: 1000.0,
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          child: Stack(
            children: <Widget>[
              Shimmer.fromColors(
                highlightColor: AppColors.shimmerHighlight,
                baseColor: AppColors.shimmerBackground,
                child: Container(
                  color: AppColors.shimmerBackground,
                  width: 1000.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
