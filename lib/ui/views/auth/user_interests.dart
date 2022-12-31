import 'package:Hutaf/models/main/category_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/library_provider.dart';
import 'package:Hutaf/ui/widgets/buttons/category_button.dart';
import 'package:Hutaf/ui/widgets/buttons/rectangle_button.dart';
import 'package:Hutaf/ui/widgets/headers/auth_top_header.dart';
import 'package:Hutaf/ui/widgets/loading/category_loading.dart';
import 'package:Hutaf/ui/widgets/loading/rectangle_button_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInterests extends StatefulWidget {
  UserInterests({Key key}) : super(key: key);

  @override
  _UserInterestsState createState() => _UserInterestsState();
}

class _UserInterestsState extends State<UserInterests> {
  List<String> selectedInterestsList = [];

  bool _isLoading = true;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    selectedInterestsList =
        Provider.of<AuthProvider>(context, listen: false).interests;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<LibraryProvider>(context, listen: false)
          .getBooksCategories()
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
            Container(
              margin: EdgeInsets.only(
                right: layoutSize.width * 0.045,
                left: layoutSize.width * 0.045,
              ),
              child: AuthTopHeader(),
            ),
            SizedBox(height: layoutSize.height * 0.03),
            if (_isLoading)
              GridView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  right: 13,
                  bottom: layoutSize.height * 0.03,
                  left: 13,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: (layoutSize.width / layoutSize.height) * 2,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return CategoryLoading();
                },
              ),
            if (!_isLoading)
              Expanded(
                child: Consumer<LibraryProvider>(
                    builder: (context, library, child) {
                  if (library.isCategotyBooksError) {
                    return Column(
                      children: [
                        SizedBox(height: layoutSize.height * 0.06),
                        ErrorResult(
                          isSizedBox: false,
                          text:
                              'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب التصنيفات !',
                        ),
                      ],
                    );
                  } else if (library.categoriesList.length == 0) {
                    return Column(
                      children: [
                        SizedBox(height: layoutSize.height * 0.06),
                        EmptyResult(
                          isSizedBox: false,
                          text: 'هممم، يبدو أنه لا توجد تصنيفات !',
                        ),
                      ],
                    );
                  } else {
                    return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          right: 13,
                          bottom: layoutSize.height * 0.03,
                          left: 13),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio:
                            (layoutSize.width / layoutSize.height) * 2,
                      ),
                      itemCount: library.categoriesList.length,
                      itemBuilder: (context, index) {
                        CategoryModel category = library.categoriesList[index];
                        return CategoryButton(
                          categoryIcon: category.categoryIcon,
                          categoryId: category.categoryId,
                          categoryName: category.tr['ar'],
                          type: 'book',
                          color: selectedInterestsList
                                  .contains(category.categoryId)
                              ? AppColors.lightPink3
                              : AppColors.white,
                          onPressed: () {
                            if (selectedInterestsList
                                .contains(category.categoryId))
                              setState(() {
                                selectedInterestsList
                                    .remove(category.categoryId);
                              });
                            else {
                              setState(() {
                                selectedInterestsList.add(category.categoryId);
                              });
                            }
                          },
                        );
                      },
                    );
                  }
                }),
              ),
            if (_isLoading) Spacer(),
            !_isLoading
                ? RectangleButton(
                    text: 'interests.continue'.tr(),
                    handler: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Provider.of<AuthProvider>(context, listen: false)
                          .updateInterests(selectedInterestsList)
                          .then(
                        (value) {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  )
                : RectangleButtonLoading(
                    text: 'interests.continue'.tr(),
                  ),
          ],
        ),
      ),
    );
  }
}
