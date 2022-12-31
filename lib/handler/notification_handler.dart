import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHandler {
  final _firebaseMessaging = FirebaseMessaging.instance;
  OverlaySupportEntry notification;

  ///
  ///
  ///
  Future<void> booksNotificationSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isBooksNotificationsSubscription =
        prefs.getBool('isBooksNotifications');

    ///
    /// If the user open the app for the first time
    /// Subscribe the topics & set bool in shared preferences
    ///
    if (isBooksNotificationsSubscription == null ||
        isBooksNotificationsSubscription) {
      await _firebaseMessaging.subscribeToTopic('books').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isBooksNotifications', true);
      return 1;
    }

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is false -> Unsubscribe
    ///
    else if (isBooksNotificationsSubscription != null &&
        !isBooksNotificationsSubscription) {
      ///
      /// Unsubscribe
      ///
      await _firebaseMessaging.unsubscribeFromTopic('books').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isBooksNotifications', false);
      return 0;
    }
  }

  ///
  ///
  ///
  Future<void> coursesNotificationSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isCoursesNotificationsSubscription =
        prefs.getBool('isCoursesNotifications');

    ///
    /// If the user open the app for the first time
    /// Subscribe the topics & set bool in shared preferences
    ///
    if (isCoursesNotificationsSubscription == null ||
        isCoursesNotificationsSubscription) {
      await _firebaseMessaging.subscribeToTopic('courses').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isCoursesNotifications', true);
      return 1;
    }

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is false -> Unsubscribe
    ///
    else if (isCoursesNotificationsSubscription != null &&
        !isCoursesNotificationsSubscription) {
      ///
      /// Unsubscribe
      ///
      await _firebaseMessaging.unsubscribeFromTopic('courses').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isCoursesNotifications', false);
      return 0;
    }
  }

  ///
  ///
  ///
  Future<void> othersNotificationSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isOthersNotificationsSubscription =
        prefs.getBool('isOthersNotifications');

    ///
    /// If the user open the app for the first time
    /// Subscribe the topics & set bool in shared preferences
    ///
    if (isOthersNotificationsSubscription == null ||
        isOthersNotificationsSubscription) {
      await _firebaseMessaging.subscribeToTopic('others').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isOthersNotifications', true);
      return 1;
    }

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is false -> Unsubscribe
    ///
    else if (isOthersNotificationsSubscription != null &&
        !isOthersNotificationsSubscription) {
      ///
      /// Unsubscribe
      ///
      await _firebaseMessaging.unsubscribeFromTopic('others').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isOthersNotifications', false);
      return 0;
    }
  }

  ///
  ///
  ///
  Future<int> booksNotificationSubscriptionHandler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isBooksNotificationsSubscription =
        prefs.getBool('isBooksNotifications');

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is false -> Unsubscribe
    ///
    if (isBooksNotificationsSubscription != null &&
        !isBooksNotificationsSubscription) {
      await _firebaseMessaging.subscribeToTopic('books').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isBooksNotifications', true);
      return 1;
    }

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is true -> Subscribe
    ///
    else if (isBooksNotificationsSubscription != null &&
        isBooksNotificationsSubscription) {
      await _firebaseMessaging.unsubscribeFromTopic('books').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isBooksNotifications', false);
      return 0;
    }

    ///
    /// Something went wrong
    ///
    else {
      ///
      /// Error
      ///
      return -1;
    }
  }

  ///
  ///
  ///
  Future<int> coursesNotificationSubscriptionHandler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isCoursesNotificationsSubscription =
        prefs.getBool('isCoursesNotifications');

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is false -> Unsubscribe
    ///
    if (isCoursesNotificationsSubscription != null &&
        !isCoursesNotificationsSubscription) {
      await _firebaseMessaging.subscribeToTopic('courses').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isCoursesNotifications', true);
      return 1;
    }

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is true -> Subscribe
    ///
    else if (isCoursesNotificationsSubscription != null &&
        isCoursesNotificationsSubscription) {
      await _firebaseMessaging.unsubscribeFromTopic('courses').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isCoursesNotifications', false);
      return 0;
    }

    ///
    /// Something went wrong
    ///
    else {
      ///
      /// Error
      ///
      return -1;
    }
  }

  ///
  ///
  ///
  Future<int> othersNotificationSubscriptionHandler() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isOthersNotificationsSubscription =
        prefs.getBool('isOthersNotifications');

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is false -> Unsubscribe
    ///
    if (isOthersNotificationsSubscription != null &&
        !isOthersNotificationsSubscription) {
      await _firebaseMessaging.subscribeToTopic('others').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isOthersNotifications', true);
      return 1;
    }

    ///
    /// If the user already open the app
    /// And the bool in shared preferences is true -> Subscribe
    ///
    else if (isOthersNotificationsSubscription != null &&
        isOthersNotificationsSubscription) {
      await _firebaseMessaging.unsubscribeFromTopic('others').catchError((_) {
        ///
        /// Error
        ///
        return -1;
      });

      ///
      /// Success - Subscribe
      ///
      prefs.setBool('isOthersNotifications', false);
      return 0;
    }

    ///
    /// Something went wrong
    ///
    else {
      ///
      /// Error
      ///
      return -1;
    }
  }

  ///
  ///
  ///

  Future<dynamic> handleNotification(
    Map<String, dynamic> message,
    BuildContext context,
  ) async {
    if (message['screen'] == 'books') {
      ///
      /// Open book details screen
      ///
      Navigator.pushNamed(
        context,
        ScreensName.bookDetails,
        arguments: {
          'bookId': message['id'],
        },
      );

      ///
    } else if (message['screen'] == 'courses') {
      ///
      /// Open course details screen
      ///
      Navigator.pushNamed(
        context,
        ScreensName.courseDetails,
        arguments: {
          'courseId': message['id'],
        },
      );
    } 
    // else if (message['screen'] == 'others') {}
  }

  Future<dynamic> handleInAppNotification(
    Map<String, dynamic> message,
    BuildContext context,
  ) async {
    if (message['screen'] == 'books') {
      notification = showSimpleNotification(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            message['notificationBody'],
            textScaleFactor: 1,
            // maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 17,
                ),
          ),
        ),
        background: AppColors.purple,
        trailing: CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.zero,
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.white,
          ),
          onPressed: () {
            notification.dismiss();

            ///
            /// Open book details screen
            ///
            Navigator.pushNamed(
              context,
              ScreensName.bookDetails,
              arguments: {
                'bookId': message['id'],
              },
            );
          },
        ),
        duration: Duration(seconds: 5),
      );
    } else if (message['screen'] == 'courses') {
      notification = showSimpleNotification(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            message['notificationBody'],
            textScaleFactor: 1,
            // maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 17,
                ),
          ),
        ),
        background: AppColors.purple,
        trailing: CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.zero,
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.white,
          ),
          onPressed: () {
            notification.dismiss();

            ///
            /// Open course details screen
            ///
            Navigator.pushNamed(
              context,
              ScreensName.courseDetails,
              arguments: {
                'courseId': message['id'],
              },
            );
          },
        ),
        duration: Duration(seconds: 5),
      );
    } else if (message['screen'] == 'others') {
      notification = showSimpleNotification(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            message['notificationBody'],
            textScaleFactor: 1,
            // maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 17,
                ),
          ),
        ),
        background: AppColors.purple,
        trailing: CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.zero,
          child: Icon(
            Icons.clear_rounded,
            color: AppColors.white,
          ),
          onPressed: () {
            notification.dismiss();
          },
        ),
        duration: Duration(seconds: 5),
      );
    }
  }
}
