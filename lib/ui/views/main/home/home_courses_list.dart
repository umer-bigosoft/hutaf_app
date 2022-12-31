import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/widgets/courses/course_item.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:Hutaf/ui/widgets/loading/home_horizantal_list_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_or_error_section.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class HomeCoursesList extends StatefulWidget {
  const HomeCoursesList({
    Key key,
  }) : super(key: key);

  @override
  _HomeCoursesListState createState() => _HomeCoursesListState();
}

class _HomeCoursesListState extends State<HomeCoursesList> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<HomeProvider>(context, listen: false).getCourses().then((_) {
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
        child: Consumer<HomeProvider>(
          builder: (context, home, child) {
            if (home.isHomeCoursesError) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: 'مخصصات بلغة الإشارة',
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
            } else if (home.homeCourses.length == 0) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: 'مخصصات بلغة الإشارة',
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
                      title: 'home.recently_published'.tr(),
                      handler: () {
                        Navigator.pushNamed(
                            context, ScreensName.viewMoreCourses);
                      },
                      isLoadMore: home.homeCourses.length > 5 ? true : false,
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.01),
                  Container(
                    width: layoutSize.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                        right: layoutSize.width * 0.035,
                        top: layoutSize.height * 0.01,
                      ),
                      child: RowBuilder(
                        itemCount: home.homeCourses.length > 5
                            ? 5
                            : home.homeCourses.length,
                        itemBuilder: (context, index) {
                          return CourseItem(
                            courseId: home.homeCourses[index].id,
                            courseName: home.homeCourses[index].name,
                            courseImage: home.homeCourses[index].image,
                            coursePrice: home.homeCourses[index].price.toDouble(),
                            trainerName: home.homeCourses[index].trainerName,
                          );
                        },
                      ),
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
