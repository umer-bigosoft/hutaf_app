import 'package:Hutaf/providers/main/new_audio_provider.dart';
import 'package:Hutaf/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class PlayerControls extends StatefulWidget {
  final String audioUrl;
  final Function onNext;
  final Function onPrevius;

  const PlayerControls({Key key, this.audioUrl, this.onNext, this.onPrevius})
      : super(key: key);

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  // bool isMuted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Controls(
            icon: Icons.fast_forward,
            handler: () {
              if (widget.onPrevius != null) widget.onPrevius();
            },
          ),

          // Controls(
          //   icon: isMuted ? Icons.music_note_rounded : Icons.music_off_rounded,
          //   handler: () {
          //     Provider.of<NewAudioProvider>(context, listen: false)
          //         .mute(isMuted);
          //     setState(() {
          //       isMuted = !isMuted;
          //     });
          //   },
          // ),
          Controls(
            icon: Icons.forward_10_rounded,
            handler: () {
              Provider.of<NewAudioProvider>(context, listen: false)
                  .seekAudioToPosition(Duration(seconds: -10));
            },
          ),
          PlayControl(
            audioUrl: widget.audioUrl,
          ),
          Controls(
            icon: Icons.replay_10_rounded,
            handler: () {
              Provider.of<NewAudioProvider>(context, listen: false)
                  .seekAudioToPosition(Duration(seconds: 10));
            },
          ),
          Controls(
            icon: Icons.fast_rewind,
            handler: () {
              if (widget.onNext != null) widget.onNext();
            },
          ),

          // Controls(
          //   icon: Icons.repeat_rounded,
          //   handler: () {
          //     Provider.of<NewAudioProvider>(context, listen: false).audioState =
          //         AudioPlayerState.Playing;
          //     Provider.of<NewAudioProvider>(context, listen: false)
          //         .seekAudio(Duration(seconds: 0));
          //   },
          // ),
        ],
      ),
    );
  }
}

class PlayControl extends StatelessWidget {
  final String audioUrl;

  const PlayControl({Key key, this.audioUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<NewAudioProvider>(
      builder: (_, myAudioModel, child) => CupertinoButton(
        minSize: 1,
        padding: EdgeInsets.zero,
        onPressed: () {
          myAudioModel.audioState == AudioPlayerState.Playing
              ? myAudioModel.pauseAudio()
              : myAudioModel.playAudio(audioUrl);
        },
        child: myAudioModel.isLoading
            ? Container(
                height: 100,
                width: 100,
                padding: EdgeInsets.all(15),
                child: LoadingIndicator(
                  /// Required, The loading type of the widget
                  indicatorType: Indicator.lineScaleParty,

                  /// Optional, The color collections
                  colors: const [AppColors.darkPink, AppColors.lightPink],

                  /// Optional, The stroke of the line, only applicable to widget which contains line
                  strokeWidth: 2,

                  /// Optional, Background of the widget
                  // backgroundColor: Colors.black,

                  /// Optional, the stroke backgroundColor
                  // pathBackgroundColor: Colors.black
                ),
              )
            : Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.darkPink,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.darkPink,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            myAudioModel.audioState == AudioPlayerState.Playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 55,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final IconData icon;
  final Function handler;
  final bool isDisabled;

  const Controls({
    Key key,
    this.icon,
    this.handler,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: !isDisabled ? AppColors.darkPink : AppColors.lightGrey,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: !isDisabled ? AppColors.darkPink : AppColors.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 27,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: !isDisabled ? handler : null,
    );
  }
}


// import 'package:Hutaf/providers/main/audio_provider.dart';
// import 'package:Hutaf/utils/colors.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PlayerControls extends StatelessWidget {
//   final String audioUrl;
//   final String title;
//   final String bookCover;

//   const PlayerControls({Key key, this.audioUrl, this.title, this.bookCover})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           Controls(
//             icon: Icons.skip_next_rounded,
//             handler: () {
//               Provider.of<AudioProvider>(context, listen: false).skipPrevious();
//             },
//           ),
//           PlayControl(
//             audioUrl: audioUrl,
//             title: title,
//             bookCover: bookCover,
//           ),
//           Controls(
//             icon: Icons.skip_previous_rounded,
//             handler: () {
//               Provider.of<AudioProvider>(context, listen: false).skipNext();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PlayControl extends StatelessWidget {
//   final String audioUrl;
//   final String title;
//   final String bookCover;

//   const PlayControl({Key key, this.audioUrl, this.title, this.bookCover})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // Provider.of<AudioProvider>(context, listen: false)
//     //     .playAudio(audioUrl, title, bookCover);
//     return Consumer<AudioProvider>(
//       builder: (_, myAudioModel, child) => CupertinoButton(
//         onPressed: () {
//           print(myAudioModel.audioState);
//           myAudioModel.audioState == PlayerState.PLAYING
//               ? myAudioModel.pauseAudio()
//               : myAudioModel.playAudio(audioUrl, title, bookCover);
//         },
//         child: Container(
//           height: 100,
//           width: 100,
//           decoration: BoxDecoration(
//             color: AppColors.darkPink,
//             shape: BoxShape.circle,
//           ),
//           child: Stack(
//             children: <Widget>[
//               Center(
//                 child: Container(
//                   margin: EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: AppColors.darkPink,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Container(
//                   margin: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColors.darkPink,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Icon(
//                       myAudioModel.audioState == PlayerState.PLAYING
//                           ? Icons.pause_rounded
//                           : Icons.play_arrow_rounded,
//                       size: 50,
//                       color: AppColors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Controls extends StatelessWidget {
//   final IconData icon;
//   final Function handler;

//   const Controls({Key key, this.icon, this.handler}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoButton(
//       child: Container(
//         height: 60,
//         width: 60,
//         decoration: BoxDecoration(
//           color: AppColors.darkPink,
//           shape: BoxShape.circle,
//         ),
//         child: Stack(
//           children: <Widget>[
//             Center(
//               child: Container(
//                 margin: EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: AppColors.darkPink,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//             Center(
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     color: AppColors.darkPink, shape: BoxShape.circle),
//                 child: Center(
//                   child: Icon(
//                     icon,
//                     size: 30,
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       onPressed: handler,
//     );
//   }
// }
