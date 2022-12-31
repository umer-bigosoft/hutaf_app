import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/views/main/home/category_books_list.dart';
import 'package:Hutaf/ui/views/main/home/free_books_list.dart';
import 'package:Hutaf/ui/views/main/home/home_books_by_interests.dart';
import 'package:Hutaf/ui/views/main/home/home_carousel_list.dart';
import 'package:Hutaf/ui/views/main/home/recent_books_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_books_list.dart';

class BooksHomeTab extends StatefulWidget {
  final Function(bool) onScrollPast;
  const BooksHomeTab({Key key, this.onScrollPast}) : super(key: key);

  @override
  State<BooksHomeTab> createState() => _BooksHomeTabState();
}

class _BooksHomeTabState extends State<BooksHomeTab> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() {
      widget.onScrollPast(controller.position.pixels >
          controller.position.maxScrollExtent * 0.4);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          HomeCarouselSlider(type: CorouselType.BOOK),
          SizedBox(height: layoutSize.height * 0.03),
          HomeBooksList(title: 'home.recently_published'.tr()),
          if (user != null) ...[
            SizedBox(height: layoutSize.height * 0.03),
            RecentBooksList(title: "home.finish".tr()),
          ],
          SizedBox(height: layoutSize.height * 0.03),
          FreeBooksList(title: 'home.free_books'.tr()),
          if (user != null) HomeBooksByInterests(),
          SizedBox(height: layoutSize.height * 0.03),
          CategoryBookList(
            categoryId: 'CAT_30',
            categoryName: 'home.default_category'.tr(),
          )
        ],
      ),
    );
  }
}
