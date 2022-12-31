import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/ui/views/main/home/category_course_list.dart';
import 'package:Hutaf/ui/views/main/home/home_carousel_list.dart';
import 'package:Hutaf/ui/views/main/home/home_courses_by_interests.dart';
import 'package:Hutaf/ui/views/main/home/home_courses_list.dart';
import 'package:Hutaf/ui/views/main/home/recent_course_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseHomeTab extends StatefulWidget {
  final Function(bool) onScrollPast;
  const CourseHomeTab({Key key, this.onScrollPast}) : super(key: key);

  @override
  State<CourseHomeTab> createState() => _CourseHomeTabState();
}

class _CourseHomeTabState extends State<CourseHomeTab> {
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
          HomeCarouselSlider(type: CorouselType.COURSE),
          SizedBox(height: layoutSize.height * 0.03),
          HomeCoursesList(),
          if (user != null) ...[
            SizedBox(height: layoutSize.height * 0.015),
            RecentCourseList(),
            HomeCoursesByInterests(),
          ],
          SizedBox(height: layoutSize.height * 0.03),
          CategoryCourseList(
              categoryId: 'CAT_7', categoryName: 'home.course_category_1'.tr()),
          SizedBox(height: layoutSize.height * 0.03),
          CategoryCourseList(
              categoryId: 'CAT_12',
              categoryName: 'home.course_category_2'.tr()),

          // RecentBooksList(title: "home.finish".tr()),
          // SizedBox(height: layoutSize.height * 0.03),
          // FreeBooksList(title: 'home.free_books'.tr()),
          // HomeBooksByInterests(),
          // SizedBox(height: layoutSize.height * 0.03),
          // CategoryBookList(
          //   categoryId: 'CAT_30',
          //   categoryName: 'home.default_category'.tr(),
          // )
        ],
      ),
    );
  }
}
