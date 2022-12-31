import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/archive_provider.dart';
import 'package:Hutaf/ui/widgets/books/book_item.dart';
import 'package:Hutaf/ui/widgets/loading/book_loading.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArchiveBooks extends StatefulWidget {
  ArchiveBooks({Key key}) : super(key: key);

  @override
  _ArchiveBooksState createState() => _ArchiveBooksState();
}

class _ArchiveBooksState extends State<ArchiveBooks> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      String uid = Provider.of<AuthProvider>(context, listen: false).user.uid;
      Provider.of<ArchiveProvider>(context, listen: false)
          .getUserBooks(uid)
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
        child: Consumer<ArchiveProvider>(
          builder: (context, library, child) {
            if (library.isBooksError) {
              return Column(
                children: [
                  SizedBox(height: layoutSize.height * 0.06),
                  ErrorResult(
                    isSizedBox: false,
                    text: 'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب الكتب !',
                  ),
                ],
              );
            } else if (library.userBooks.length == 0) {
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
                itemCount: library.userBooks.length,
                itemBuilder: (context, index) {
                  return BookItem(
                      bookId: library.userBooks[index].id,
                      bookName: library.userBooks[index].name,
                      bookImage: library.userBooks[index].image,
                      bookPrice: library.userBooks[index].price.toDouble(),
                      writerName: library.userBooks[index].writerName,
                      isFree: library.userBooks[index].isFree);
                },
              );
            }
          },
        ),
      );
    }
  }
}
