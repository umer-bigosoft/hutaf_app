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

class FreeBooksList extends StatefulWidget {
  final String title;
  const FreeBooksList({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _FreeBooksListState createState() => _FreeBooksListState();
}

class _FreeBooksListState extends State<FreeBooksList> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<HomeProvider>(context, listen: false)
          .getFreeBooks()
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
            if (home.isHomeBooksError) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: widget.title,
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
            } else if (home.freeBooks.length == 0) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: MainScreenHeaderWithShowMore(
                      title: widget.title,
                      handler: () {},
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
                      title: widget.title,
                      handler: () {
                        Navigator.pushNamed(context, ScreensName.viewMoreBooks);
                      },
                      isLoadMore: home.freeBooks.length > 5 ? true : false,
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
                        itemCount: home.freeBooks.length > 5
                            ? 5
                            : home.freeBooks.length,
                        itemBuilder: (context, index) {
                          return BookItem(
                            bookId: home.freeBooks[index].id,
                            bookName: home.freeBooks[index].name,
                            bookImage: home.freeBooks[index].image,
                            bookPrice: home.freeBooks[index].price.toDouble(),
                            writerName: home.freeBooks[index].writerName,
                            isFree: home.freeBooks[index].isFree
                            
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
