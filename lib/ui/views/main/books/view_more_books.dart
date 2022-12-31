import 'package:Hutaf/providers/main/home_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/books/book_item.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class ViewMoreBooks extends StatefulWidget {
  ViewMoreBooks({Key key}) : super(key: key);

  @override
  _ViewMoreBooksState createState() => _ViewMoreBooksState();
}

class _ViewMoreBooksState extends State<ViewMoreBooks> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearch = false;
  bool _isRealSearch = false;

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWithLeading(
        title: 'الكتب',
        handler: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          SizedBox(height: layoutSize.height * 0.06),
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
              child: Consumer<HomeProvider>(
                builder: (context, books, child) {
                  return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        right: 13, bottom: layoutSize.height * 0.03),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: (layoutSize.width / layoutSize.height),
                    ),
                    itemCount: _isSearch
                        ? books.searchBooks.length
                        : books.homeBooks.length,
                    itemBuilder: (context, index) {
                      if (!_isSearch) {
                        return BookItem(
                          bookId: books.homeBooks[index].id,
                          bookName: books.homeBooks[index].name,
                          bookImage: books.homeBooks[index].image,
                          bookPrice: books.homeBooks[index].price.toDouble(),
                          writerName: books.homeBooks[index].writerName,
                          isFree: books.homeBooks[index].isFree
                        );
                      } else {
                        return BookItem(
                          bookId: books.searchBooks[index].id,
                          bookName: books.searchBooks[index].name,
                          bookImage: books.searchBooks[index].image,
                          bookPrice: books.searchBooks[index].price.toDouble(),
                          writerName: books.searchBooks[index].writerName,
                          isFree: books.homeBooks[index].isFree
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
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
              controller: _searchController,
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
            final homeProvider =
                Provider.of<HomeProvider>(context, listen: false);
            setState(() {
              _isSearch = true;
            });
            homeProvider.bookSearch(_searchController.text);
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
