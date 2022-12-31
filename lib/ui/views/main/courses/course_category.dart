import 'package:Hutaf/providers/main/courses_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/courses/course_item.dart';
import 'package:Hutaf/ui/widgets/loading/book_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class CourseCategory extends StatefulWidget {
  final category;
  CourseCategory(this.category, {Key key}) : super(key: key);

  @override
  _CourseCategoryState createState() => _CourseCategoryState();
}

class _CourseCategoryState extends State<CourseCategory> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearch = false;
  bool _isInit = true;
  bool _isLoading = true;
  bool _isRealSearch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // print(widget.category['id']);
      Provider.of<CoursesProvider>(context, listen: false)
          .getCatergoryCourses(widget.category['id'])
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
      appBar: AppBarWithLeading(
        title: widget.category['name'],
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: _isLoading
          ? GridView.builder(
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
            )
          : Consumer<CoursesProvider>(
              builder: (context, category, child) {
                if (category.isCategotyGetCoursesError) {
                  return ErrorResult(
                    text: 'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب البيانات !',
                  );
                } else if (category.categoryCourses.length == 0) {
                  return EmptyResult(
                    text: 'هممم، يبدو أنه لا توجد بيانات !',
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(height: layoutSize.height * 0.03),
                      Container(
                        margin: EdgeInsets.only(
                          right: layoutSize.width * 0.035,
                          left: layoutSize.width * 0.035,
                        ),
                        child: searchTextField(layoutSize),
                      ),
                      SizedBox(height: layoutSize.height * 0.04),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanDown: (_) {
                            FocusScope.of(context).requestFocus(
                              FocusNode(),
                            );
                          },
                          child: GridView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              right: 13,
                              bottom: layoutSize.height * 0.03,
                              left: 13,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio:
                                  (layoutSize.width / layoutSize.height) * 1.55,
                            ),
                            itemCount: _isSearch
                                ? category.searchCourses.length
                                : category.categoryCourses.length,
                            itemBuilder: (context, index) {
                              if (!_isSearch) {
                                return CourseItem(
                                  courseId: category.categoryCourses[index].id,
                                  courseName:
                                      category.categoryCourses[index].name,
                                  courseImage:
                                      category.categoryCourses[index].image,
                                  coursePrice: category
                                      .categoryCourses[index].price
                                      .toDouble(),
                                  trainerName: category
                                      .categoryCourses[index].trainerName,
                                );
                              } else {
                                return CourseItem(
                                  courseId: category.searchCourses[index].id,
                                  courseName:
                                      category.searchCourses[index].name,
                                  courseImage:
                                      category.searchCourses[index].image,
                                  coursePrice: category
                                      .searchCourses[index].price
                                      .toDouble(),
                                  trainerName:
                                      category.searchCourses[index].trainerName,
                                );
                              }
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

  Widget searchTextField(Size layoutSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: CupertinoTextField(
              padding:
                  EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
              textAlign: TextAlign.start,
              cursorColor: AppColors.black,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: _searchController,
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                    fontSize: layoutSize.width * 0.035,
                  ),
              decoration: BoxDecoration(
                color: AppColors.lightGrey4,
                borderRadius: BorderRadius.circular(50.0),
              ),
              placeholder: 'search.search_field_hint'.tr(),
              placeholderStyle:
                  Theme.of(context).primaryTextTheme.headline6.copyWith(
                        fontSize: layoutSize.width * 0.035,
                      ),
              suffix: _isRealSearch
                  ? CupertinoButton(
                      padding: EdgeInsets.only(right: 12, left: 12),
                      minSize: 1,
                      child: Icon(
                        Icons.clear_rounded,
                        color: AppColors.darkGrey,
                        size: layoutSize.height * 0.03,
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _searchController.clear());
                          _isSearch = false;
                          _isRealSearch = false;
                        });
                      },
                    )
                  : null,
              onChanged: (value) {
                // setState(() {
                //   _searchController.text = value;
                // });
                if (value.length == 0) {
                  setState(() {
                    _isSearch = false;
                    _isRealSearch = false;
                  });
                } else {
                  setState(() {
                    _isRealSearch = true;
                  });
                }
              },
            ),
          ),
        ),
        SizedBox(width: layoutSize.width * 0.02),
        CupertinoButton(
          minSize: 1,
          padding: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkPink,
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.white,
              size: layoutSize.width * 0.06,
            ),
          ),
          onPressed: () {
            final coursesProvider =
                Provider.of<CoursesProvider>(context, listen: false);
            setState(() {
              _isSearch = true;
            });
            coursesProvider.courseSearch(_searchController.text);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
