import 'dart:async';

import 'package:Hutaf/providers/auth/auth_provider.dart';
import 'package:Hutaf/providers/main/books_provider.dart';
import 'package:Hutaf/providers/main/chapters_provider.dart';
import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/ui/views/main/books/driver_mode.dart';
import 'package:Hutaf/ui/widgets/books/chapter_card.dart';
import 'package:Hutaf/ui/widgets/loading/loading_bottom_sheet.dart';
import 'package:Hutaf/ui/widgets/others/player_controls.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/custom_barrier.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../subscriptions.dart';

class BookChapter extends StatefulWidget {
  final args;

  BookChapter(
    this.args, {
    Key key,
  }) : super(key: key);

  @override
  _BookChapterState createState() => _BookChapterState();
}

class _BookChapterState extends State<BookChapter>
    with TickerProviderStateMixin {
  bool _isInit = true;
  AnimationController controller;
  bool driverModeEnabled = false;

  int timerIndex = 0;

  StreamSubscription onCompleteSubscription;

  @override
  initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(milliseconds: 500);
    onCompleteSubscription =
        Provider.of<NewAudioProvider>(context, listen: false)
            .audioPlayer
            .onPlayerCompletion
            .listen((data) {
      onNext();
    });
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn)
      Provider.of<BooksProvider>(context, listen: false).purchaseFree(
          Provider.of<NewAudioProvider>(context, listen: false).bookId);

    SharedPreferences.getInstance().then((preference) {
      final list = preference.getStringList('watched') ?? [];
      final bookId =
          Provider.of<NewAudioProvider>(context, listen: false).bookId;
      if (list.contains(bookId)) {
        list.remove(bookId);
      }
      list.insert(0, bookId);
      preference.setStringList('watched', list);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit && widget.args['isMini'] == null) {
      var audioProvider = Provider.of<NewAudioProvider>(context, listen: false);
      audioProvider.audioState = AudioPlayerState.Stopped;
      audioProvider.audioPlayer.release();
      audioProvider.isSample = false;
      audioProvider.positionText = '';
      audioProvider.durationText = '';
      audioProvider.position = null;
      audioProvider.chapterDetails = widget.args['chapter'];
      audioProvider.playAudio(widget.args['chapter'].url);
      Provider.of<ChaptersProvider>(context, listen: false)
          .getChapters(audioProvider.bookId);
    }
    _isInit = false;
  }

  @override
  void dispose() {
    if (onCompleteSubscription != null) onCompleteSubscription.cancel();

    super.dispose();
  }

  Future onNext() {
    final audioProvider = Provider.of<NewAudioProvider>(context, listen: false);

    final chapterProvider =
        Provider.of<ChaptersProvider>(context, listen: false);

    int i = 9999999999;
    for (i = 0; i < chapterProvider.chapters.length; i++) {
      if (chapterProvider.chapters[i].id == chapterProvider.reachedChapter)
        break;
    }

    print(i + 1 > 0);

    if (!Provider.of<AuthProvider>(context, listen: false).isSubscribed) {
      if (!Provider.of<BooksProvider>(context, listen: false).book.isFree) {
        if (i + 1 > 0) {
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
    }

    if (i + 1 >= chapterProvider.chapters.length) return null;

    final chapter = chapterProvider.chapters[i + 1];

    setState(() {
      widget.args['chapter'] = chapter;
    });

    audioProvider.audioPlayer.stop();
    audioProvider.chapterId = chapter.id;
    audioProvider.chapterUrl = chapter.url;
    audioProvider.chapterDetails = chapter;
    chapterProvider.updateChapter(audioProvider.bookId, chapter.id);
    chapterProvider.reachedChapter = chapter.id;
    audioProvider.playAudio(chapter.url, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: CachedNetworkImage(
          height: layoutSize.height,
          width: layoutSize.width,
          imageUrl: widget.args['bookImage'],
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.bookImagePlaceholder),
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.bookImagePlaceholder),
                fit: BoxFit.cover,
              ),
            ),
          ),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  height: layoutSize.height,
                  width: layoutSize.width,
                  color: AppColors.black.withOpacity(0.8),
                ),
                Align(
                  alignment: Alignment(0.95, -0.05),
                  child: Consumer<NewAudioProvider>(
                    builder: (_, myAudioModel, child) {
                      final callback = () => showModalBottomSheet(
                            context: context,
                            builder: (_) => Container(
                              width: 300,
                              height: 250,
                              child: Stack(
                                children: [
                                  CupertinoPicker(
                                    backgroundColor: Colors.white,
                                    itemExtent: 30,
                                    diameterRatio: 1,
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: timerIndex),
                                    children: [
                                      Text(
                                        'قم بإلغاء المؤقت',
                                        style: TextStyle(
                                            fontFamily: Assets.fontName),
                                      ),
                                      Text(
                                        '10 دقائق',
                                        style: TextStyle(
                                            fontFamily: Assets.fontName),
                                      ),
                                      Text(
                                        '15 دقيقة',
                                        style: TextStyle(
                                            fontFamily: Assets.fontName),
                                      ),
                                      Text(
                                        '30 دقيقة',
                                        style: TextStyle(
                                            fontFamily: Assets.fontName),
                                      ),
                                      Text(
                                        '45 دقيقة',
                                        style: TextStyle(
                                            fontFamily: Assets.fontName),
                                      ),
                                      Text(
                                        '60 دقيقة',
                                        style: TextStyle(
                                            fontFamily: Assets.fontName),
                                      ),
                                      Text('نهاية الفصل')
                                    ],
                                    onSelectedItemChanged: (value) {
                                      timerIndex = value;
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                        child: Text(
                                          'Done',
                                          style: TextStyle(
                                              color: AppColors.darkPink,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () => {
                                              Navigator.pop(context),
                                              Provider.of<NewAudioProvider>(
                                                      context,
                                                      listen: false)
                                                  .updateTimerOption(
                                                      TIMER_OPTIONS
                                                          .values[timerIndex])
                                            }),
                                  ),
                                ],
                              ),
                            ),
                          );

                      if (myAudioModel.timerDuration == null)
                        return IconButton(
                          onPressed: callback,
                          icon: Icon(
                            Icons.timer_outlined,
                            color: AppColors.white,
                          ),
                        );

                      var minutes = myAudioModel.timerDuration.inSeconds ~/ 60;
                      var seconds = myAudioModel.timerDuration.inSeconds % 60;

                      return TextButton(
                        onPressed: callback,
                        child: Text(
                          '${seconds.floor().toString().padLeft(2, '0')} : ${minutes.abs().toInt().toString().padLeft(2, '0')} ',
                          style: TextStyle(color: AppColors.white),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.only(
                      right: layoutSize.width * 0.035,
                      left: layoutSize.width * 0.035,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => {driverModeEnabled = true}),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('وضع القيادة'),
                                        Icon(
                                          Icons.drive_eta_rounded,
                                          size: layoutSize.width * 0.06,
                                          color: AppColors.darkPink,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                child: Icon(
                                  Icons.close_rounded,
                                  size: layoutSize.width * 0.06,
                                  color: AppColors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: layoutSize.height * 0.04),
                        Text(
                          widget.args['bookName'],
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontSize: layoutSize.width * 0.085,
                              ),
                        ),
                        Text(
                          widget.args['writerName'],
                          textScaleFactor: 1,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                                fontSize: layoutSize.width * 0.045,
                              ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.args['chapter'].title,
                                textScaleFactor: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                      fontSize: layoutSize.width * 0.04,
                                    ),
                              ),
                              SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 5,
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 5,
                                  ),
                                ),
                                child: Consumer<NewAudioProvider>(
                                    builder: (_, myAudioModel, child) {
                                  return Slider(
                                    value: myAudioModel.position == null
                                        ? 0.0
                                        : myAudioModel.position.inMilliseconds
                                            .toDouble(),
                                    activeColor: AppColors.darkPink,
                                    inactiveColor: AppColors.lightPink,
                                    onChanged: (value) {
                                      myAudioModel.seekAudio(Duration(
                                          milliseconds: value.toInt()));
                                    },
                                    min: 0.0,
                                    max: myAudioModel.totalDuration == null
                                        ? 20.0
                                        : myAudioModel
                                            .totalDuration.inMilliseconds
                                            .toDouble(),
                                  );
                                }),
                              ),
                              SizedBox(height: 1),
                              Consumer<NewAudioProvider>(
                                builder: (_, myAudioModel, child) => Container(
                                  padding: EdgeInsets.only(
                                    right: layoutSize.width * 0.055,
                                    left: layoutSize.width * 0.055,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        myAudioModel.position != null
                                            ? "${myAudioModel.getPositionText ?? ''}"
                                            : '',
                                        // : myAudioModel.totalDuration != null
                                        //     ? myAudioModel.durationText
                                        //     : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              fontSize:
                                                  layoutSize.width * 0.037,
                                            ),
                                      ),
                                      Text(
                                        myAudioModel.position != null
                                            ? "${myAudioModel.getDurationText ?? ''}"
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .copyWith(
                                              fontSize:
                                                  layoutSize.width * 0.037,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: layoutSize.height * 0.04),
                              PlayerControls(
                                audioUrl: widget.args['chapter'].url,
                                onNext: () => onNext(),
                                onPrevius: () {
                                  final audioProvider =
                                      Provider.of<NewAudioProvider>(context,
                                          listen: false);

                                  final chapterProvider =
                                      Provider.of<ChaptersProvider>(context,
                                          listen: false);

                                  int i = 9999999999;
                                  for (i = 0;
                                      i < chapterProvider.chapters.length;
                                      i++)
                                    if (chapterProvider.chapters[i].id ==
                                        chapterProvider.reachedChapter) break;

                                  if (i - 1 < 0) return;

                                  final chapter =
                                      chapterProvider.chapters[i - 1];

                                  setState(() {
                                    widget.args['chapter'] = chapter;
                                  });

                                  audioProvider.audioPlayer.stop();
                                  audioProvider.chapterId = chapter.id;
                                  audioProvider.chapterUrl = chapter.url;
                                  audioProvider.chapterDetails = chapter;
                                  chapterProvider.reachedChapter = chapter.id;
                                  chapterProvider.updateChapter(
                                      audioProvider.bookId, chapter.id);
                                  audioProvider.playAudio(chapter.url,
                                      reset: true);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: layoutSize.height * 0.08),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CupertinoButton(
                            minSize: 1,
                            padding: EdgeInsets.only(bottom: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Ionicons.ios_arrow_dropup_circle,
                                  color: AppColors.white,
                                  size: layoutSize.width * 0.045,
                                ),
                                SizedBox(width: layoutSize.width * 0.02),
                                Text(
                                  'book_details.more'.tr(),
                                  textScaleFactor: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .copyWith(
                                        fontSize: layoutSize.width * 0.045,
                                      ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              final bookChapters =
                                  Provider.of<ChaptersProvider>(context,
                                      listen: false);
                              // print(bookChapters.chapters.length);
                              if (bookChapters.chapters.length == 0) {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: false,
                                  enableDrag: false,
                                  isScrollControlled: true,
                                  transitionAnimationController: controller,
                                  builder: (BuildContext context) {
                                    return LoadingBottomSheet();
                                  },
                                );
                                Provider.of<ChaptersProvider>(context,
                                        listen: false)
                                    .getChapters(Provider.of<NewAudioProvider>(
                                            context,
                                            listen: false)
                                        .bookId)
                                    .then((value) {
                                  Navigator.pop(context);
                                  showCupertinoModalBottomSheetForMore(
                                    bookChapters: bookChapters,
                                    bookImage: widget.args['bookImage'],
                                    layoutSize: layoutSize,
                                    bookName: widget.args['bookName'],
                                    writerName: widget.args['writerName'],
                                  );
                                });
                              } else {
                                showCupertinoModalBottomSheetForMore(
                                  bookChapters: bookChapters,
                                  bookImage: widget.args['bookImage'],
                                  layoutSize: layoutSize,
                                  bookName: widget.args['bookName'],
                                  writerName: widget.args['writerName'],
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (driverModeEnabled) ...[
                  CustomBarrier(),
                  DriverMode(
                    bookName: widget.args['bookName'],
                    chapterName: widget.args['chapter'].title,
                    onClose: () {
                      setState(() {
                        driverModeEnabled = false;
                      });
                    },
                  )
                ]
              ],
            ),
          ),
        ),
        // child: Container(
        //   height: layoutSize.height,
        //   width: layoutSize.width,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: NetworkImage(widget.args['bookImage']),
        //       fit: BoxFit.cover,
        //     ),
        //   ),

        // ),
      ),
    );
  }

  Future<dynamic> showCupertinoModalBottomSheetForMore({
    ChaptersProvider bookChapters,
    Size layoutSize,
    String bookImage,
    String writerName,
    String bookName,
  }) {
    return showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: bookChapters.chapters.length,
            padding: EdgeInsets.only(
              top: layoutSize.height * 0.055,
              bottom: layoutSize.height * 0.035,
            ),
            itemBuilder: (context, index) {
              return ChapterCard(
                  chapter: bookChapters.chapters[index],
                  bookImage: bookImage,
                  writerName: writerName,
                  bookName: bookName,
                  bookCover: bookImage,
                  bookId: Provider.of<NewAudioProvider>(context, listen: false)
                      .bookId,
                  isFromMoreModal: true,
                  isFirstChapter: index == 0,
                  isFree: Provider.of<BooksProvider>(context, listen: false)
                      .book
                      .isFree);
            },
          ),
        );
      },
    );
  }

  Widget audioOptionIcon(Size layoutSize, String svgImage, Function handler) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: SvgPicture.asset(
        svgImage,
        width: layoutSize.width * 0.065,
      ),
      onPressed: handler,
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   controller.dispose();
  // }
}
