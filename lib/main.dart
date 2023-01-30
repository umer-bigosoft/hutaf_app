import 'dart:async';
import 'dart:io';

import 'package:Hutaf/providers/main/iap_provider.dart';
import 'package:Hutaf/utils/app_theme.dart';
import 'package:Hutaf/utils/providers.dart';
import 'package:Hutaf/utils/router.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

///
/// Create a [AndroidNotificationChannel] for heads up notifications
///
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  enableVibration: true,
  playSound: true,
);

///
/// Initalize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

///
/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.notification?.title}');
}

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'en';

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
  );
  AppRouter.defineRoutes();
  //Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();

  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  ///
  /// Set the background messaging handler early on, as a named top-level function
  ///
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  kNotificationSlideDuration = const Duration(milliseconds: 500);
  kNotificationDuration = const Duration(milliseconds: 1500);

  ///
  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  ///
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  ///
  ///
  ///
  if (Platform.isIOS) {
    // request permissions if we're on ios
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  ///
  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  ///
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  ///
  /// Set the background messaging handler early on, as a named top-level function
  ///
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  kNotificationSlideDuration = const Duration(milliseconds: 500);
  kNotificationDuration = const Duration(milliseconds: 1500);

  ///
  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  ///
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  ///
  ///
  ///
  if (Platform.isIOS) {
    // request permissions if we're on ios
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  ///
  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  ///
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
    MultiProvider(
      providers: providers,
      child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/i18n',
        saveLocale: true,
        useOnlyLangCode: true,
        startLocale: Locale('ar'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    Provider.of<IAPProvider>(context, listen: false).listen();
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<IAPProvider>(context, listen: false).cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final delegates = context.localizationDelegates;
    delegates.add(CountryLocalizations.delegate);
    return OverlaySupport(
      child: MaterialApp(
        localizationsDelegates: delegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        initialRoute: ScreensName.splash,
        onGenerateRoute: AppRouter.router.generator,
        theme: appThemes.elementAt(0),
      ),
    );
  }
}
