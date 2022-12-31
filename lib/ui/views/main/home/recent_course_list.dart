import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/archive_provider.dart';
import 'package:Hutaf/ui/widgets/courses/course_item.dart';
import 'package:Hutaf/ui/widgets/courses/home_course_row.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:Hutaf/ui/widgets/loading/home_horizantal_list_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_or_error_section.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class RecentCourseList extends StatefulWidget {
  const RecentCourseList({
    Key key,
  }) : super(key: key);

  @override
  _RecentCourseListState createState() => _RecentCourseListState();
}

class _RecentCourseListState extends State<RecentCourseList> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user == null) return;
      Provider.of<ArchiveProvider>(context, listen: false)
          .getUserCourses(user.uid)
          .then((_) {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    if (_isLoading) {
      return HomeHorizantalListLoading();
    } else {
      return Container(
        child: Consumer<ArchiveProvider>(
          builder: (context, home, child) {
            if (home.isCoursesError) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: 'استمر المشاهدة',
                      handler: () {},
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.01),
                  EmptyOrErrorSection(
                    title: 'حدث خطأ !',
                    subtitle: 'حدث خطأ ما أثناء جلب البيانات !'.tr(),
                    imageUrl: 'assets/images/empty_courses.svg',
                  ),
                ],
              );
            } else if (home.userCourses.length == 0) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: 'استمر المشاهدة',
                      handler: () {},
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.01),
                  EmptyOrErrorSection(
                    title: 'main.empty_courses'.tr(),
                    subtitle: 'main.stay_tuned'.tr(),
                    imageUrl: 'assets/images/empty_courses.svg',
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: "home.finish".tr(),
                      handler: () {
                        Navigator.pushNamed(
                            context, ScreensName.viewMoreCourses);
                      },
                      isLoadMore: false,
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.01),
                  Container(
                    width: layoutSize.width,
                    child: Column(
                      children: [
                        RowBuilder(
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            if (index >=
                                (home.userCourses.length < 2
                                    ? home.userCourses.length
                                    : 2)) return Container();

                            return HomeCourseRow(
                              courseId: home.userCourses[index].id,
                              courseName: home.userCourses[index].name,
                              courseImage: home.userCourses[index].image,
                              coursePrice:
                                  home.userCourses[index].price.toDouble(),
                              trainerName: home.userCourses[index].trainerName,
                              directPlay: true,
                            );
                          },
                        ),
                        if (home.userCourses.length > 2)
                          RowBuilder(
                            itemCount: 2,
                            itemBuilder: (context, indx) {
                              final index = indx + 2;
                              if (index >=
                                  (home.userCourses.length < 4
                                      ? home.userCourses.length
                                      : 4)) return Container();

                              return HomeCourseRow(
                                courseId: home.userCourses[index].id,
                                courseName: home.userCourses[index].name,
                                courseImage: home.userCourses[index].image,
                                coursePrice:
                                    home.userCourses[index].price.toDouble(),
                                trainerName:
                                    home.userCourses[index].trainerName,
                                directPlay: true,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
    }
  }
}
