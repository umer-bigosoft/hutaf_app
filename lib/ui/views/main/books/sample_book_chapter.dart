import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/ui/widgets/others/player_controls.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SampleBookChapter extends StatefulWidget {
  final BookModel book;
  SampleBookChapter(this.book, {Key key}) : super(key: key);

  @override
  _SampleBookChapterState createState() => _SampleBookChapterState();
}

class _SampleBookChapterState extends State<SampleBookChapter> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      var audioProvider = Provider.of<NewAudioProvider>(context, listen: false);
      audioProvider.isSample = true;
      clearAudioState(audioProvider);
      audioProvider.playAudio(widget.book.sampleUrl);
    }
    _isInit = false;
  }

  void clearAudioState(NewAudioProvider audioProvider) {
    audioProvider.audioState = AudioPlayerState.Stopped;
    audioProvider.audioPlayer.release();
    audioProvider.positionText = '';
    audioProvider.durationText = '';
    audioProvider.position = null;
  }

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        var audioProvider =
            Provider.of<NewAudioProvider>(context, listen: false);
        clearAudioState(audioProvider);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: CachedNetworkImage(
            height: layoutSize.height,
            width: layoutSize.width,
            imageUrl: widget.book.image,
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
                            alignment: Alignment.topLeft,
                            child: CupertinoButton(
                              child: Icon(
                                Icons.close_rounded,
                                size: layoutSize.width * 0.06,
                                color: AppColors.white,
                              ),
                              onPressed: () {
                                var audioProvider =
                                    Provider.of<NewAudioProvider>(context,
                                        listen: false);
                                clearAudioState(audioProvider);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(height: layoutSize.height * 0.04),
                          Text(
                            widget.book.name,
                            textScaleFactor: 1,
                            style:
                                Theme.of(context).textTheme.headline2.copyWith(
                                      fontSize: layoutSize.width * 0.085,
                                    ),
                          ),
                          Text(
                            widget.book.writerName,
                            textScaleFactor: 1,
                            style:
                                Theme.of(context).textTheme.headline1.copyWith(
                                      fontSize: layoutSize.width * 0.045,
                                    ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                      trackHeight: 5,
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 5)),
                                  child: Consumer<NewAudioProvider>(
                                    builder: (_, myAudioModel, child) => Slider(
                                      value: myAudioModel.position == null
                                          ? 0
                                          : myAudioModel.position.inMilliseconds
                                              .toDouble(),
                                      activeColor: AppColors.darkPink,
                                      inactiveColor: AppColors.lightPink,
                                      onChanged: (value) {
                                        myAudioModel.seekAudio(Duration(
                                            milliseconds: value.toInt()));
                                      },
                                      min: 0,
                                      max: myAudioModel.totalDuration == null
                                          ? 20
                                          : myAudioModel
                                              .totalDuration.inMilliseconds
                                              .toDouble(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1),
                                Consumer<NewAudioProvider>(
                                  builder: (_, myAudioModel, child) =>
                                      Container(
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
                                  audioUrl: widget.book.sampleUrl,
                                  onNext: (){
                                    
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: layoutSize.height * 0.12),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
