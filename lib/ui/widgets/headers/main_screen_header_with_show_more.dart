import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreenHeaderWithShowMore extends StatelessWidget {
  final String title;
  final Function handler;
  final bool isLoadMore;
  const MainScreenHeaderWithShowMore(
      {Key key, this.title, this.handler, this.isLoadMore = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textScaleFactor: 1,
          style: Theme.of(context).primaryTextTheme.headline1.copyWith(
                fontSize: layoutSize.width * 0.055,
              ),
        ),
        if (isLoadMore)
          CupertinoButton(
            minSize: 1,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'main.show_more'.tr(),
                  textScaleFactor: 1,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .headline2
                      .copyWith(fontSize: layoutSize.width * 0.03),
                ),
                SizedBox(width: layoutSize.width * 0.015),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: layoutSize.width * 0.03,
                  color: AppColors.purple,
                ),
              ],
            ),
            onPressed: handler,
          ),
      ],
    );
  }
}
