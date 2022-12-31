import 'dart:async';
import 'package:Hutaf/handler/notification_handler.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isInit = true;

  @override
  void initState() {
    super.initState();

    /// For [full screen] view
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    moveToNextScreen();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      var audioProvider = Provider.of<NewAudioProvider>(context, listen: false);
      audioProvider.audioState = AudioPlayerState.Stopped;
      audioProvider.audioPlayer.release();
      audioProvider.positionText = '';
      audioProvider.durationText = '';
      audioProvider.position = null;
      await NotificationHandler().booksNotificationSubscription();
      await NotificationHandler().coursesNotificationSubscription();
      await NotificationHandler().othersNotificationSubscription();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: layoutSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/hutaf_logo.png',
              height: layoutSize.height * 0.27,
            ),
            SizedBox(height: layoutSize.height * 0.025),
            Text(
              'splash.hutaf_slogan'.tr(),
              textScaleFactor: 1,
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                    fontSize: layoutSize.width * 0.045,
                  ),
            ),
            Text(
              'splash.hutaf_website'.tr(),
              textScaleFactor: 1,
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                    fontSize: layoutSize.width * 0.037,
                    fontFamily: Assets.englishFontName,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime');
    Provider.of<AuthProvider>(context, listen: false).watchAuth();

    if (isFirstTime == null || isFirstTime) {
      prefs.setBool('isFirstTime', false);
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed(ScreensName.onBoarding);
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed(ScreensName.mainNavigation);
      });
    }
  }
}
