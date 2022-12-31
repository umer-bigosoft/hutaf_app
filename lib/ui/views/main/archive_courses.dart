import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/archive_provider.dart';
import 'package:Hutaf/ui/widgets/courses/course_item.dart';
import 'package:Hutaf/ui/widgets/loading/book_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArchiveCourses extends StatefulWidget {
  ArchiveCourses({Key key}) : super(key: key);

  @override
  _ArchiveCoursesState createState() => _ArchiveCoursesState();
}

class _ArchiveCoursesState extends State<ArchiveCourses> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      String uid = Provider.of<AuthProvider>(context, listen: false).user.uid;
      Provider.of<ArchiveProvider>(context, listen: false)
          .getUserCourses(uid)
          .then((_) {
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
        child: Consumer<ArchiveProvider>(
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
            } else if (courses.userCourses.length == 0) {
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
                itemCount: courses.userCourses.length,
                itemBuilder: (context, index) {
                  return CourseItem(
                    courseId: courses.userCourses[index].id,
                    courseName: courses.userCourses[index].name,
                    courseImage: courses.userCourses[index].image,
                    coursePrice: courses.userCourses[index].price.toDouble(),
                    trainerName: courses.userCourses[index].trainerName,
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
