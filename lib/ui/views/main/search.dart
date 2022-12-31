import 'package:Hutaf/providers/main/search_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/books/book_row.dart';
import 'package:Hutaf/ui/widgets/courses/course_row.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:Hutaf/ui/widgets/loading/search_loading.dart';
import 'package:Hutaf/ui/widgets/others/column_builder.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearchLoading = false;
  bool isSearchResult = true;
  bool _isSearch = false;

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'search.search_title'.tr(),
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        height: layoutSize.height,
        width: layoutSize.width,
        margin: EdgeInsets.only(
          right: layoutSize.width * 0.035,
          left: layoutSize.width * 0.035,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: layoutSize.height * 0.02),
            searchTextField(layoutSize),
            SizedBox(height: layoutSize.height * 0.045),
            _searchController.text.length == 0
                ? Container()
                : Consumer<SearchProvider>(
                    builder: (context, search, child) {
                      if (!_isSearchLoading) {
                        if (search.books.length == 0 &&
                            search.courses.length == 0) {
                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanDown: (_) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              child: Container(),
                            ),
                          );
                          // return Expanded(
                          //   child: SingleChildScrollView(
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         SizedBox(height: layoutSize.height * 0.07),
                          //         SvgPicture.asset(
                          //           'assets/images/empty_search_results.svg',
                          //           height: layoutSize.height * 0.26,
                          //         ),
                          //         SizedBox(height: layoutSize.height * 0.07),
                          //         Text(
                          //           'search.no_search_result_title'.tr(),
                          //           textScaleFactor: 1,
                          //           textAlign: TextAlign.center,
                          //           style: Theme.of(context)
                          //               .primaryTextTheme
                          //               .headline1
                          //               .copyWith(
                          //                 fontSize: layoutSize.width * 0.055,
                          //               ),
                          //         ),
                          //         SizedBox(height: 2),
                          //         Text(
                          //           'search.no_search_result_subtitle'.tr(),
                          //           textScaleFactor: 1,
                          //           textAlign: TextAlign.center,
                          //           style: Theme.of(context)
                          //               .accentTextTheme
                          //               .headline3
                          //               .copyWith(
                          //                 fontSize: layoutSize.width * 0.035,
                          //               ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // );
                        } else {
                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanDown: (_) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  if (search.books.length > 0)
                                    Column(
                                      children: [
                                        MainScreenHeaderWithShowMore(
                                          title: 'search.books'.tr(),
                                          handler: () {},
                                        ),
                                        SizedBox(
                                            height: layoutSize.height * 0.03),
                                        ColumnBuilder(
                                          itemCount: search.books.length,
                                          itemBuilder: (context, index) {
                                            return BookRow(
                                              bookId: search.books[index].id,
                                              bookName:
                                                  search.books[index].name,
                                              bookImage:
                                                  search.books[index].image,
                                              bookPrice: search
                                                  .books[index].price
                                                  .toDouble(),
                                              writerName: search
                                                  .books[index].writerName,
                                            );
                                          },
                                        ),
                                        if (search.courses.length > 0)
                                          CustomDivider(
                                            lineWidth: layoutSize.width * 0.8,
                                            lineColor: AppColors.lightGrey3,
                                            // marginTop: layoutSize.height * 0.03,
                                            marginBottom:
                                                layoutSize.height * 0.03,
                                          ),
                                      ],
                                    ),
                                  if (search.courses.length > 0)
                                    Column(
                                      children: [
                                        MainScreenHeaderWithShowMore(
                                          title: 'search.courses'.tr(),
                                          handler: () {},
                                        ),
                                        SizedBox(
                                            height: layoutSize.height * 0.03),
                                        ColumnBuilder(
                                          itemCount: search.courses.length,
                                          itemBuilder: (context, index) {
                                            return CourseRow(
                                              courseId:
                                                  search.courses[index].id,
                                              courseName:
                                                  search.courses[index].name,
                                              courseImage:
                                                  search.courses[index].image,
                                              coursePrice: search
                                                  .courses[index].price
                                                  .toDouble(),
                                              trainerName: search
                                                  .courses[index].trainerName,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        return SearchLoading();
                      }
                    },
                  ),
          ],
        ),
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
              controller: _searchController,
              keyboardType: TextInputType.text,
              autofocus: false,
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
              suffix: _isSearch
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
                        });
                      },
                    )
                  : null,
              onChanged: (value) {
                // setState(() {
                //   _searchController.text = value;
                // });
                final searchProvider =
                    Provider.of<SearchProvider>(context, listen: false);
                searchProvider.clearData();
                if (value.length == 0) {
                  setState(() {
                    _searchController.clear();
                    _isSearch = false;
                  });
                } else {
                  setState(() {
                    _isSearch = true;
                  });
                }
                setState(() {
                  _isSearchLoading = true;
                });
                searchProvider.search(_searchController.text).then((_) {
                  setState(() {
                    _isSearchLoading = false;
                  });
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
