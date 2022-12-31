import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarWithLeading extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function handler;
  final List<Widget> actions;
  const AppBarWithLeading({Key key, this.title, this.handler, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return PreferredSize(
      child: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        backgroundColor: AppColors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        titleSpacing: NavigationToolbar.kMiddleSpacing - 20,
        leading: CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.black,
            size: layoutSize.width * 0.041,
          ),
          onPressed: handler != null
              ? handler
              : () {
                  Navigator.pop(context);
                },
        ),
        title: Container(
          margin: EdgeInsets.only(top: 7),
          child: Text(
            title,
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline3.copyWith(
                  fontSize: layoutSize.width * 0.047,
                ),
          ),
        ),
        centerTitle: false,
        actions: actions != null ? actions : [], systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      preferredSize: Size.fromHeight(kToolbarHeight + 10),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
