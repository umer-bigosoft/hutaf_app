import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/archive_provider.dart';
import 'package:Hutaf/providers/main/books_provider.dart';
import 'package:Hutaf/ui/widgets/books/book_item.dart';
import 'package:Hutaf/ui/widgets/headers/main_screen_header_with_show_more.dart';
import 'package:Hutaf/ui/widgets/loading/home_horizantal_list_loading.dart';
import 'package:Hutaf/ui/widgets/others/row_builder.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentBooksList extends StatefulWidget {
  final String title;
  const RecentBooksList({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _RecentBooksListState createState() => _RecentBooksListState();
}

class _RecentBooksListState extends State<RecentBooksList> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user == null) return;
      Provider.of<ArchiveProvider>(context, listen: false)
          .getUserBooks(user.uid)
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
      return HomeHorizantalListLoading();
    } else {
      return Container(
        child: Consumer<ArchiveProvider>(
          builder: (context, home, child) {
            if (home.isBooksError) {
              print('books error');
              return Container();
            } else if (home.userBooks.length == 0) {
              print('list empty');
              return Container();
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
                        itemCount: home.userBooks.length > 5
                            ? 5
                            : home.userBooks.length,
                        itemBuilder: (context, index) {
                          return BookItem(
                              bookId: home.userBooks[index].id,
                              bookName: home.userBooks[index].name,
                              bookImage: home.userBooks[index].image,
                              bookPrice: home.userBooks[index].price.toDouble(),
                              writerName: home.userBooks[index].writerName,
                              isFree: home.userBooks[index].isFree,
                              directPlay: true,
                              showCross: true,
                              onCross: () async {
                                await Provider.of<BooksProvider>(context,
                                        listen: false)
                                    .removeFreeBook(
                                  home.userBooks[index].id,
                                  home.userBooks[index].purchasedBy,
                                );
                                await Provider.of<ArchiveProvider>(context,
                                        listen: false)
                                    .removeUserBook(home.userBooks[index].id);
                              });
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
