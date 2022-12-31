import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseRow extends StatelessWidget {
  final String courseId;
  final String courseName;
  final double coursePrice;
  final String courseImage;
  final String trainerName;
  const CourseRow({
    Key key,
    this.courseId = '',
    this.courseName = '',
    this.coursePrice = 0.0,
    this.courseImage = '',
    this.trainerName = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Column(
      children: [
        CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.zero,
          child: Container(
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
                      CachedNetworkImage(
                        height: 30,
                        width: 40,
                        imageUrl: courseImage,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.courseImagePlaceholder),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.courseImagePlaceholder),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 30,
                      //   width: 40,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: NetworkImage(courseImage),
                      //       fit: BoxFit.cover,
                      //     ),
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      // ),
                      SizedBox(width: layoutSize.width * 0.03),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.04,
                                  ),
                            ),
                            Text(
                              trainerName,
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.03,
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
                    Text(
                      coursePrice == 0
                          ? 'مجاني'
                          : coursePrice.toStringAsFixed(3) + ' ريال عُماني',
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline3.copyWith(
                            fontSize: layoutSize.width * 0.03,
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
          onPressed: () async {
            Navigator.pushNamed(context, ScreensName.courseDetails,
                arguments: {'courseId': courseId});
          },
        ),
        SizedBox(height: layoutSize.height * 0.03),
      ],
    );
  }
}
