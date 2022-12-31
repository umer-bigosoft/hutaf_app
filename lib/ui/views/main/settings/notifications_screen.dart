import 'package:Hutaf/handler/notification_handler.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isInit = true;
  bool _isLoading = true;
  bool isBooksNotificationsSubscription;
  bool isCoursesNotificationsSubscription;
  bool isOthersNotificationsSubscription;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isBooksNotificationsSubscription =
          prefs.getBool('isBooksNotifications') ?? true;
      isCoursesNotificationsSubscription =
          prefs.getBool('isCoursesNotifications') ?? true;
      isOthersNotificationsSubscription =
          prefs.getBool('isOthersNotifications') ?? true;
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    final CustomDivider customDivider = CustomDivider(
      lineWidth: layoutSize.width,
      lineColor: AppColors.lightGrey3,
      marginBottom: layoutSize.height * 0.033,
      marginTop: layoutSize.height * 0.033,
    );
    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'التنبيهات',
      ),
      body: _isLoading
          ? ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                right: layoutSize.width * 0.035,
                left: layoutSize.width * 0.035,
                bottom: layoutSize.height * 0.04,
              ),
              children: [
                SizedBox(height: layoutSize.height * 0.025),
                loadingRow(layoutSize),
                customDivider,
                loadingRow(layoutSize),
                customDivider,
              ],
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                right: layoutSize.width * 0.035,
                left: layoutSize.width * 0.035,
                bottom: layoutSize.height * 0.04,
              ),
              children: [
                SizedBox(height: layoutSize.height * 0.025),
                CupertinoButton(
                  minSize: 1,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'تنبيهات الكتب الجديدة',
                          textScaleFactor: 1,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2
                              .copyWith(
                                fontSize: layoutSize.width * 0.042,
                              ),
                        ),
                      ),
                      SizedBox(width: layoutSize.width * 0.04),
                      CupertinoSwitch(
                        value: isBooksNotificationsSubscription,
                        onChanged: (value) {
                          booksSwitchHandler();
                        },
                      ),
                    ],
                  ),
                  onPressed: () {
                    booksSwitchHandler();
                  },
                ),
                customDivider,
                CupertinoButton(
                  minSize: 1,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'تنبيهات لمخصصات بلغة الإشارة الجديدة',
                          textScaleFactor: 1,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2
                              .copyWith(
                                fontSize: layoutSize.width * 0.042,
                              ),
                        ),
                      ),
                      SizedBox(width: layoutSize.width * 0.04),
                      CupertinoSwitch(
                        value: isCoursesNotificationsSubscription,
                        onChanged: (value) {
                          coursesSwitchHandler();
                        },
                      ),
                    ],
                  ),
                  onPressed: () {
                    coursesSwitchHandler();
                  },
                ),
                customDivider,
                CupertinoButton(
                  minSize: 1,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'التنبيهات الأخرى',
                          textScaleFactor: 1,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline2
                              .copyWith(
                                fontSize: layoutSize.width * 0.042,
                              ),
                        ),
                      ),
                      SizedBox(width: layoutSize.width * 0.04),
                      CupertinoSwitch(
                        value: isOthersNotificationsSubscription,
                        onChanged: (value) {
                          othersSwitchHandler();
                        },
                      ),
                    ],
                  ),
                  onPressed: () {
                    othersSwitchHandler();
                  },
                ),
                customDivider,
              ],
            ),
    );
  }

  Widget loadingRow(Size layoutSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: AppColors.shimmerBackground,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              width: layoutSize.width * 0.3,
              height: layoutSize.width * 0.027,
              color: AppColors.shimmerBackground,
            ),
          ),
        ),
        SizedBox(width: layoutSize.width * 0.15),
        CupertinoSwitch(
          value: false,
          onChanged: (value) {},
        ),
      ],
    );
  }

  void coursesSwitchHandler() {
    NotificationHandler()
        .coursesNotificationSubscriptionHandler()
        .then((value) {
      if (value == 1) {
        setState(() {
          isCoursesNotificationsSubscription = true;
        });
      } else if (value == 0) {
        setState(() {
          isCoursesNotificationsSubscription = false;
        });
      }
    });
  }

  void booksSwitchHandler() {
    NotificationHandler().booksNotificationSubscriptionHandler().then((value) {
      if (value == 1) {
        setState(() {
          isBooksNotificationsSubscription = true;
        });
      } else if (value == 0) {
        setState(() {
          isBooksNotificationsSubscription = false;
        });
      }
    });
  }

  void othersSwitchHandler() {
    NotificationHandler().othersNotificationSubscriptionHandler().then((value) {
      if (value == 1) {
        setState(() {
          isOthersNotificationsSubscription = true;
        });
      } else if (value == 0) {
        setState(() {
          isOthersNotificationsSubscription = false;
        });
      }
    });
  }
}
