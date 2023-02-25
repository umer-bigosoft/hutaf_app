import 'package:Hutaf/models/books/chapter_model.dart';
import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/chapters_provider.dart';
import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/ui/views/main/subscriptions.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterCard extends StatelessWidget {
  final ChapterModel chapter;
  final String bookImage;
  final String writerName;
  final String bookName;
  final String bookCover;
  final String bookId;
  final bool isFromMoreModal;
  final bool isFirstChapter;
  final bool isFree;

  ChapterCard(
      {this.chapter,
      Key key,
      this.bookImage,
      this.writerName,
      this.bookName,
      this.bookCover,
      this.bookId,
      this.isFromMoreModal = false,
      this.isFirstChapter = true,
      this.isFree = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        right: layoutSize.width * 0.035,
        left: layoutSize.width * 0.035,
        bottom: layoutSize.height * 0.025,
      ),
      padding: EdgeInsets.only(
        right: layoutSize.width * 0.015,
        left: layoutSize.width * 0.015,
        bottom: layoutSize.height * 0.015,
        top: layoutSize.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: Provider.of<ChaptersProvider>(context).reachedChapter != '' &&
                Provider.of<ChaptersProvider>(context).reachedChapter ==
                    chapter.id
            ? AppColors.lightPurple2
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        minSize: 1,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    height: 50,
                    width: 70,
                    imageUrl: bookImage,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.courseImagePlaceholder),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.courseImagePlaceholder),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 50,
                  //   width: 70,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(7),
                  //     image: DecorationImage(
                  //       image: NetworkImage(bookImage),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width: layoutSize.width * 0.03),
                  Expanded(
                    child: Text(
                      chapter.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1,
                      style:
                          Theme.of(context).primaryTextTheme.headline2.copyWith(
                                fontSize: layoutSize.width * 0.035,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            // CupertinoButton(
            //   minSize: 1,
            //   padding: EdgeInsets.zero,
            //   child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isFree)
                  if (!Provider.of<AuthProvider>(context).isSubscribed)
                    if (!isFirstChapter) Icon(Icons.lock, color: Colors.black),
                Text(
                  Duration(seconds: chapter.duration)
                      .toString()
                      .split('.')
                      .first
                      .padLeft(8, "0"),
                  textScaleFactor: 1,
                  style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                        fontSize: layoutSize.width * 0.032,
                        fontFamily: Assets.englishFontName,
                      ),
                ),
                // Row(
                //   children: [
                //     Icon(
                //       Icons.download_rounded,
                //       size: layoutSize.width * 0.03,
                //       color: AppColors.darkPink,
                //     ),
                //     SizedBox(width: 3),
                //     Text(
                //       'course_details.download'.tr(),
                //       textScaleFactor: 1,
                //       style:
                //           Theme.of(context).textTheme.bodyText1.copyWith(
                //                 fontSize: layoutSize.width * 0.027,
                //               ),
                //     )
                //   ],
                // ),
                // Row(
                //   children: [
                //     Icon(
                //       Icons.lock_rounded,
                //       size: layoutSize.width * 0.03,
                //       color: AppColors.darkGrey,
                //     ),
                //     SizedBox(width: 3),
                //     Container(
                //       margin: EdgeInsets.only(top: 5),
                //       child: Text(
                //         'course_details.locked'.tr(),
                //         textScaleFactor: 1,
                //         style: Theme.of(context)
                //             .accentTextTheme
                //             .headline3
                //             .copyWith(
                //               fontSize: layoutSize.width * 0.027,
                //             ),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
            //   onPressed: () {},
            // ),
          ],
        ),
        onPressed: () async {
          if (!isFree) {
            if (!Provider.of<AuthProvider>(context, listen: false)
                .isSubscribed) {
              if (!isFirstChapter)
                return showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => FractionallySizedBox(
                          heightFactor: 0.9,
                          child: Subscribtions(
                            roundedCorners: true,
                          ),
                        ),
                    isScrollControlled: true);
            }
          }

          if (isFromMoreModal) {
            Provider.of<NewAudioProvider>(context, listen: false).audioState =
                AudioPlayerState.Stopped;
            Navigator.pop(context);
            Navigator.pop(context);
          }

          ///
          /// For update the position
          ///
          Provider.of<NewAudioProvider>(context, listen: false).chapterId =
              chapter.id;
          Provider.of<NewAudioProvider>(context, listen: false).bookId = bookId;

          ///
          /// For mini player
          ///
          Provider.of<NewAudioProvider>(context, listen: false).bookCover =
              bookCover;

          Provider.of<NewAudioProvider>(context, listen: false).chapterUrl =
              chapter.url;
          Provider.of<NewAudioProvider>(context, listen: false).title =
              bookName;
          Provider.of<NewAudioProvider>(context, listen: false).writerName =
              writerName;
          Provider.of<NewAudioProvider>(context, listen: false).chapterDetails =
              chapter;

          ///
          ///
          Provider.of<ChaptersProvider>(context, listen: false)
              .updateChapter(bookId, chapter.id);

          ///
          ///
          ///
          ///
          Navigator.pushNamed(
            context,
            ScreensName.bookChapter,
            arguments: {
              'chapter': chapter,
              'writerName': writerName,
              'bookImage': bookImage,
              'bookName': bookName,
              'bookCover': bookCover,
              'isFree': isFree
            },
          );
        },
      ),
    );
  }
}
