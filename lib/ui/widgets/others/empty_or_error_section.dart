import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyOrErrorSection extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  const EmptyOrErrorSection({Key key, this.imageUrl, this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Container(
      height: layoutSize.width * 0.54,
      width: layoutSize.width,
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
        top: layoutSize.height * 0.01,
      ),
      padding: EdgeInsets.only(
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey2,
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SvgPicture.asset(
              imageUrl,
              height: layoutSize.height * 0.2,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.04,
                      ),
                ),
                SizedBox(height: 7),
                Text(
                  subtitle,
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        fontSize: layoutSize.width * 0.055,
                        decoration: TextDecoration.underline,
                        decorationThickness: 8,
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
