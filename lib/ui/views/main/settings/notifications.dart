import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
        title: 'settings.notifications'.tr(),
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          right: layoutSize.width * 0.035,
          left: layoutSize.width * 0.035,
          top: layoutSize.height * 0.035,
          bottom: layoutSize.height * 0.04,
        ),
        children: [
          notificationOptionRow(
            layoutSize,
            'تنبيهات الكتب الجديدة',
            true,
          ),
          customDivider,
          notificationOptionRow(
            layoutSize,
            'تنبيهات للكتب الأكثر استماعًا',
            false,
          ),
          customDivider,
          notificationOptionRow(
            layoutSize,
            'تنبيهات للدورات الجديدة',
            true,
          ),
          customDivider,
        ],
      ),
    );
  }

  Row notificationOptionRow(Size layoutSize, String text, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            text,
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                  fontSize: layoutSize.width * 0.045,
                ),
          ),
        ),
        CupertinoSwitch(
          activeColor: AppColors.darkPink,
          value: value,
          onChanged: (bool value) {},
        ),
      ],
    );
  }
}
