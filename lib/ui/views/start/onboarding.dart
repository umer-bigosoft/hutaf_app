import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/utils/colors.dart';

class OnBoarding extends StatefulWidget {
  createState() => OnBoardingState();
}

class OnBoardingState extends State<OnBoarding> {
  final int _totalPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Container(
            width: layoutSize.width,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      buildPageContent(
                        image: 'assets/images/onboarding_1.svg',
                        title: 'onboarding.onboarding_title1'.tr(),
                        body: 'onboarding.onboarding_text1'.tr(),
                        layoutSize: layoutSize,
                      ),
                      buildPageContent(
                        image: 'assets/images/onboarding_2.svg',
                        title: 'onboarding.onboarding_title2'.tr(),
                        body: 'onboarding.onboarding_text2'.tr(),
                        layoutSize: layoutSize,
                      ),
                      buildPageContent(
                        image: 'assets/images/onboarding_3.svg',
                        title: 'onboarding.onboarding_title3'.tr(),
                        body: 'onboarding.onboarding_text3'.tr(),
                        layoutSize: layoutSize,
                      ),
                      buildPageContent(
                        image: 'assets/images/onboarding_4.svg',
                        title: 'onboarding.onboarding_title4'.tr(),
                        body: 'onboarding.onboarding_text4'.tr(),
                        layoutSize: layoutSize,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _currentPage != 3
                      ? indicators(layoutSize)
                      : startButton(layoutSize),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget indicators(Size layoutSize) {
    return Container(
      margin: EdgeInsets.only(
        bottom: layoutSize.height * 0.035,
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 1,
            child: Text(
              'onboarding.skip'.tr(),
              textScaleFactor: 1,
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                    fontSize: layoutSize.width * 0.037,
                  ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(ScreensName.mainNavigation);
            },
          ),
          Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Container(
              child: Row(
                children: [
                  for (int i = 0; i < _totalPages; i++)
                    i == _currentPage
                        ? buildPageIndicator(true, layoutSize)
                        : buildPageIndicator(false, layoutSize)
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 1,
            child: Text(
              'onboarding.next'.tr(),
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: layoutSize.width * 0.037,
                  ),
            ),
            onPressed: () {
              setState(() {
                _pageController.animateToPage(_currentPage + 1,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget startButton(Size layoutSize) {
    return Button(
      text: 'onboarding.lets_go'.tr(),
      buttonHeight: layoutSize.width * 0.12,
      buttonWidth: layoutSize.width,
      fontSize: layoutSize.width * 0.047,
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.15,
        left: layoutSize.width * 0.15,
        bottom: layoutSize.height * 0.1,
      ),
      handler: () {
        Navigator.of(context).pushReplacementNamed(ScreensName.mainNavigation);
      },
    );
  }

  Widget buildPageIndicator(bool isCurrentPage, Size layoutSize) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        margin: EdgeInsets.symmetric(horizontal: layoutSize.width * 0.013),
        height: isCurrentPage ? 15.0 : 9.0,
        width: isCurrentPage ? 15.0 : 9.0,
        decoration: BoxDecoration(
          color: isCurrentPage ? AppColors.purple : AppColors.lightPurple,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget buildPageContent(
      {String image, String title, String body, Size layoutSize}) {
    return Container(
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.045,
        left: layoutSize.width * 0.045,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: layoutSize.height * 0.02),
          SvgPicture.asset(
            image,
            height: layoutSize.height * 0.26,
          ),
          SizedBox(height: layoutSize.height * 0.055),
          Text(
            title,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                  fontSize: layoutSize.width * 0.06,
                ),
          ),
          SizedBox(height: layoutSize.height * 0.025),
          Text(
            body,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  fontSize: layoutSize.width * 0.04,
                ),
          ),
          SizedBox(height: layoutSize.height * 0.09),
        ],
      ),
    );
  }
}
