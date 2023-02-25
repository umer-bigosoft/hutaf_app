import 'dart:async';

import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/books_provider.dart';
import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/ui/views/main/home/home_books_list.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_title_only.dart';
import 'package:Hutaf/ui/widgets/bottom_sheets/about_book_bottom_sheet.dart';
import 'package:Hutaf/ui/widgets/buttons/button.dart';
import 'package:Hutaf/ui/widgets/loading/book_details_loading.dart';
import 'package:Hutaf/ui/widgets/loading/button_loading.dart';
import 'package:Hutaf/ui/widgets/others/custom_divider.dart';
import 'package:Hutaf/ui/widgets/others/empty_result.dart';
import 'package:Hutaf/ui/widgets/others/error_result.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:Hutaf/ui/widgets/buttons/outlined_button.dart'
    as outlinedButton;
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../../models/books/chapter_model.dart';

class BookDetails extends StatefulWidget {
  final book;
  BookDetails(this.book, {Key key}) : super(key: key);

  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  bool _isInit = true;
  bool _isLoading = true;

  List<ChapterModel> chapters = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<BooksProvider>(context, listen: false)
          .getDetails(widget.book['bookId'])
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

    return Scaffold(
      appBar: AppBarTitleOnly(
        title: 'book_details.about'.tr(),
        actions: [
          Consumer<BooksProvider>(
            builder: (context, bookProvider, child) {
              if (!bookProvider.isBookDetailsEmpty &&
                  !bookProvider.isBookDetailsError) {
                return CupertinoButton(
                  minSize: 1,
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Icons.share_rounded,
                    color: AppColors.darkPink,
                    size: layoutSize.width * 0.05,
                  ),
                  onPressed: () {
                    bookProvider.shareBook(
                        bookProvider.book.name, bookProvider.book.writerName);
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          SizedBox(width: layoutSize.width * 0.04),
          CupertinoButton(
            minSize: 1,
            padding: EdgeInsets.only(left: layoutSize.width * 0.035),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.darkGrey,
              size: layoutSize.width * 0.062,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? BookDetailsLoading()
            : Consumer<BooksProvider>(
                builder: (context, bookProvider, child) {
                  if (bookProvider.isBookDetailsEmpty) {
                    return EmptyResult(
                      text: 'book_details.no_details'.tr(),
                    );
                  } else if (bookProvider.isBookDetailsError) {
                    return ErrorResult(
                      text: 'book_details.unknown_error'.tr(),
                    );
                  } else {
                    return bookDetails(layoutSize, bookProvider.book,
                        bookProvider.isBookAvailable);
                  }
                },
              ),
      ),
    );
  }

  Widget bookDetails(Size layoutSize, BookModel book, bool isBookAvailable) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(height: layoutSize.height * 0.03),
        header(layoutSize, book, isBookAvailable),
        SizedBox(height: layoutSize.height * 0.045),
        Container(
          margin: EdgeInsets.only(
            right: layoutSize.width * 0.035,
            left: layoutSize.width * 0.035,
          ),
          child: Text(
            book.description,
            textScaleFactor: 1,
            style: Theme.of(context).primaryTextTheme.headline2.copyWith(
                  fontSize: layoutSize.width * 0.04,
                ),
          ),
        ),
        SizedBox(height: layoutSize.height * 0.045),
        CustomDivider(
          lineWidth: layoutSize.width * 0.6,
          lineColor: AppColors.lightGrey3,
        ),
        SizedBox(height: layoutSize.height * 0.045),
        HomeBooksList(
          title: 'book_details.others_listen_to'.tr(),
        ),
        SizedBox(height: layoutSize.height * 0.03),
      ],
    );
  }

  Widget header(Size layoutSize, BookModel book, bool isBookAvailable) {
    // var purchased = Provider.of<AuthProvider>(context, listen: false)
    //     .isPurchased(book: book);
    var purchased;
    if (Provider.of<AuthProvider>(context, listen: false).user != null) {
      purchased =
          Provider.of<AuthProvider>(context, listen: false).isSubscribed ||
              book.isFree;
      // print(purchased);
    } else {
      purchased = false;
    }

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
            child: CachedNetworkImage(
              height: layoutSize.height * 0.35,
              imageUrl: book.image,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.bookImagePlaceholder),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Assets.bookImagePlaceholder),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: purchased &&
                                Provider.of<BooksProvider>(context)
                                        .reachedChapterDetails
                                        .id !=
                                    ''
                            ? AppColors.black.withOpacity(0.5)
                            : AppColors.black.withOpacity(0.0),
                      ),
                    ),
                    if (purchased &&
                        Provider.of<BooksProvider>(context)
                                .reachedChapterDetails
                                .id !=
                            '')
                      Center(
                        child: CupertinoButton(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: AppColors.lightOrange,
                            size: layoutSize.width * 0.23,
                          ),
                          onPressed: () {
                            var bookProvider = Provider.of<BooksProvider>(
                                context,
                                listen: false);

                            Provider.of<NewAudioProvider>(context,
                                        listen: false)
                                    .chapterId =
                                bookProvider.reachedChapterDetails.id;
                            Provider.of<NewAudioProvider>(context,
                                    listen: false)
                                .bookId = book.id;

                            Provider.of<NewAudioProvider>(context,
                                    listen: false)
                                .bookCover = book.image;
                            Provider.of<NewAudioProvider>(context,
                                        listen: false)
                                    .chapterUrl =
                                bookProvider.reachedChapterDetails.url;
                            Provider.of<NewAudioProvider>(context,
                                    listen: false)
                                .title = book.name;
                            Provider.of<NewAudioProvider>(context,
                                    listen: false)
                                .writerName = book.writerName;
                            Provider.of<NewAudioProvider>(context,
                                        listen: false)
                                    .chapterDetails =
                                bookProvider.reachedChapterDetails;
                            Navigator.pushNamed(
                              context,
                              ScreensName.bookChapter,
                              arguments: {
                                'chapter': bookProvider.reachedChapterDetails,
                                'writerName': book.writerName,
                                'bookImage': book.image,
                                'bookName': book.name,
                                'bookCover': book.image,
                                'isFree': book.isFree
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            //   Container(
            //   height: layoutSize.height * 0.35,
            //   decoration: BoxDecoration(
            //     color: AppColors.lightGrey3,
            //     borderRadius: BorderRadius.circular(13),
            //     image: DecorationImage(
            //       image: NetworkImage(book.image),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
          ),
          SizedBox(width: layoutSize.width * 0.02),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.name,
                            textScaleFactor: 1,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline3
                                .copyWith(
                                  fontSize: layoutSize.width * 0.045,
                                ),
                          ),
                          Text(
                            book.writerName,
                            textScaleFactor: 1,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .copyWith(
                                  fontSize: layoutSize.width * 0.035,
                                ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoButton(
                      minSize: 1,
                      padding: EdgeInsets.zero,
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.lightGrey2,
                        size: layoutSize.width * 0.06,
                      ),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: false,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return AboutBookBottomSheet(book);
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: layoutSize.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      book.isFree ?? false ? 'book_details.free'.tr() : 'اشترك الآن',
                      textScaleFactor: 1,
                      style:
                          Theme.of(context).primaryTextTheme.headline1.copyWith(
                                fontSize: layoutSize.width * 0.04,
                                decoration: TextDecoration.underline,
                                decorationThickness: 10,
                              ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          book.evaluation != null
                              ? book.evaluation.toStringAsFixed(1)
                              : '0.0',
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.headline6.copyWith(
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
                SizedBox(height: layoutSize.height * 0.04),
                outlinedButton.OutlinedButton(
                  text: 'book_details.listen'.tr(),
                  buttonHeight: layoutSize.width * 0.1,
                  buttonWidth: layoutSize.width,
                  fontSize: layoutSize.width * 0.045,
                  handler: () {
                    Provider.of<NewAudioProvider>(context, listen: false)
                        .bookCover = book.image;
                    Provider.of<NewAudioProvider>(context, listen: false)
                        .chapterUrl = book.sampleUrl;
                    Provider.of<NewAudioProvider>(context, listen: false)
                        .title = book.name;

                    Navigator.pushNamed(
                      context,
                      ScreensName.sampleBookChapter,
                      arguments: book,
                    );
                  },
                ),
                SizedBox(height: layoutSize.height * 0.02),
                Stack(
                  children: [
                    Consumer<BooksProvider>(
                      builder: (context, provider, child) {
                        return !provider.isPayButtonLoading
                            ? Button(
                                text: 'book_details.chapters'.tr(),
                                buttonHeight: layoutSize.width * 0.1,
                                buttonWidth: layoutSize.width,
                                fontSize: layoutSize.width * 0.045,
                                handler: () async {
                                  if (!Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .isLoggedIn) {
                                    showSimpleNotification(
                                      Text(
                                        'book_details.login_first'.tr(),
                                        textScaleFactor: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              fontSize:
                                                  layoutSize.width * 0.037,
                                            ),
                                      ),
                                      background: AppColors.pink,
                                      duration: Duration(milliseconds: 1000),
                                    );
                                    Timer(Duration(milliseconds: 1200), () {
                                      Navigator.pushNamed(
                                          context, ScreensName.login);
                                    });
                                  } else {
                                    // if (book.isFree) {
                                    //   provider.purchaseFree(book.id,
                                    //       onDone: () {
                                    //     Navigator.pushNamed(
                                    //       context,
                                    //       ScreensName.chapters,
                                    //       arguments: {
                                    //         'book': book,
                                    //         'notifyRating': () =>
                                    //             setState(() {}),
                                    //       },
                                    //     );
                                    //   });
                                    // } else
                                    Navigator.pushNamed(
                                      context,
                                      ScreensName.chapters,
                                      arguments: {
                                        'book': book,
                                        'notifyRating': () => setState(() {}),
                                      },
                                    );
                                  }
                                },
                              )
                            : LoadingButton(
                                text: 'book_details.chapters'.tr(),
                                buttonHeight: layoutSize.width * 0.1,
                                buttonWidth: layoutSize.width,
                                fontSize: layoutSize.width * 0.045,
                              );
                      },
                    ),
                    !isBookAvailable && book.price != 0
                        ? Container(
                            width: layoutSize.width,
                            height: layoutSize.width * 0.1,
                            child: Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: layoutSize.height * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
