import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/books_provider.dart';
import 'package:Hutaf/providers/main/chapters_provider.dart';
import 'package:Hutaf/ui/widgets/books/chapter_card.dart';
import 'package:Hutaf/ui/widgets/loading/chapters_card_loading.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class Chapters extends StatefulWidget {
  Chapters(this.book, this.notifyRating, {Key key}) : super(key: key);
  final BookModel book;
  final Function notifyRating;
  @override
  _ChaptersState createState() => _ChaptersState();
}

class _ChaptersState extends State<Chapters> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<ChaptersProvider>(context, listen: false)
          .getChapters(widget.book.id)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<BooksProvider>(context, listen: false)
            .getReachedChapter(widget.book.id);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: !_isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: layoutSize.height * 0.02),
                    chaptersHeader(layoutSize),
                    CustomDivider(
                      lineWidth: layoutSize.width * 0.8,
                      lineColor: AppColors.lightGrey3,
                      marginTop: layoutSize.height * 0.03,
                      marginBottom: layoutSize.height * 0.04,
                    ),
                    Consumer<ChaptersProvider>(
                      builder: (context, bookChapters, child) {
                        if (bookChapters.isChaptersEmpty) {
                          return Expanded(
                            child: EmptyResult(
                              text: 'لا توجد فصول مضافة !',
                            ),
                          );
                        } else if (bookChapters.isChaptersError) {
                          return Expanded(
                            child: ErrorResult(
                              text:
                                  'هممم، يبدو أنه قد حدث خطأ ما أثناء جلب الفصول !',
                            ),
                          );
                        } else {
                          return Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: bookChapters.chapters.length,
                              padding: EdgeInsets.only(
                                top: layoutSize.height * 0.015,
                                bottom: layoutSize.height * 0.015,
                              ),
                              itemBuilder: (context, index) {
                                return ChapterCard(
                                    chapter: bookChapters.chapters[index],
                                    bookImage: widget.book.image,
                                    writerName: widget.book.writerName,
                                    bookName: widget.book.name,
                                    bookCover: widget.book.image,
                                    bookId: widget.book.id,
                                    isFirstChapter: index == 0,
                                    isFree: widget.book.isFree);
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: layoutSize.height * 0.02),
                    chaptersHeader(layoutSize),
                    CustomDivider(
                      lineWidth: layoutSize.width * 0.8,
                      lineColor: AppColors.lightGrey3,
                      marginTop: layoutSize.height * 0.03,
                      marginBottom: layoutSize.height * 0.04,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 8,
                        padding: EdgeInsets.only(
                          top: layoutSize.height * 0.015,
                          bottom: layoutSize.height * 0.015,
                        ),
                        itemBuilder: (context, index) {
                          return ChaptersCardLoading();
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget chaptersHeader(Size layoutSize) {
    var purchased = //widget.book.price == 0 ||
        widget.book.purchasedBy != null
            ? widget.book.purchasedBy
                .contains(FirebaseAuth.instance.currentUser?.uid)
            : false;

    return Container(
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CupertinoButton(
                  minSize: 1,
                  padding: EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.black,
                    size: layoutSize.width * 0.055,
                  ),
                  onPressed: () {
                    Provider.of<BooksProvider>(context, listen: false)
                        .getReachedChapter(widget.book.id);

                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: layoutSize.width * 0.03),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          widget.book.name,
                          textScaleFactor: 1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline3
                              .copyWith(
                                fontSize: layoutSize.width * 0.05,
                              ),
                        ),
                      ),
                      Text(
                        widget.book.writerName,
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                              fontSize: layoutSize.width * 0.03,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: layoutSize.width * 0.04),
          purchased
              ? Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تقييم الكتاب',
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: layoutSize.width * 0.03,
                            ),
                      ),
                      RatingBar.builder(
                        initialRating: getRating(),
                        itemSize: 17,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 4,
                        unratedColor: AppColors.lightOrange,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.02),
                        itemBuilder: (context, _) => Icon(
                          Icons.star_rounded,
                          color: AppColors.orange,
                          size: layoutSize.width * 0.04,
                        ),
                        onRatingUpdate: (rating) {
                          Provider.of<ChaptersProvider>(context, listen: false)
                              .rateTheBook(
                            rating,
                            widget.book.id,
                            Provider.of<AuthProvider>(context, listen: false)
                                .user
                                .uid,
                          );
                          calculateRate(rating);
                        },
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تقييم الكتاب',
                        textScaleFactor: 1,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: layoutSize.width * 0.03,
                            ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.book.evaluation != null
                                ? widget.book.evaluation.toStringAsFixed(1)
                                : '0.0',
                            textScaleFactor: 1,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: layoutSize.width * 0.032,
                                      fontFamily: Assets.englishFontName,
                                    ),
                          ),
                          Icon(
                            Icons.star_rounded,
                            size: layoutSize.width * 0.035,
                            color: AppColors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  double getRating() {
    if (widget.book.evaluatedBy == null) return 0.0;

    return widget.book.evaluatedBy
        .singleWhere(
            (element) =>
                element['uid'] ==
                Provider.of<AuthProvider>(context, listen: false).user.uid,
            orElse: () => {
                  'uid': Provider.of<AuthProvider>(context, listen: false)
                      .user
                      .uid,
                  'rate': 0
                })['rate']
        .toDouble();
  }

  void calculateRate(rating) {
    var book = widget.book;
    if (book.evaluatedBy == null) book.evaluatedBy = [];
    book.evaluatedBy.removeWhere((element) =>
        element['uid'] ==
        Provider.of<AuthProvider>(context, listen: false).user.uid);
    book.evaluatedBy.add({
      'uid': Provider.of<AuthProvider>(context, listen: false).user.uid,
      'rate': rating
    });
    double total = 0;
    for (var i = 0; i < book.evaluatedBy.length; i++) {
      total += book.evaluatedBy[i]['rate'];
    }
    book.evaluation = total / book.evaluatedBy.length;
    widget.notifyRating();
  }
}
