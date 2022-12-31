import 'package:Hutaf/providers/main/library_provider.dart';
import 'package:Hutaf/ui/widgets/categories/category_corousel_item.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/main/courses_provider.dart';

class CategoriesCorousel extends StatefulWidget {
  final String title;
  final bool isBookTab;
  const CategoriesCorousel({Key key, this.title, this.isBookTab})
      : super(key: key);

  @override
  State<CategoriesCorousel> createState() => _CategoriesCorouselState();
}

class _CategoriesCorouselState extends State<CategoriesCorousel> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      if (widget.isBookTab)
        Provider.of<LibraryProvider>(context, listen: false)
            .getBooksCategories()
            .then((_) {});
      else
        Provider.of<CoursesProvider>(context, listen: false)
            .getCoursesCategories()
            .then((_) {});
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return !widget.isBookTab
        ? Consumer<CoursesProvider>(builder: (context, library, child) {
            if (library.isCategotyCoursesError) return Container();
            if (library.categoriesList.isEmpty) return Container();

            List<Widget> items = [];
            library.categoriesList.forEach((category) => {
                  items.add(CategoryCorouselItem(
                    categoryId: category.categoryId,
                    categoryName: category.tr['ar'],
                    isBookCategory: widget.isBookTab,
                  ))
                });

            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: layoutSize.width * 0.035,
                    left: layoutSize.width * 0.035,
                  ),
                  child: MainScreenHeaderWithShowMore(
                    title: widget.title,
                    handler: () {
                      // Navigator.pushNamed(context, ScreensName.viewMoreBooks);
                    },
                    isLoadMore: false,
                  ),
                ),
                Container(
                  width: layoutSize.width,
                  child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlayCurve: Curves.ease,
                        enableInfiniteScroll: true,
                        viewportFraction: 0.425,
                        height: layoutSize.height * 0.055,
                        autoPlay: true,
                      ),
                      items: items),
                ),
              ],
            );
          })
        : Consumer<LibraryProvider>(builder: (context, library, child) {
            if (library.isCategotyBooksError) return Container();
            if (library.categoriesList.isEmpty) return Container();

            List<Widget> items = [];
            library.categoriesList.forEach((category) => {
                  items.add(CategoryCorouselItem(
                    categoryId: category.categoryId,
                    categoryName: category.tr['ar'],
                  ))
                });

            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: layoutSize.width * 0.035,
                    left: layoutSize.width * 0.035,
                  ),
                  child: MainScreenHeaderWithShowMore(
                    title: widget.title,
                    handler: () {
                      // Navigator.pushNamed(context, ScreensName.viewMoreBooks);
                    },
                    isLoadMore: false,
                  ),
                ),
                Container(
                  width: layoutSize.width,
                  child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlayCurve: Curves.ease,
                        enableInfiniteScroll: true,
                        viewportFraction: 0.325,
                        height: layoutSize.height * 0.06,
                        autoPlay: true,
                      ),
                      items: items),
                ),
              ],
            );
          });
  }
}
