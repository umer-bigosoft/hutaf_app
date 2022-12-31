import 'package:Hutaf/providers/main/courses_provider.dart';
import 'package:Hutaf/ui/widgets/courses/course_item.dart';
import 'package:Hutaf/ui/widgets/loading/book_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesSection extends StatefulWidget {
  CoursesSection({Key key}) : super(key: key);

  @override
  _CoursesSectionState createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<CoursesProvider>(context, listen: false)
          .getCourses()
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
      return Expanded(
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(
              right: 13, bottom: layoutSize.height * 0.03, left: 13),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 30.0,
            childAspectRatio: (layoutSize.width / layoutSize.height),
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            return BookLoading();
          },
        ),
      );
    } else {
      return Expanded(
        child: Consumer<CoursesProvider>(
          builder: (context, courses, child) {
            if (courses.isCoursesError) {
              return Column(
                children: [
                  SizedBox(height: layoutSize.height * 0.06),
                  ErrorResult(
                    isSizedBox: false,
                    text: 'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب البيانات !',
                  ),
                ],
              );
            } else if (courses.allCourses.length == 0) {
              return Column(
                children: [
                  SizedBox(height: layoutSize.height * 0.06),
                  EmptyResult(
                    isSizedBox: false,
                    text: 'هممم، يبدو أنه لا توجد بيانات !',
                  ),
                ],
              );
            } else {
              return GridView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    right: 13, bottom: layoutSize.height * 0.03, left: 13),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio:
                      (layoutSize.width / layoutSize.height) * 1.55,
                ),
                itemCount: courses.allCourses.length,
                itemBuilder: (context, index) {
                  return CourseItem(
                    courseId: courses.allCourses[index].id,
                    courseName: courses.allCourses[index].name,
                    courseImage: courses.allCourses[index].image,
                    coursePrice: courses.allCourses[index].price.toDouble(),
                    trainerName: courses.allCourses[index].trainerName,
                  );
                },
              );
            }
          },
        ),
      );
    }
  }
}
