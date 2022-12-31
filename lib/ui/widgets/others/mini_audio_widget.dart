import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:Hutaf/utils/screens_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniAudioWidget extends StatelessWidget {
  const MiniAudioWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    return Consumer<NewAudioProvider>(
      builder: (_, audioProvider, child) {
        if ((audioProvider.audioState == AudioPlayerState.Playing ||
                audioProvider.audioState == AudioPlayerState.Paused) &&
            !audioProvider.isSample) {
          return Positioned(
            bottom: 0,
            child: Container(
              width: layoutSize.width,
              height: layoutSize.height * 0.095,
              color: AppColors.lightGrey3,
              padding: EdgeInsets.only(
                right: layoutSize.width * 0.03,
                left: layoutSize.width * 0.03,
                top: 5,
                bottom: layoutSize.height * 0.01,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          minSize: 1,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ScreensName.bookChapter,
                              arguments: {
                                'chapter': audioProvider.chapterDetails,
                                'writerName': audioProvider.writerName,
                                'bookImage': audioProvider.bookCover,
                                'bookName': audioProvider.title,
                                'bookCover': audioProvider.bookCover,
                                'isMini': true
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                width: constraints.maxWidth * 0.14,
                                height: constraints.maxHeight * 0.8,
                                imageUrl: audioProvider.bookCover,
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          Assets.courseImagePlaceholder),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          Assets.courseImagePlaceholder),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                              //   width: constraints.maxWidth * 0.14,
                              //   height: constraints.maxHeight * 0.8,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(7),
                              //     image: DecorationImage(
                              //       image: NetworkImage(audioProvider.bookCover),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(width: constraints.maxWidth * 0.03),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    audioProvider.title,
                                    textScaleFactor: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                          fontSize:
                                              constraints.maxWidth * 0.047,
                                        ),
                                  ),
                                  Text(
                                    audioProvider.writerName,
                                    textScaleFactor: 1,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline6
                                        .copyWith(
                                          fontSize: constraints.maxWidth * 0.03,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            minSize: 1,
                            padding: EdgeInsets.zero,
                            child: Icon(
                              audioProvider.audioState ==
                                      AudioPlayerState.Playing
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: constraints.maxWidth * 0.095,
                              color: AppColors.darkPink,
                            ),
                            onPressed: () {
                              // print(audioProvider.audioState);
                              if (audioProvider.audioState ==
                                  AudioPlayerState.Playing) {
                                audioProvider.pauseAudio();
                              } else {
                                audioProvider
                                    .playAudio(audioProvider.chapterUrl);
                              }
                            },
                          ),
                          SizedBox(width: constraints.maxWidth * 0.01),
                          CupertinoButton(
                            minSize: 1,
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.clear_rounded,
                              size: constraints.maxWidth * 0.075,
                              color: AppColors.darkPink,
                            ),
                            onPressed: () {
                              audioProvider.stopAudio();
                              audioProvider.audioState =
                                  AudioPlayerState.Stopped;
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
