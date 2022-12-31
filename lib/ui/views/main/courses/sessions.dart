import 'package:Hutaf/models/courses/course_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/courses_provider.dart';
import 'package:Hutaf/providers/main/sessions_provider.dart';
import 'package:Hutaf/ui/widgets/courses/session_card.dart';
import 'package:Hutaf/ui/widgets/loading/chapters_card_loading.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class Sessions extends StatefulWidget {
  final CourseModel course;
  final Function notifyRating;
  Sessions(this.course, this.notifyRating, {Key key}) : super(key: key);

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  bool _isInit = true;
  bool _isLoading = true;
  var purchased = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // print(widget.course.id);
      Provider.of<SessionsProvider>(context, listen: false)
          .getSessions(widget.course.id)
          .then((_) {
        purchased = //widget.course.price == 0 ||
            widget.course.purchasedBy
                .contains(FirebaseAuth.instance.currentUser?.uid);
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: layoutSize.height * 0.02),
            sessionHeader(layoutSize),
            CustomDivider(
              lineWidth: layoutSize.width * 0.8,
              lineColor: AppColors.lightGrey3,
              marginTop: layoutSize.height * 0.03,
              marginBottom: layoutSize.height * 0.04,
            ),
            Expanded(
              child: !_isLoading
                  ? Consumer<SessionsProvider>(
                      builder: (context, courseSessions, child) {
                        if (courseSessions.isSessionsEmpty) {
                          return EmptyResult(
                            text: 'لا توجد دروس مضافة !',
                          );
                        } else if (courseSessions.isSessionsError) {
                          return ErrorResult(
                            text:
                                'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب الدروس !',
                          );
                        } else {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: courseSessions.sessions.length,
                            padding: EdgeInsets.only(
                              top: layoutSize.height * 0.015,
                              bottom: layoutSize.height * 0.015,
                            ),
                            itemBuilder: (context, index) {
                              return SessionCard(
                                courseSessions.sessions[index],
                                courseImage: widget.course.image,
                                purchased: purchased,
                                index: index,
                                courseId: widget.course.id,
                              );
                            },
                          );
                        }
                      },
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 8,
                      padding: EdgeInsets.only(
                        top: layoutSize.height * 0.015,
                        bottom: layoutSize.height * 0.015,
                      ),
                      itemBuilder: (context, index) {
                        return ChaptersCardLoading();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sessionHeader(Size layoutSize) {
    return Container(
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
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
                CupertinoButton(
                  minSize: 1,
                  padding: EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.black,
                    size: layoutSize.width * 0.055,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: layoutSize.width * 0.03),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: layoutSize.width,
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          widget.course.name,
                          textScaleFactor: 1,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline3
                              .copyWith(
                                fontSize: layoutSize.width * 0.045,
                              ),
                        ),
                      ),
                      Text(
                        widget.course.trainerName,
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
          SizedBox(width: layoutSize.width * 0.04),
          purchased
              ? Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تقييم المحتوى',
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: layoutSize.width * 0.03,
                            ),
                      ),
                      RatingBar.builder(
                        initialRating: getRating(),
                        itemSize: 17,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 4,
                        unratedColor: AppColors.lightOrange,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.02),
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rounded,
                          color: AppColors.orange,
                          size: layoutSize.width * 0.04,
                        ),
                        onRatingUpdate: (rating) {
                          Provider.of<CoursesProvider>(context, listen: false)
                              .rateTheCourse(
                            rating,
                            widget.course.id,
                            Provider.of<AuthProvider>(context, listen: false)
                                .user
                                .uid,
                          );
                          calculateRate(rating);
                        },
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تقييم المحتوى',
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: layoutSize.width * 0.03,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.course.evaluation != null
                                ? widget.course.evaluation.toStringAsFixed(1)
                                : '0.0',
                            textScaleFactor: 1,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: layoutSize.width * 0.032,
                                      fontFamily: Assets.englishFontName,
                                    ),
                          ),
                          Icon(
                            Icons.star_rounded,
                            size: layoutSize.width * 0.035,
                            color: AppColors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  double getRating() {
    if (widget.course.evaluatedBy == null) return 0.0;

    return widget.course.evaluatedBy
        .singleWhere(
            (element) =>
                element['uid'] ==
                Provider.of<AuthProvider>(context, listen: false).user.uid,
            orElse: () => {
                  'uid': Provider.of<AuthProvider>(context, listen: false)
                      .user
                      .uid,
                  'rate': 0
                })['rate']
        .toDouble();
  }

  void calculateRate(rating) {
    var course = widget.course;
    if (course.evaluatedBy == null) course.evaluatedBy = [];
    course.evaluatedBy.removeWhere((element) =>
        element['uid'] ==
        Provider.of<AuthProvider>(context, listen: false).user.uid);
    course.evaluatedBy.add({
      'uid': Provider.of<AuthProvider>(context, listen: false).user.uid,
      'rate': rating
    });
    double total = 0;
    for (var i = 0; i < course.evaluatedBy.length; i++) {
      total += course.evaluatedBy[i]['rate'];
    }
    course.evaluation = total / course.evaluatedBy.length;
    widget.notifyRating();
  }
}
