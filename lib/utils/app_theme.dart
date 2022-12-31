import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Hutaf/utils/general_vars.dart';

import 'colors.dart';

final List<ThemeData> appThemes = [mainTheme];

final Color primaryColor = AppColors.purple;
final Color accentColor = AppColors.darkPink;

final ThemeData mainTheme = ThemeData(
  brightness: Brightness.light,
  cardColor: AppColors.white,
  fontFamily: Assets.fontName,
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  hoverColor: Colors.transparent,
  primaryColor: primaryColor,
  dividerColor: AppColors.divider,
  backgroundColor: AppColors.white,
  scaffoldBackgroundColor: Colors.white,
  bottomAppBarColor: Colors.white,
  cupertinoOverrideTheme: CupertinoThemeData(
    brightness: Brightness.light,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.black,
  ),

  /// Purple & Black
  primaryTextTheme: TextTheme(
    headline1: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w900,
    ),
    headline2: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline3: TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w500,
    ),
    headline4: TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w900,
    ),
    headline5: TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w900,
    ),
    headline6: TextStyle(
      color: AppColors.darkGrey,
      fontWeight: FontWeight.w500,
    ),
    bodyText1: TextStyle(
      color: AppColors.darkGrey,
      fontWeight: FontWeight.w900,
    ),
    bodyText2: TextStyle(
      color: AppColors.lightGrey2,
      fontWeight: FontWeight.w500,
    ),
    caption: TextStyle(
      color: AppColors.darkGrey2,
      fontWeight: FontWeight.w500,
    ),
  ),

  /// Dark pink & Grey
  // accentTextTheme: TextTheme(
  //   headline1: TextStyle(
  //     color: AppColors.darkPink,
  //     fontWeight: FontWeight.w500,
  //   ),
  //   headline2: TextStyle(
  //     color: AppColors.darkPink,
  //     fontWeight: FontWeight.w900,
  //   ),
  //   headline3: TextStyle(
  //     color: AppColors.darkGrey,
  //     fontWeight: FontWeight.w500,
  //   ),
  //   headline4: TextStyle(
  //     color: AppColors.darkGrey,
  //     fontWeight: FontWeight.w900,
  //   ),
  //   headline5: TextStyle(
  //     color: AppColors.lightGrey2,
  //     fontWeight: FontWeight.w500,
  //   ),
  //   headline6: TextStyle(
  //     color: AppColors.darkGrey2,
  //     fontWeight: FontWeight.w500,
  //   ),
  // ),

  /// White & Blue & Orange
  textTheme: TextTheme(
    headline1: TextStyle(
      color: AppColors.white,
      fontWeight: FontWeight.w500,
    ),
    headline2: TextStyle(
      color: AppColors.white,
      fontWeight: FontWeight.w900,
    ),
    headline3: TextStyle(
      color: AppColors.blue,
      fontWeight: FontWeight.w500,
    ),
    headline4: TextStyle(
      color: AppColors.blue,
      fontWeight: FontWeight.w900,
    ),
    headline5: TextStyle(
      color: AppColors.lightOrange,
      fontWeight: FontWeight.w500,
    ),
    headline6: TextStyle(
      color: AppColors.orange,
      fontWeight: FontWeight.w500,
    ),
    bodyText1: TextStyle(
      color: AppColors.darkPink,
      fontWeight: FontWeight.w500,
    ),
    bodyText2: TextStyle(
      color: AppColors.darkPink,
      fontWeight: FontWeight.w900,
    ),
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
);
