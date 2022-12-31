import 'package:Hutaf/ui/views/main/speical_needs_courses/special_needs_courses.dart';
import 'package:Hutaf/ui/widgets/app_bar/main_screens_app_bar.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: layoutSize.height * 0.03),
            MainScreensAppBar(),
            SizedBox(height: layoutSize.height * 0.025),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  librarySection(layoutSize, context),
                  coursesSection(layoutSize, context),
                  specialNeedsCoursesSection(layoutSize, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget librarySection(Size layoutSize, BuildContext context) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.only(
          right: layoutSize.width * 0.035,
          left: layoutSize.width * 0.035,
          top: layoutSize.height * 0.025,
          bottom: layoutSize.height * 0.025,
        ),
        // height: layoutSize.height * 0.25,
        width: layoutSize.width,
        color: AppColors.lightPurple,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'learn.library'.tr(),
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1
                            .copyWith(
                              fontSize: constraints.maxWidth * 0.07,
                            ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'learn.library_subtitle'.tr(),
                        textScaleFactor: 1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                              fontSize: constraints.maxWidth * 0.04,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: layoutSize.width * 0.03),
                SvgPicture.asset(
                  'assets/images/books.svg',
                  height: constraints.maxWidth * 0.4,
                ),
              ],
            );
          },
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, ScreensName.library);
      },
    );
  }

  Widget coursesSection(Size layoutSize, BuildContext context) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.only(
          right: layoutSize.width * 0.035,
          left: layoutSize.width * 0.035,
          top: layoutSize.height * 0.025,
          bottom: layoutSize.height * 0.025,
        ),
        // height: layoutSize.height * 0.25,
        width: layoutSize.width,
        color: AppColors.lightOrange,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/courses.svg',
                  height: constraints.maxWidth * 0.4,
                ),
                SizedBox(width: layoutSize.width * 0.03),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'مخصصات',
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1
                            .copyWith(
                              fontSize: constraints.maxWidth * 0.045,
                            ),
                      ),
                      Text(
                        'لغة الإشارة',
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1
                            .copyWith(
                              fontSize: constraints.maxWidth * 0.07,
                            ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'مناهج تعليمية تثقيفية ومعرفية بلغة الإشارة',
                        textScaleFactor: 1,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                              fontSize: constraints.maxWidth * 0.04,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, ScreensName.courses);
      },
    );
  }

  Widget specialNeedsCoursesSection(Size layoutSize, BuildContext context) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.only(
          right: layoutSize.width * 0.035,
          left: layoutSize.width * 0.035,
          top: layoutSize.height * 0.025,
          bottom: layoutSize.height * 0.025,
        ),
        // height: layoutSize.height * 0.25,
        width: layoutSize.width,
        color: AppColors.lightPink2,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'مخصصات',
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1
                            .copyWith(
                              fontSize: constraints.maxWidth * 0.045,
                            ),
                      ),
                      Text(
                        'ذوي الإعاقة البصرية',
                        textScaleFactor: 1,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline1
                            .copyWith(
                              fontSize: constraints.maxWidth * 0.07,
                            ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'مناهج تعليمية وتثقيفية مختلفة',
                        textScaleFactor: 1,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                              fontSize: constraints.maxWidth * 0.04,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: layoutSize.width * 0.03),
                SvgPicture.asset(
                  'assets/images/speical_needs_courses.svg',
                  height: constraints.maxWidth * 0.4,
                ),
              ],
            );
          },
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeicalNeedsCourses(),
          ),
        );
      },
    );
  }
}
