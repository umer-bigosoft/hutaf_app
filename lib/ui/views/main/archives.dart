import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/views/main/archive_books.dart';
import 'package:Hutaf/ui/views/main/archive_courses.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_title_only.dart';
import 'package:Hutaf/ui/widgets/others/circle_tab_indicator.dart';
import 'package:Hutaf/ui/widgets/others/not_logged_in_user_content.dart';
import 'package:Hutaf/ui/widgets/others/tab_title.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class Archives extends StatefulWidget {
  Archives({Key key}) : super(key: key);

  @override
  _ArchivesState createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarTitleOnly(
        title: 'archives.archives_title'.tr(),
      ),
      body: Consumer<AuthProvider>(builder: (context, auth, child) {
        if (!auth.isLoggedIn) {
          return NotLoggedInUserContent();
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: layoutSize.height * 0.025),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: AppColors.lightGrey3,
                    ),
                  ],
                ),
                child: DefaultTabController(
                  length: 2,
                  initialIndex: _currentIndex,
                  child: TabBar(
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: CircleTabIndicator(
                        color: AppColors.darkPink, radius: 3.5),
                    indicatorColor: Colors.white,
                    isScrollable: false,
                    labelColor: AppColors.darkPink,
                    unselectedLabelColor: AppColors.darkGrey,
                    tabs: <Widget>[
                      TabTitle(text: 'search.books'.tr()),
                      TabTitle(text: 'search.courses'.tr()),
                    ],
                    onTap: onTabTapped,
                  ),
                ),
              ),
              SizedBox(height: layoutSize.height * 0.05),
              // Container(
              //   margin: EdgeInsets.only(
              //     right: layoutSize.width * 0.035,
              //     left: layoutSize.width * 0.035,
              //   ),
              //   child: searchTextField(layoutSize),
              // ),
              // SizedBox(height: layoutSize.height * 0.04),
              _children(),
            ],
          );
        }
      }),
    );
  }

  _children() {
    if (_currentIndex == 0) {
      return ArchiveBooks();
    } else {
      return ArchiveCourses();
    }
  }

  Widget searchTextField(Size layoutSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: CupertinoTextField(
              padding:
                  EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
              textAlign: TextAlign.start,
              cursorColor: AppColors.black,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              autofocus: false,
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                    fontSize: layoutSize.width * 0.035,
                  ),
              decoration: BoxDecoration(
                color: AppColors.lightGrey4,
                borderRadius: BorderRadius.circular(50.0),
              ),
              placeholder: 'search.search_field_hint'.tr(),
              placeholderStyle:
                  Theme.of(context).primaryTextTheme.headline6.copyWith(
                        fontSize: layoutSize.width * 0.035,
                      ),
              onChanged: (text) async {},
            ),
          ),
        ),
        SizedBox(width: layoutSize.width * 0.02),
        CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkPink,
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.white,
              size: layoutSize.width * 0.06,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }
}
