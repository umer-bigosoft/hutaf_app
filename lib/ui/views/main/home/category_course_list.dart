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

class CategoryCourseList extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const CategoryCourseList({
    Key key,
    this.categoryId,
    this.categoryName,
  }) : super(key: key);

  @override
  _CategoryCourseListState createState() => _CategoryCourseListState();
}

class _CategoryCourseListState extends State<CategoryCourseList> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<HomeProvider>(context, listen: false)
          .getCategoryCourses(widget.categoryId)
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
        child: Consumer<HomeProvider>(
          builder: (context, home, child) {
            final courses = home.categoryCourses(widget.categoryId);

            if (courses.length == 0) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: widget.categoryName,
                      handler: () {},
                      isLoadMore: false,
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
                        title: widget.categoryName,
                        handler: () {
                          Navigator.pushNamed(
                            context,
                            ScreensName.courseCategory,
                            arguments: {
                              'id': widget.categoryId,
                              'name': widget.categoryName,
                            },
                          );
                        },
                        isLoadMore: true),
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
                        itemCount: courses.length > 5 ? 5 : courses.length,
                        itemBuilder: (context, index) {
                          return CourseItem(
                            courseId: courses[index].id,
                            courseName: courses[index].name,
                            courseImage: courses[index].image,
                            coursePrice: courses[index].price.toDouble(),
                            trainerName: courses[index].trainerName,
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
