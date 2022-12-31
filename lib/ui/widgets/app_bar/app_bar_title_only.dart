import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarTitleOnly extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final double cornerRadius;
  const AppBarTitleOnly({
    Key key,
    this.title,
    this.actions,
    this.cornerRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return PreferredSize(
      child: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        backgroundColor: AppColors.white,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(cornerRadius),
                topRight: Radius.circular(cornerRadius))),
        automaticallyImplyLeading: false,
        titleSpacing: NavigationToolbar.kMiddleSpacing - 20,
        title: Container(
          margin: EdgeInsets.only(top: 7, right: 20, left: 20),
          child: Text(
            title,
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline3.copyWith(
                  fontSize: layoutSize.width * 0.047,
                ),
          ),
        ),
        centerTitle: false,
        actions: actions != null ? actions : [],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      preferredSize: Size.fromHeight(kToolbarHeight + 10),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
