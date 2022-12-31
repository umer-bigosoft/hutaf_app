import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/widgets/books/book_item.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:Hutaf/ui/widgets/loading/home_horizantal_list_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_or_error_section.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class CategoryBookList extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryBookList({
    Key key,
    this.categoryId,
    this.categoryName,
  }) : super(key: key);

  @override
  _CategoryBookListState createState() => _CategoryBookListState();
}

class _CategoryBookListState extends State<CategoryBookList> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<HomeProvider>(context, listen: false)
          .getCategoryBooks(widget.categoryId)
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
            if (home.isCategotyBooksError) {
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
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.01),
                  EmptyOrErrorSection(
                    title: 'حدث خطأ !',
                    subtitle: 'حدث خطأ ما أثناء جلب البيانات !'.tr(),
                    imageUrl: 'assets/images/empty_books.svg',
                  ),
                ],
              );
            } else if (home.categoryBooks.length == 0) {
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
                          ScreensName.booksCategory,
                          arguments: {
                            'id': widget.categoryId,
                            'name': widget.categoryName,
                          },
                        );
                      },
                      isLoadMore: true,
                    ),
                  ),
                  SizedBox(height: layoutSize.height * 0.01),
                  EmptyOrErrorSection(
                    title: 'main.empty_books'.tr(),
                    subtitle: 'main.stay_tuned'.tr(),
                    imageUrl: 'assets/images/empty_books.svg',
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
                        Navigator.pushNamed(context, ScreensName.viewMoreBooks);
                      },
                      isLoadMore: home.categoryBooks.length > 5 ? true : false,
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
                        itemCount: home.categoryBooks.length > 5
                            ? 5
                            : home.categoryBooks.length,
                        itemBuilder: (context, index) {
                          return BookItem(
                            bookId: home.categoryBooks[index].id,
                            bookName: home.categoryBooks[index].name,
                            bookImage: home.categoryBooks[index].image,
                            bookPrice:
                                home.categoryBooks[index].price.toDouble(),
                            writerName: home.categoryBooks[index].writerName,
                            isFree: home.categoryBooks[index].isFree
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
