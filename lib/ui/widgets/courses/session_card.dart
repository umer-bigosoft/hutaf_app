import 'package:Hutaf/models/courses/session_model.dart';
import 'package:Hutaf/providers/main/sessions_provider.dart';
import 'package:Hutaf/ui/views/main/courses/session_details.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionCard extends StatelessWidget {
  final SessionModel session;
  final String courseImage;
  final bool purchased;
  final int index;
  final String courseId;
  const SessionCard(this.session,
      {Key key, this.courseImage, this.purchased, this.index, this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
        bottom: layoutSize.height * 0.025,
      ),
      padding: EdgeInsets.only(
        right: layoutSize.width * 0.015,
        left: layoutSize.width * 0.015,
        bottom: layoutSize.height * 0.015,
        top: layoutSize.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: Provider.of<SessionsProvider>(context).reachedSession != '' &&
                Provider.of<SessionsProvider>(context).reachedSession ==
                    session.id
            ? AppColors.lightPurple2
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        minSize: 1,
        padding: EdgeInsets.zero,
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
                    height: 50,
                    width: 70,
                    imageUrl: courseImage,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.courseImagePlaceholder),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.courseImagePlaceholder),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 50,
                  //   width: 70,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(7),
                  //     image: DecorationImage(
                  //       image: NetworkImage(courseImage),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width: layoutSize.width * 0.03),
                  Expanded(
                    child: Text(
                      session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1,
                      style:
                          Theme.of(context).primaryTextTheme.headline2.copyWith(
                                fontSize: layoutSize.width * 0.035,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            // CupertinoButton(
            //   minSize: 1,
            //   padding: EdgeInsets.zero,
            // child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Duration(seconds: session.duration)
                      .toString()
                      .split('.')
                      .first
                      .padLeft(8, "0"),
                  textScaleFactor: 1,
                  style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                        fontSize: layoutSize.width * 0.032,
                        fontFamily: Assets.englishFontName,
                      ),
                ),
                // Row(
                //   children: [
                //     Icon(
                //       Icons.download_rounded,
                //       size: layoutSize.width * 0.03,
                //       color: AppColors.darkPink,
                //     ),
                //     SizedBox(width: 3),
                //     Text(
                //       'course_details.download'.tr(),
                //       textScaleFactor: 1,
                //       style:
                //           Theme.of(context).textTheme.bodyText1.copyWith(
                //                 fontSize: layoutSize.width * 0.027,
                //               ),
                //     )
                //   ],
                // ),
                // Row(
                //   children: [
                //     Icon(
                //       Icons.lock_rounded,
                //       size: layoutSize.width * 0.03,
                //       color: AppColors.darkGrey,
                //     ),
                //     SizedBox(width: 3),
                //     Container(
                //       margin: EdgeInsets.only(top: 5),
                //       child: Text(
                //         'course_details.locked'.tr(),
                //         textScaleFactor: 1,
                //         style: Theme.of(context)
                //             .accentTextTheme
                //             .headline3
                //             .copyWith(
                //               fontSize: layoutSize.width * 0.027,
                //             ),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
            // onPressed: () {},
            // ),
          ],
        ),
        onPressed: () async {
          // if (purchased || (!purchased && index == 0)) {
          ///
          ///
          Provider.of<SessionsProvider>(context, listen: false)
              .updateSession(courseId, session.id);

          ///
          ///
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionDetails(
                session,
                courseId: courseId,
              ),
            ),
          );
        },
      ),
    );
  }
}
