import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/main/courses_provider.dart';
import '../../../utils/colors.dart';

class HomeCourseRow extends StatelessWidget {
  final String courseId;
  final String courseName;
  final double coursePrice;
  final String courseImage;
  final String trainerName;
  final bool directPlay;

  const HomeCourseRow({
    Key key,
    this.courseId = '',
    this.courseName = '',
    this.coursePrice = 0.0,
    this.courseImage = '',
    this.trainerName = '',
    this.directPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        width: layoutSize.width * 0.5,
        padding: EdgeInsets.all(8),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  courseName,
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.038,
                      ),
                ),
              ),
              CachedNetworkImage(
                height: layoutSize.height * 0.07,
                width: layoutSize.width * 0.18,
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
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      color: AppColors.lightOrange,
                      size: layoutSize.width * 0.1,
                    ),
                  ),
                  //
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () async {
        if (directPlay) {
          await Provider.of<CoursesProvider>(context, listen: false)
              .getDetails(courseId);
          Navigator.pushNamed(
            context,
            ScreensName.sessions,
            arguments: {
              'course':
                  Provider.of<CoursesProvider>(context, listen: false).course,
              'notifyRating': () => {},
            },
          );
        } else {
          Navigator.pushNamed(context, ScreensName.courseDetails,
              arguments: {'courseId': courseId});
        }
      },
    );
  }
}
