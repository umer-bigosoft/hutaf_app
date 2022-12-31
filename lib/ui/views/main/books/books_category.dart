import 'package:Hutaf/providers/main/library_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/books/book_item.dart';
import 'package:Hutaf/ui/widgets/loading/book_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class BooksCategory extends StatefulWidget {
  final category;
  BooksCategory(this.category, {Key key}) : super(key: key);

  @override
  _BooksCategoryState createState() => _BooksCategoryState();
}

class _BooksCategoryState extends State<BooksCategory> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearch = true;
  bool _isInit = true;
  bool _isLoading = true;
  bool _isRealSearch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<LibraryProvider>(context, listen: false)
          .getCatergoryBooks(widget.category['id'])
          .then((_) {
        setState(() {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _searchController.clear());
          _isSearch = false;
          _isRealSearch = false;
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    setState(() {});
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
          : Consumer<LibraryProvider>(
              builder: (context, category, child) {
                if (category.isCategotyBooksError) {
                  return ErrorResult(
                    text: 'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب الكتب !',
                  );
                } else if (category.categoryBooks.length == 0) {
                  return EmptyResult(
                    text: 'هممم، يبدو أنه لا توجد كتب !',
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
                                left: 13),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 30.0,
                              childAspectRatio:
                                  (layoutSize.width / layoutSize.height),
                            ),
                            itemCount: _isSearch
                                ? category.searchCategoryBooks.length
                                : category.categoryBooks.length,
                            itemBuilder: (context, index) {
                              if (!_isSearch) {
                                return BookItem(
                                    bookId: category.categoryBooks[index].id,
                                    bookName:
                                        category.categoryBooks[index].name,
                                    bookImage:
                                        category.categoryBooks[index].image,
                                    bookPrice: category
                                        .categoryBooks[index].price
                                        .toDouble(),
                                    writerName: category
                                        .categoryBooks[index].writerName,
                                    isFree:
                                        category.categoryBooks[index].isFree);
                              } else {
                                return BookItem(
                                    bookId:
                                        category.searchCategoryBooks[index].id,
                                    bookName: category
                                        .searchCategoryBooks[index].name,
                                    bookImage: category
                                        .searchCategoryBooks[index].image,
                                    bookPrice: category
                                        .searchCategoryBooks[index].price
                                        .toDouble(),
                                    writerName: category
                                        .searchCategoryBooks[index].writerName,
                                    isFree: category
                                        .searchCategoryBooks[index].isFree);
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
                    _searchController.clear();
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
            final libraryProvider =
                Provider.of<LibraryProvider>(context, listen: false);
            setState(() {
              _isSearch = true;
            });
            libraryProvider.bookSearch(_searchController.text);
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
