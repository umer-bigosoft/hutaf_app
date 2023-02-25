import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverMode extends StatefulWidget {
  final String bookName;
  final String chapterName;
  final Function onClose;

  DriverMode(
      {@required this.onClose,
      @required this.bookName,
      @required this.chapterName,
      key})
      : super(key: key);

  @override
  State<DriverMode> createState() => _DriverModeState();
}

class _DriverModeState extends State<DriverMode> {
  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;
    return Consumer<NewAudioProvider>(
        builder: (context, value, child) => SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: layoutSize.height * 0.40,
                    width: layoutSize.width,
                    margin: EdgeInsets.all(4),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'وضع القيادة',
                                  ),
                                  Icon(
                                    Icons.drive_eta_rounded,
                                    size: layoutSize.width * 0.06,
                                    color: AppColors.darkPink,
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.bookName,
                                textScaleFactor: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                        fontSize: layoutSize.width * 0.085,
                                        color: AppColors.darkPink),
                              ),
                            ],
                          ),
                          Text(
                            widget.chapterName,
                            textScaleFactor: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(
                                    fontSize: layoutSize.width * 0.04,
                                    color: AppColors.darkPink),
                          ),
                          Container(),
                          InkWell(
                            child: Icon(
                              value.audioState != AudioPlayerState.Playing
                                  ? Icons.play_arrow
                                  : Icons.pause,
                              size: layoutSize.height * 0.08,
                              color: AppColors.darkPink,
                            ),
                            onTap: () {
                              value.audioState == AudioPlayerState.Playing
                                  ? value.pauseAudio()
                                  : value.audioPlayer.resume();
                              value.notifyListeners();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: layoutSize.height * 0.10,
                    margin: EdgeInsets.all(4),
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.fast_forward,
                              size: layoutSize.height * 0.08,
                              color: AppColors.darkPink,
                            ),
                            onTap: () {
                              Provider.of<NewAudioProvider>(context,
                                      listen: false)
                                  .seekAudioToPosition(Duration(seconds: -10));
                            },
                          ),
                          Container(color: Colors.black, width: 1, height: 30),
                          InkWell(
                              child: Icon(
                                Icons.fast_rewind,
                                size: layoutSize.height * 0.08,
                                color: AppColors.darkPink,
                              ),
                              onTap: () {
                                Provider.of<NewAudioProvider>(context,
                                        listen: false)
                                    .seekAudioToPosition(Duration(seconds: 10));
                              }),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: layoutSize.height * 0.025),
                    child: CupertinoButton(
                      child: Icon(
                        Icons.close_rounded,
                        size: layoutSize.width * 0.07,
                        color: AppColors.white,
                      ),
                      onPressed: () {
                        widget.onClose();
                      },
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.5, color: Colors.white)),
                  )
                ],
              ),
            ));
  }
}
