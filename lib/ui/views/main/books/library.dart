import 'package:Hutaf/ui/views/main/books/library_books_section.dart';
import 'package:Hutaf/ui/views/main/books/library_categories_section.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/others/circle_tab_indicator.dart';
import 'package:Hutaf/ui/widgets/others/tab_title.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Library extends StatefulWidget {
  Library({Key key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'library.library_title'.tr(),
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
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
                indicator:
                    CircleTabIndicator(color: AppColors.darkPink, radius: 3.5),
                indicatorColor: Colors.white,
                isScrollable: false,
                labelColor: AppColors.darkPink,
                unselectedLabelColor: AppColors.darkGrey,
                tabs: <Widget>[
                  TabTitle(text: 'library.books'.tr()),
                  TabTitle(text: 'library.categories'.tr()),
                ],
                onTap: onTabTapped,
              ),
            ),
          ),
          SizedBox(height: layoutSize.height * 0.06),
          _children(layoutSize),
        ],
      ),
    );
  }

  Widget _children(Size layoutSize) {
    if (_currentIndex == 0) {
      return LibraryBooksSection();
    } else {
      return LibraryCategoriesSection();
    }
  }

  void onTabTapped(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }
}
