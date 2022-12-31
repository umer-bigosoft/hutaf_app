import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  final String courseId;
  final String courseName;
  final double coursePrice;
  final String courseImage;
  final String trainerName;
  const CourseItem(
      {Key key,
      this.courseId = '',
      this.courseName = '',
      this.coursePrice = 0.0,
      this.courseImage = '',
      this.trainerName = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        width: layoutSize.height * 0.3,
        margin: EdgeInsets.only(left: 13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: layoutSize.height * 0.23,
              imageUrl: courseImage,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.courseImagePlaceholder),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.courseImagePlaceholder),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Container()
                  //
                  ),
            ),
            // Container(
            //   height: layoutSize.height * 0.23,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: NetworkImage(courseImage),
            //       fit: BoxFit.cover,
            //     ),
            //     borderRadius: BorderRadius.circular(13),
            //   ),
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //       height: layoutSize.height * 0.05,
            //       decoration: BoxDecoration(
            //         color: AppColors.lightGrey2,
            //         borderRadius: BorderRadius.only(
            //           bottomRight: Radius.circular(13),
            //           bottomLeft: Radius.circular(13),
            //         ),
            //       ),
            //       child: Center(
            //         child: Text(
            //           coursePrice == 0
            //               ? 'مجاني'
            //               : coursePrice.toStringAsFixed(3) + ' ريال عُماني',
            //           textScaleFactor: 1,
            //           style: Theme.of(context).textTheme.headline3.copyWith(
            //                 fontSize: layoutSize.width * 0.028,
            //               ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(right: 2, left: 2),
              child: Text(
                courseName,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: layoutSize.width * 0.038,
                    ),
              ),
            ),
            SizedBox(height: 1),
            Container(
              margin: EdgeInsets.only(right: 2, left: 2),
              child: Text(
                trainerName,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.028,
                    ),
              ),
            )
          ],
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, ScreensName.courseDetails,
            arguments: {'courseId': courseId});
      },
    );
  }
}
