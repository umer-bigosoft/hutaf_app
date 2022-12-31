import 'dart:async';

import 'package:Hutaf/models/courses/course_model.dart';
import 'package:Hutaf/models/main/results_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/courses_provider.dart';
import 'package:Hutaf/providers/main/iap_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_title_only.dart';
import 'package:Hutaf/ui/widgets/loading/course_details_loading.dart';
import 'package:Hutaf/ui/widgets/others/custom_dialog.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CourseDetails extends StatefulWidget {
  final course;
  CourseDetails(this.course, {Key key}) : super(key: key);

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<CoursesProvider>(context, listen: false)
          .getDetails(widget.course['courseId'])
          .then((_) {
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
      appBar: AppBarTitleOnly(
        title: '',
        actions: !_isLoading
            ? topActionBar(layoutSize)
            : topActionBarLoading(layoutSize),
      ),
      body: SafeArea(
        child: _isLoading
            ? CourseDetailsLoading()
            : Consumer<CoursesProvider>(
                builder: (context, coursesProvider, child) {
                  if (coursesProvider.isCourseDetailsEmpty) {
                    return EmptyResult(
                      text: 'course_details.no_details'.tr(),
                    );
                  } else if (coursesProvider.isCourseDetailsError) {
                    return ErrorResult(
                      text: 'course_details.unknown_error'.tr(),
                    );
                  } else {
                    return courseDetails(layoutSize, coursesProvider.course,
                        coursesProvider.isCourseAvailable);
                  }
                },
              ),
      ),
    );
  }

  List<Widget> topActionBar(Size layoutSize) {
    return [
      Consumer<CoursesProvider>(
        builder: (context, coursesProvider, child) {
          if (!coursesProvider.isCourseDetailsEmpty &&
              !coursesProvider.isCourseDetailsError) {
            return CupertinoButton(
              minSize: 1,
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.share_rounded,
                color: AppColors.darkPink,
                size: layoutSize.width * 0.05,
              ),
              onPressed: () {
                coursesProvider.shareBook(coursesProvider.course.name,
                    coursesProvider.course.trainerName);
              },
            );
          } else {
            return Container();
          }
        },
      ),
      SizedBox(width: layoutSize.width * 0.04),
      CupertinoButton(
        minSize: 1,
        padding: EdgeInsets.only(left: layoutSize.width * 0.035),
        child: Icon(
          Icons.close_rounded,
          color: AppColors.darkGrey,
          size: layoutSize.width * 0.062,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ];
  }

  List<Widget> topActionBarLoading(Size layoutSize) {
    return [
      Shimmer.fromColors(
        baseColor: AppColors.shimmerBackground,
        highlightColor: AppColors.shimmerHighlight,
        child: Icon(
          Icons.share_rounded,
          color: AppColors.shimmerBackground,
          size: layoutSize.width * 0.05,
        ),
      ),
      SizedBox(width: layoutSize.width * 0.04),
      Container(
        padding: EdgeInsets.only(left: layoutSize.width * 0.035),
        child: Shimmer.fromColors(
          baseColor: AppColors.shimmerBackground,
          highlightColor: AppColors.shimmerHighlight,
          child: Icon(
            Icons.close_rounded,
            color: AppColors.shimmerBackground,
            size: layoutSize.width * 0.062,
          ),
        ),
      ),
    ];
  }

  Widget courseDetails(
      Size layoutSize, CourseModel course, bool isCourseAvailable) {
    // print(course.duration);
    return Column(
      children: [
        SizedBox(height: layoutSize.height * 0.01),
        titleContainer(layoutSize, course),
        SizedBox(height: layoutSize.height * 0.04),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              CachedNetworkImage(
                height: layoutSize.height * 0.27,
                imageUrl: course.image,
                placeholder: (context, url) => Container(
                  margin: EdgeInsets.only(
                    right: layoutSize.width * 0.035,
                    left: layoutSize.width * 0.035,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.courseImagePlaceholder),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  margin: EdgeInsets.only(
                    right: layoutSize.width * 0.035,
                    left: layoutSize.width * 0.035,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.courseImagePlaceholder),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  margin: EdgeInsets.only(
                    right: layoutSize.width * 0.035,
                    left: layoutSize.width * 0.035,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              SizedBox(height: layoutSize.height * 0.04),
              lecturerContainer(layoutSize, course),
              SizedBox(height: layoutSize.height * 0.04),
              Container(
                margin: EdgeInsets.only(
                  right: layoutSize.width * 0.035,
                  left: layoutSize.width * 0.035,
                ),
                child: Text(
                  'course_details.duration'.tr(
                    args: [
                      Duration(seconds: course.duration)
                          .toString()
                          .split('.')
                          .first
                          .padLeft(8, "0")
                    ],
                  ),
                  textScaleFactor: 1,
                  style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                        fontSize: layoutSize.width * 0.045,
                      ),
                ),
              ),
              SizedBox(height: layoutSize.height * 0.025),
              Container(
                margin: EdgeInsets.only(
                  right: layoutSize.width * 0.035,
                  left: layoutSize.width * 0.035,
                ),
                child: Text(
                  course.description,
                  textScaleFactor: 1,
                  style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                        fontSize: layoutSize.width * 0.04,
                      ),
                ),
              ),
              SizedBox(height: layoutSize.height * 0.045),
            ],
          ),
        ),
        bottomBarActions(layoutSize, course, isCourseAvailable),
      ],
    );
  }

  Widget bottomBarActions(
      Size layoutSize, CourseModel course, bool isCourseAvailable) {
    // var purchased = Provider.of<AuthProvider>(context, listen: false)
    //     .isPurchased(course: course);
    var purchased;
    if (Provider.of<AuthProvider>(context, listen: false).user != null) {
      purchased = course.purchasedBy
          .contains(Provider.of<AuthProvider>(context, listen: false).user.uid);
    } else {
      purchased = false;
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(
          right: layoutSize.width * 0.04,
          left: layoutSize.width * 0.04,
          top: layoutSize.height * 0.033,
          bottom: layoutSize.height * 0.033,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrey3,
              offset: Offset(0, -3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<CoursesProvider>(
              builder: (context, provider, child) {
                return !purchased
                    ? !provider.isPayButtonLoading
                        ? CupertinoButton(
                            minSize: 1,
                            padding: EdgeInsets.zero,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  isCourseAvailable || course.price == 0
                                      ? Icons.attach_money
                                      : Icons.lock,
                                  color: isCourseAvailable || course.price == 0
                                      ? AppColors.darkPink
                                      : AppColors.darkGrey,
                                  size: layoutSize.width * 0.055,
                                ),
                                SizedBox(width: layoutSize.width * 0.01),
                                Text(
                                  'course_details.pay'.tr(),
                                  textScaleFactor: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontSize: layoutSize.width * 0.045,
                                        color: isCourseAvailable ||
                                                course.price == 0
                                            ? AppColors.darkPink
                                            : AppColors.darkGrey,
                                      ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              if (Provider.of<AuthProvider>(context,
                                      listen: false)
                                  .isLoggedIn) {
                                if (!isCourseAvailable && course.price != 0)
                                  return;

                                if (course.price == 0) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return CustomDialog(
                                        title: 'course_details.purchase_title'
                                                .tr(args: [course.name]) +
                                            '\n' +
                                            'course_details.purchase_free'.tr(),
                                        buttonText:
                                            'course_details.purchase_yes'.tr(),
                                        buttonHandler: () async {
                                          // purchase free course
                                          provider.puchaseFree(course.id,
                                              onDone: purchaseResults);
                                          // setState(() {
                                          //   _isPayButtonLoading = true;
                                          // });
                                          // HttpsCallable _purchaseFree =
                                          //     FirebaseFunctions.instance
                                          //         .httpsCallable(
                                          //             'purchaseFreeCourse');

                                          // final results = await _purchaseFree(
                                          //     {'courseId': course.id});
                                          // String message = results.data['success']
                                          //     ? 'course_details.purchase_completed'
                                          //     : 'course_details.purchase_failed_' +
                                          //         results.data['error'];
                                          // print(results.data['data']);
                                          // setState(() {
                                          //   _isPayButtonLoading = false;
                                          // });
                                          // showSimpleNotification(
                                          //   Text(
                                          //     message.tr(),
                                          //     textScaleFactor: 1,
                                          //     style: Theme.of(context)
                                          //         .textTheme
                                          //         .headline1
                                          //         .copyWith(
                                          //           fontSize:
                                          //               layoutSize.width * 0.037,
                                          //         ),
                                          //   ),
                                          //   background: results.data['success']
                                          //       ? AppColors.purple
                                          //       : AppColors.pink,
                                          //   duration: Duration(milliseconds: 1000),
                                          // );
                                          // if (results.data['success']) {
                                          //   course.purchasedBy.add(FirebaseAuth
                                          //       .instance.currentUser?.uid);
                                          //   setState(() {});
                                          // }
                                          Navigator.pop(context);
                                        },
                                        textButtonText:
                                            'course_details.purchase_no'.tr(),
                                        textHandler: () {
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                }
                                // else if (Provider.of<AuthProvider>(context,
                                //         listen: false)
                                //     .subscription
                                //     .active) {
                                //   showDialog(
                                //     context: context,
                                //     barrierDismissible: false,
                                //     builder: (context) {
                                //       return CustomDialog(
                                //         title: 'course_details.purchase_title'
                                //                 .tr(args: [course.name]) +
                                //             '\n' +
                                //             'course_details.purchase_points'.tr(),
                                //         buttonText:
                                //             'course_details.purchase_yes'.tr(),
                                //         buttonHandler: () async {
                                //           // pay with points
                                //           setState(() {
                                //             _isPayButtonLoading = true;
                                //           });
                                //           HttpsCallable callable = FirebaseFunctions
                                //               .instance
                                //               .httpsCallable(
                                //                   'purchaseCourseWithPoints');

                                //           final results = await callable(
                                //               {'courseId': course.id});
                                //           String message = results.data['success']
                                //               ? 'course_details.purchase_completed'
                                //               : 'course_details.purchase_failed_' +
                                //                   results.data['error'];
                                //           print(results.data['data']);
                                //           setState(() {
                                //             _isPayButtonLoading = false;
                                //           });
                                //           showSimpleNotification(
                                //             Text(
                                //               message.tr(),
                                //               textScaleFactor: 1,
                                //               style: Theme.of(context)
                                //                   .textTheme
                                //                   .headline1
                                //                   .copyWith(
                                //                     fontSize:
                                //                         layoutSize.width * 0.037,
                                //                   ),
                                //             ),
                                //             background: results.data['success']
                                //                 ? AppColors.purple
                                //                 : AppColors.pink,
                                //             duration: Duration(milliseconds: 1000),
                                //           );
                                //           if (results.data['success']) {
                                //             course.purchasedBy.add(FirebaseAuth
                                //                 .instance.currentUser?.uid);
                                //             setState(() {});
                                //           }

                                //           Navigator.pop(context);
                                //           Provider.of<AuthProvider>(context,
                                //                   listen: false)
                                //               .loadUserData();
                                //         },
                                //         textButtonText:
                                //             'course_details.purchase_no'.tr(),
                                //         textHandler: () {
                                //           Navigator.pop(context);
                                //         },
                                //       );
                                //     },
                                //   );
                                // }
                                else {
                                  // pay with store

                                  var product = Provider.of<CoursesProvider>(
                                          context,
                                          listen: false)
                                      .storeProduct;
                                  Provider.of<IAPProvider>(context,
                                          listen: false)
                                      .purchase(
                                    product: product,
                                    type: 'COURSE',
                                    doc: course.id,
                                    onSuccess: purchaseSucceed,
                                    onError: purchaseFailed,
                                  );
                                  provider.isPayButtonLoading = true;
                                  provider.notify();
                                }
                              } else {
                                showSimpleNotification(
                                  Text(
                                    'course_details.login_first'.tr(),
                                    textScaleFactor: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(
                                          fontSize: layoutSize.width * 0.037,
                                        ),
                                  ),
                                  background: AppColors.pink,
                                  duration: Duration(milliseconds: 1000),
                                );
                                Timer(Duration(milliseconds: 1200), () {
                                  Navigator.pushNamed(
                                      context, ScreensName.login);
                                });
                              }
                            },
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: AppColors.shimmerBackground,
                                highlightColor: AppColors.shimmerHighlight,
                                child: Icon(
                                  isCourseAvailable || course.price == 0
                                      ? Icons.attach_money
                                      : Icons.lock,
                                  color: AppColors.shimmerBackground,
                                  size: layoutSize.width * 0.055,
                                ),
                              ),
                              SizedBox(width: layoutSize.width * 0.01),
                              Shimmer.fromColors(
                                baseColor: AppColors.shimmerBackground,
                                highlightColor: AppColors.shimmerHighlight,
                                child: Text(
                                  'course_details.pay'.tr(),
                                  textScaleFactor: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontSize: layoutSize.width * 0.045,
                                        color: AppColors.shimmerBackground,
                                      ),
                                ),
                              ),
                            ],
                          )
                    : CupertinoButton(
                        minSize: 1,
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_rounded,
                              color: AppColors.darkGrey,
                              size: layoutSize.width * 0.055,
                            ),
                            SizedBox(width: layoutSize.width * 0.01),
                            Text(
                              'المزيد',
                              textScaleFactor: 1,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .copyWith(
                                    fontSize: layoutSize.width * 0.045,
                                  ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (Provider.of<AuthProvider>(context, listen: false)
                              .isLoggedIn) {
                            Navigator.pushNamed(
                              context,
                              ScreensName.sessions,
                              arguments: {
                                'course': course,
                                'notifyRating': () => setState(() {}),
                              },
                            );
                          } else {
                            showSimpleNotification(
                              Text(
                                'course_details.login_first'.tr(),
                                textScaleFactor: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                      fontSize: layoutSize.width * 0.037,
                                    ),
                              ),
                              background: AppColors.pink,
                              duration: Duration(milliseconds: 1000),
                            );
                            Timer(Duration(milliseconds: 1200), () {
                              Navigator.pushNamed(context, ScreensName.login);
                            });
                          }
                        });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget lecturerContainer(Size layoutSize, CourseModel course) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.only(
          right: layoutSize.width * 0.045,
          left: layoutSize.width * 0.045,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   'assets/images/boy.svg',
            //   height: layoutSize.height * 0.075,
            // ),
            // SizedBox(width: layoutSize.width * 0.03),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.trainerName,
                    textScaleFactor: 1,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: layoutSize.width * 0.04,
                        ),
                  ),
                  SizedBox(height: 2),
                  if (course.trainerJob != null)
                    Text(
                      course.trainerJob,
                      textScaleFactor: 1,
                      style:
                          Theme.of(context).primaryTextTheme.headline6.copyWith(
                                fontSize: layoutSize.width * 0.028,
                              ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, ScreensName.aboutLecturer,
            arguments: {'id': course.trainerId});
      },
    );
  }

  Widget titleContainer(Size layoutSize, CourseModel course) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  textScaleFactor: 1,
                  style: Theme.of(context).primaryTextTheme.headline3.copyWith(
                        fontSize: layoutSize.width * 0.05,
                      ),
                ),
                Text(
                  course.price == 0
                      ? 'course_details.free'.tr()
                      : 'course_details.currency'
                          .tr(args: [course.price.toStringAsFixed(3)]),
                  textScaleFactor: 1,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontSize: layoutSize.width * 0.035,
                      ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.star_rounded,
                size: layoutSize.width * 0.05,
                color: AppColors.orange,
              ),
              SizedBox(width: layoutSize.width * 0.02),
              Text(
                course.evaluation != null
                    ? course.evaluation.toStringAsFixed(1)
                    : '0.0',
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.04,
                      fontFamily: Assets.englishFontName,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void purchaseResults(results) {
    final Size layoutSize = MediaQuery.of(context).size;
    String message = results.data['success']
        ? 'course_details.purchase_completed'
        : 'course_details.purchase_failed_' + results.data['error'];
    // print(results.data['data']);
    showSimpleNotification(
      Text(
        message.tr(),
        textScaleFactor: 1,
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: layoutSize.width * 0.037,
            ),
      ),
      background: results.data['success'] ? AppColors.purple : AppColors.pink,
      duration: Duration(milliseconds: 1000),
    );

    setState(() {});
  }

  void purchaseSucceed() {
    // print('completed');
    Provider.of<CoursesProvider>(context, listen: false)
        .course
        .purchasedBy
        .add(FirebaseAuth.instance.currentUser?.uid);
    Provider.of<CoursesProvider>(context, listen: false).isPayButtonLoading =
        false;
    Provider.of<CoursesProvider>(context, listen: false).notify();
    Map<String, dynamic> data = {};
    data['success'] = true;
    purchaseResults(ResultsModel(data));
  }

  void purchaseFailed() {
    Provider.of<CoursesProvider>(context, listen: false).isPayButtonLoading =
        false;
    Provider.of<CoursesProvider>(context, listen: false).notify();
    Map<String, dynamic> data = {};
    data['success'] = false;
    data['error'] = 'unknown';
    purchaseResults(ResultsModel(data));
  }
}
