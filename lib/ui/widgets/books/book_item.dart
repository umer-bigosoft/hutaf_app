import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/main/books_provider.dart';
import '../../../providers/main/new_audio_provider.dart';

class BookItem extends StatelessWidget {
  final String bookId;
  final String bookName;
  final String bookImage;
  final double bookPrice;
  final String writerName;
  final bool isFree;
  final bool directPlay;
  final bool showCross;
  final Function onCross;

  const BookItem(
      {Key key,
      this.bookId = '',
      this.bookName = '',
      this.bookImage = '',
      this.bookPrice = 0.0,
      this.writerName = '',
      this.isFree = false,
      this.directPlay = false,
      this.showCross = false,
      this.onCross})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        width: layoutSize.height * 0.18,
        margin: EdgeInsets.only(left: 13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: layoutSize.height * 0.23,
              imageUrl: bookImage,
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
                      if (showCross)
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              onCross();
                            },
                            icon: Container(
                              height: 30,
                              width: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.close,
                                color: AppColors.darkPink,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      if (directPlay)
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: AppColors.lightOrange,
                            size: layoutSize.width * 0.23,
                          ),
                        ),
                      if (isFree) ...[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: layoutSize.height * 0.18 * 0.2,
                            width: layoutSize.height * 0.18,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  AppColors.darkPink2,
                                  AppColors.darkPink,
                                  AppColors.pink
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(13),
                                bottomRight: Radius.circular(13),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'book_details.free'.tr(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ],
                  )),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(right: 2, left: 2),
              child: Text(
                bookName,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: layoutSize.width * 0.038,
                    ),
              ),
            ),
            SizedBox(height: 1),
            Container(
              margin: EdgeInsets.only(right: 2, left: 2),
              child: Text(
                writerName,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      fontSize: layoutSize.width * 0.028,
                    ),
              ),
            )
          ],
        ),
      ),
      onPressed: () async {
        if (directPlay) {
          await Provider.of<BooksProvider>(context, listen: false)
              .getDetails(bookId);

          var bookProvider = Provider.of<BooksProvider>(context, listen: false);

          Provider.of<NewAudioProvider>(context, listen: false).chapterId =
              bookProvider.reachedChapterDetails.id;
          Provider.of<NewAudioProvider>(context, listen: false).bookId = bookId;

          Provider.of<NewAudioProvider>(context, listen: false).bookCover =
              bookImage;
          Provider.of<NewAudioProvider>(context, listen: false).chapterUrl =
              bookProvider.reachedChapterDetails.url;
          Provider.of<NewAudioProvider>(context, listen: false).title =
              bookName;
          Provider.of<NewAudioProvider>(context, listen: false).writerName =
              writerName;
          Provider.of<NewAudioProvider>(context, listen: false).chapterDetails =
              bookProvider.reachedChapterDetails;
          Navigator.pushNamed(
            context,
            ScreensName.bookChapter,
            arguments: {
              'chapter': bookProvider.reachedChapterDetails,
              'writerName': writerName,
              'bookImage': bookImage,
              'bookName': bookName,
              'bookCover': bookImage,
              'isFree': isFree
            },
          );
        } else {
          Navigator.pushNamed(
            context,
            ScreensName.bookDetails,
            arguments: {
              'bookId': bookId,
            },
          );
        }
      },
    );
  }
}
