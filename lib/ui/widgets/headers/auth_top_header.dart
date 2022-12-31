import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthTopHeader extends StatelessWidget {
  final bool isClose;
  final bool suggestion;
  const AuthTopHeader({Key key, this.isClose = false, this.suggestion = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Container(
      width: layoutSize.width,
      margin: EdgeInsets.only(top: layoutSize.height * 0.06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'auth.hutaf'.tr(),
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: layoutSize.width * 0.1,
                      height: 0.7,
                    ),
              ),
              Text(
                suggestion
                    ? 'هل لديك اقتراح لتحسين \n التطبيق أو طلب خدمة'
                    : 'splash.hutaf_slogan'.tr(),
                textScaleFactor: 1,
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.03,
                    ),
              ),
            ],
          ),
          if (isClose)
            CupertinoButton(
              minSize: 1,
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.close_rounded,
                color: AppColors.lightGrey2,
                size: layoutSize.width * 0.062,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
