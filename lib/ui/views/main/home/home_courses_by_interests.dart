import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/widgets/courses/course_item.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:Hutaf/ui/widgets/loading/home_horizantal_list_loading.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeCoursesByInterests extends StatefulWidget {
  HomeCoursesByInterests({Key key}) : super(key: key);

  @override
  _HomeCoursesByInterestsState createState() => _HomeCoursesByInterestsState();
}

class _HomeCoursesByInterestsState extends State<HomeCoursesByInterests> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      String uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        Provider.of<HomeProvider>(context, listen: false)
            .getCoursesByInterests(uid)
            .then((_) {
          if (mounted)
            setState(() {
              _isLoading = false;
            });
        }).catchError((onError) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    if (_isLoading) {
      return Column(
        children: [
          SizedBox(height: layoutSize.height * 0.045),
          HomeHorizantalListLoading(),
        ],
      );
    } else {
      return Container(
        child: Consumer<HomeProvider>(
          builder: (context, home, child) {
            if (home.isHomeCoursesError) {
              return Container();
              // return Column(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.only(
              //         right: layoutSize.width * 0.035,
              //         left: layoutSize.width * 0.035,
              //       ),
              //       child: MainScreenHeaderWithShowMore(
              //         title: 'main.new_courses'.tr(),
              //         handler: () {},
              //       ),
              //     ),
              //     SizedBox(height: layoutSize.height * 0.01),
              //     EmptyOrErrorSection(
              //       title: 'حدث خطأ !',
              //       subtitle: 'حدث خطأ ما أثناء جلب البيانات !'.tr(),
              //       imageUrl: 'assets/images/empty_courses.svg',
              //     ),
              //   ],
              // );
            } else if (home.homeCoursesByInterests.length == 0) {
              return Container();
              // return Column(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.only(
              //         right: layoutSize.width * 0.035,
              //         left: layoutSize.width * 0.035,
              //       ),
              //       child: MainScreenHeaderWithShowMore(
              //         title: 'main.new_courses'.tr(),
              //         handler: () {},
              //       ),
              //     ),
              //     SizedBox(height: layoutSize.height * 0.01),
              //     EmptyOrErrorSection(
              //       title: 'main.empty_courses'.tr(),
              //       subtitle: 'main.stay_tuned'.tr(),
              //       imageUrl: 'assets/images/empty_courses.svg',
              //     ),
              //   ],
              // );
            } else {
              return Column(
                children: [
                  SizedBox(height: layoutSize.height * 0.045),
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: 'مختارات بلغة الإشارة',
                      handler: null,
                      isLoadMore: false,
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
                        itemCount: home.homeCoursesByInterests.length > 5
                            ? 5
                            : home.homeCoursesByInterests.length,
                        itemBuilder: (context, index) {
                          return CourseItem(
                            courseId: home.homeCoursesByInterests[index].id,
                            courseName: home.homeCoursesByInterests[index].name,
                            courseImage:
                                home.homeCoursesByInterests[index].image,
                            coursePrice: home
                                .homeCoursesByInterests[index].price
                                .toDouble(),
                            trainerName:
                                home.homeCoursesByInterests[index].trainerName,
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
