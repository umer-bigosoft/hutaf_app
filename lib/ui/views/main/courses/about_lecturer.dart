import 'package:Hutaf/models/courses/trainer_model.dart';
import 'package:Hutaf/providers/main/trainer_provider.dart';
import 'package:Hutaf/ui/widgets/courses/course_item.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:Hutaf/ui/widgets/loading/about_lecturer_loading.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutLecturer extends StatefulWidget {
  final lecturer;
  AboutLecturer(this.lecturer, {Key key}) : super(key: key);

  @override
  _AboutLecturerState createState() => _AboutLecturerState();
}

class _AboutLecturerState extends State<AboutLecturer> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // print(widget.lecturer['id']);
      Provider.of<TrainerProvider>(context, listen: false)
          .getTrainer(widget.lecturer['id'])
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CupertinoButton(
                child: Icon(
                  Icons.close_rounded,
                  size: layoutSize.width * 0.06,
                  color: AppColors.darkGrey,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            _isLoading
                ? AboutLecturerLoading()
                : Consumer<TrainerProvider>(
                    builder: (context, coursesProvider, child) {
                      if (coursesProvider.isTrainerEmpty) {
                        return EmptyResult(
                          text: 'هممم، يبدو أنه لا توجد تفاصيل !',
                        );
                      } else if (coursesProvider.isTrainerError) {
                        return ErrorResult(
                          text:
                              'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب التفاصيل !',
                        );
                      } else {
                        return details(layoutSize, coursesProvider.trainer);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Center lecturerHeader(Size layoutSize, TrainerModel trainer) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          trainer.image != null && trainer.image != ''
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: NetworkImage(trainer.image),
                    fit: BoxFit.cover,
                    height: layoutSize.height * 0.17,
                    width: layoutSize.width * 0.3,
                  ),
                )
              : SvgPicture.asset(
                  'assets/images/boy.svg',
                  height: layoutSize.height * 0.17,
                ),
          SizedBox(height: layoutSize.height * 0.03),
          Text(
            trainer.name,
            textScaleFactor: 1,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: layoutSize.width * 0.045,
                ),
          ),
          SizedBox(height: 2),
          Text(
            trainer.job,
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  fontSize: layoutSize.width * 0.033,
                ),
          )
        ],
      ),
    );
  }

  Widget details(Size layoutSize, TrainerModel trainer) {
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          lecturerHeader(layoutSize, trainer),
          SizedBox(height: layoutSize.height * 0.05),
          Container(
            margin: EdgeInsets.only(
              right: layoutSize.width * 0.035,
              left: layoutSize.width * 0.035,
            ),
            child: Text(
              trainer.description,
              textScaleFactor: 1,
              style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                    fontSize: layoutSize.width * 0.038,
                  ),
            ),
          ),
          CustomDivider(
            lineWidth: layoutSize.width * 0.8,
            lineColor: AppColors.lightGrey3,
            marginTop: layoutSize.height * 0.04,
            marginBottom: layoutSize.height * 0.04,
          ),
          Consumer<TrainerProvider>(
            builder: (context, coursesProvider, child) {
              if (coursesProvider.isTrainerCoursesEmpty) {
                return Container();
              } else if (coursesProvider.isTrainerCoursesError) {
                return Container();
              } else {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          right: layoutSize.width * 0.035,
                          left: layoutSize.width * 0.035,
                        ),
                        child: MainScreenHeaderWithShowMore(
                          title: 'course_details.trainer_courses'
                              .tr(args: [trainer.name]),
                          handler: null,
                        ),
                      ),
                      SizedBox(height: layoutSize.height * 0.02),
                      Container(
                        width: layoutSize.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                            right: layoutSize.width * 0.035,
                            top: layoutSize.height * 0.01,
                          ),
                          child: RowBuilder(
                            itemCount: coursesProvider.trainerCourses.length,
                            itemBuilder: (context, index) {
                              return CourseItem(
                                courseId:
                                    coursesProvider.trainerCourses[index].id,
                                courseName:
                                    coursesProvider.trainerCourses[index].name,
                                courseImage:
                                    coursesProvider.trainerCourses[index].image,
                                coursePrice:
                                    coursesProvider.trainerCourses[index].price.toDouble(),
                                trainerName: coursesProvider
                                    .trainerCourses[index].trainerName,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          SizedBox(height: layoutSize.height * 0.05),
        ],
      ),
    );
  }
}
