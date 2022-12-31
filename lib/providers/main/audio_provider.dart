import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AudioProvider extends ChangeNotifier {
  Duration totalDuration;
  Duration position;
  PlayerState audioState = PlayerState.PAUSED;
  String _chapterUrl = '';
  String _bookCover = '';
  String _title = '';
  bool _isPlaying = false;
  String chapterId;
  String bookId;
  AudioPlayer audioPlayer = AudioPlayer();

  Timer timer;

  // HttpsCallable _updatePosition =
  //     FirebaseFunctions.instance.httpsCallable('updatePosition');
  ///
  ///
  ///
  AudioProvider() {
    initAudio();
  }

  ///
  ///
  ///
  initAudio() {
    // AudioManager.instance.intercepter = true;
    //AudioManager.instance.play(auto: false);
    // audioPlayer.onDurationChanged.listen((updatedDuration) {
    //   totalDuration = updatedDuration;
    //   notifyListeners();
    // });

    // audioPlayer.onAudioPositionChanged.listen((updatedPosition) {
    //   position = updatedPosition;
    //   notifyListeners();
    // });

    // audioPlayer.onPlayerStateChanged.listen((playerState) {
    //   audioState = playerState;
    //   notifyListeners();
    // });
    // audioPlayer.onNotificationPlayerStateChanged.listen((state) {
    //   audioState = state;
    //   notifyListeners();
    // });

    // AudioManager.instance.onEvents((events, args) async {
    //   switch (events) {
    //     case AudioManagerEvents.start:
    //       print("=======start");
    //       position = AudioManager.instance.position;
    //       totalDuration = AudioManager.instance.duration;
    //       break;
    //     case AudioManagerEvents.ready:
    //       print("=======ready to play");
    //       position = AudioManager.instance.position;
    //       totalDuration = AudioManager.instance.duration;
    //       _isPlaying = false;

    //       /// : start changes ///
    //       int minute = 0;
    //       print("loading position...");
    //       var snapshot = await FirebaseFirestore.instance
    //           .collection('books')
    //           .doc(bookId)
    //           .collection('chapters')
    //           .doc(chapterId)
    //           .get();

    //       print("loaded...");
    //       if (snapshot.exists) {
    //         var book = snapshot.data();
    //         if (book['listened_by'] != null) {
    //           var uid = FirebaseAuth.instance.currentUser?.uid;
    //           print('listened_by');
    //           if (book['listened_by'][uid] != null) {
    //             print('listened_by');
    //             // var index = book['listened_by']
    //             //     .indexWhere((element) => element.user_id == uid);
    //             minute = book['listened_by'][uid]; //[index]['minute']
    //           }
    //         }
    //       }

    //       /// : end changes ///
    //       /// : start changes ///
    //       if (minute > 0) {
    //         var duration = Duration(seconds: minute);

    //         if (duration.inSeconds <= totalDuration.inSeconds - 5)
    //           AudioManager.instance.seekTo(duration);
    //       }

    //       /// : end changes ///
    //       notifyListeners();
    //       AudioManager.instance.playOrPause();
    //       break;
    //     case AudioManagerEvents.ended:
    //       print("=======seek");
    //       position = AudioManager.instance.position;

    //       /// : start changes ///
    //       updatePosition(position);

    //       /// : end changes ///
    //       AudioManager.instance.stop();
    //       notifyListeners();
    //       break;
    //     case AudioManagerEvents.playstatus:
    //       _isPlaying = AudioManager.instance.isPlaying;
    //       if (!AudioManager.instance.isPlaying) {
    //         audioState = PlayerState.PAUSED;
    //         notifyListeners();

    //         // AudioManager.instance.playOrPause();
    //         // audioPlayer.pause();
    //       } else {
    //         audioState = PlayerState.PLAYING;
    //         notifyListeners();

    //         /// : start changes ///
    //         timer = Timer(Duration(seconds: 10), () {
    //           if (position.inSeconds > 5) updatePosition(position);
    //         });

    //         /// : end changes ///
    //         //audioPlayer.play(_chapterUrl);
    //         //   //   AudioManager.instance.playOrPause();
    //         //   //
    //       }
    //       //   // notifyListeners();
    //       break;
    //     case AudioManagerEvents.timeupdate:
    //       // print("=======here2");
    //       position = AudioManager.instance.position;
    //       notifyListeners();
    //       // audioPlayer.po
    //       //AudioManager.instance.updateLrc(args["position"].toString());
    //       break;
    //     case AudioManagerEvents.error:
    //       print('=====here' + args);
    //       break;
    //     case AudioManagerEvents.stop:
    //       print("=======sttop");
    //       //AudioManager.instance.stop();
    //       //audioPlayer.stop();
    //       break;
    //     default:
    //       break;
    //   }
    // });
  }

  ///
  /// Update the current position of the user
  ///
  Future<void> updatePosition(Duration currntPosition) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .collection('chapters')
        .doc(chapterId)
        .set(
      {
        'listened_by': {
          FirebaseAuth.instance.currentUser?.uid: currntPosition.inSeconds,
        },
      },
      SetOptions(merge: true),
    );
    // await _updatePosition({
    //   'id': bookId, // book or course id
    //   'type': 'BOOK', // BOOK, COURSE
    //   'position': position.inSeconds, // current position in seconds
    //   'chapter': chapterId, // chapter id
    // });
  }

  ///
  ///
  ///
  playAudio(String url, String title, String bookCover) {
    _chapterUrl = url;
    _bookCover = bookCover;
    _title = title;
    _isPlaying = false;
    audioPlayer.setVolume(0.5);
    //audioPlayer.play(url);
    // Initial playback. Preloaded playback information
    // AudioManager.instance
    //     .start(url, title, desc: "", cover: bookCover, auto: false)
    //     .then((value) {
    //   play();
    //   print(value);
    // });

    //notifyListeners();
  }

  ///
  ///
  ///
  play() {
    // AudioManager.instance.playOrPause();
  }

  ///
  ///
  ///
  skipNext() async {
    // int currentPosition = await audioPlayer.getCurrentPosition();
    // int duration = await audioPlayer.getDuration();

    // if (currentPosition + 1000 < duration) {
    //   audioPlayer.seek(Duration(milliseconds: currentPosition + 1000));
    //   AudioManager.instance
    //       .seekTo(Duration(milliseconds: currentPosition + 1000));
    //   notifyListeners();
    // }

    if (totalDuration.inMilliseconds >
        position.inMilliseconds + Duration(milliseconds: 5000).inMilliseconds) {
      // AudioManager.instance.seekTo(Duration(
      //     milliseconds:
      //         (position + Duration(milliseconds: 5000)).inMilliseconds));
      notifyListeners();
    }
  }

  ///
  ///
  ///
  skipPrevious() async {
    // int currentPosition = await audioPlayer.getCurrentPosition();

    // if (currentPosition - 1000 > 0) {
    //   audioPlayer.seek(Duration(milliseconds: currentPosition - 1000));
    //   AudioManager.instance
    //       .seekTo(Duration(milliseconds: currentPosition - 1000));

    //   notifyListeners();
    // }

    if (!(position - Duration(milliseconds: 5000)).isNegative) {
      // AudioManager.instance.seekTo(Duration(
      //     milliseconds:
      //         (position - Duration(milliseconds: 5000)).inMilliseconds));
      notifyListeners();
    }
  }

  ///
  ///
  ///
  pauseAudio() {
    //audioPlayer.pause();
    // AudioManager.instance.playOrPause();
    notifyListeners();
  }

  ///
  ///
  ///
  stopAudio() {
    _isPlaying = false;
    _chapterUrl = '';
    _bookCover = '';
    _title = '';
    //audioPlayer.stop();
    // AudioManager.instance.stop();
    // AudioManager.instance.release();
    notifyListeners();
  }

  ///
  ///
  ///
  seekAudio(Duration durationToSeek) {
    audioPlayer.seek(durationToSeek);
    // AudioManager.instance.seekTo(durationToSeek);
    notifyListeners();
  }

  ///
  ///
  ///
  String get chapterUrl {
    return _chapterUrl;
  }

  ///
  ///
  ///
  String get bookCover {
    return _bookCover;
  }

  ///
  ///
  ///
  String get title {
    return _title;
  }

  ///
  ///
  ///
  bool get isPlaying {
    return _isPlaying;
  }

  ///
  ///
  ///
  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }
}
