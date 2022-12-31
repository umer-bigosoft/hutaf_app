import 'package:Hutaf/providers/main/library_provider.dart';
import 'package:Hutaf/ui/widgets/books/book_item.dart';
import 'package:Hutaf/ui/widgets/loading/book_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryBooksSection extends StatefulWidget {
  const LibraryBooksSection({
    Key key,
  }) : super(key: key);

  @override
  _LibraryBooksSectionState createState() => _LibraryBooksSectionState();
}

class _LibraryBooksSectionState extends State<LibraryBooksSection> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<LibraryProvider>(context, listen: false).getBooks().then((_) {
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
      return Expanded(
        child: GridView.builder(
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
        ),
      );
    } else {
      return Expanded(
        child: Consumer<LibraryProvider>(
          builder: (context, library, child) {
            if (library.isLibraryBooksError) {
              return Column(
                children: [
                  SizedBox(height: layoutSize.height * 0.06),
                  ErrorResult(
                    isSizedBox: false,
                    text: 'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب الكتب !',
                  ),
                ],
              );
            } else if (library.libraryBooks.length == 0) {
              return Column(
                children: [
                  SizedBox(height: layoutSize.height * 0.06),
                  EmptyResult(
                    isSizedBox: false,
                    text: 'هممم، يبدو أنه لا توجد كتب !',
                  ),
                ],
              );
            } else {
              return GridView.builder(
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
                itemCount: library.libraryBooks.length,
                itemBuilder: (context, index) {
                  return BookItem(
                    bookId: library.libraryBooks[index].id,
                    bookName: library.libraryBooks[index].name,
                    bookImage: library.libraryBooks[index].image,
                    bookPrice: library.libraryBooks[index].price.toDouble(),
                    writerName: library.libraryBooks[index].writerName,
                    isFree: library.libraryBooks[index].isFree
                  );
                },
              );
            }
          },
        ),
      );
    }
  }
}
