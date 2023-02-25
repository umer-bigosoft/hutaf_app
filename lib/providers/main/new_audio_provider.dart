import 'dart:async';
import 'dart:io';

import 'package:Hutaf/models/books/chapter_model.dart';
import 'package:Hutaf/utils/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AudioPlayerState { Stopped, Playing, Paused }

class NewAudioProvider with ChangeNotifier {
  Duration totalDuration;
  Duration position;
  AudioPlayerState audioState;
  AudioPlayer audioPlayer = AudioPlayer();
  String durationText;
  String positionText;
  String title;
  String writerName;
  String chapterUrl;
  String bookCover;
  String chapterId;
  String bookId;
  Timer timer;
  ChapterModel chapterDetails;
  bool isLoading = false;
  bool _isSample = false;

  TIMER_OPTIONS timerOption = TIMER_OPTIONS.CANCEL;
  Duration timerDuration;
  Timer durationTimer;

  NewAudioProvider() {
    initAudio();
  }

  void updateTimerOption(TIMER_OPTIONS option) {
    timerOption = option;
    switch (timerOption) {
      case TIMER_OPTIONS.CANCEL:
        timerDuration = null;
        break;
      case TIMER_OPTIONS.TEN:
        timerDuration = DateTime.now()
            .difference(DateTime.now().add(Duration(minutes: 10)));
        break;
      case TIMER_OPTIONS.FIFTEEN:
        timerDuration = DateTime.now()
            .difference(DateTime.now().add(Duration(minutes: 15)));
        break;
      case TIMER_OPTIONS.THIRTY:
        timerDuration = DateTime.now()
            .difference(DateTime.now().add(Duration(minutes: 30)));
        break;
      case TIMER_OPTIONS.FORTYFIVE:
        timerDuration = DateTime.now()
            .difference(DateTime.now().add(Duration(minutes: 45)));
        break;
      case TIMER_OPTIONS.SIXTY:
        timerDuration = DateTime.now()
            .difference(DateTime.now().add(Duration(minutes: 60)));
        break;
      case TIMER_OPTIONS.ENDCHAPTER:
        timerDuration =
            Duration(seconds: totalDuration.inSeconds - position.inSeconds);
        break;
    }
    if (timerOption == TIMER_OPTIONS.CANCEL && durationTimer != null)
      durationTimer.cancel();

    if (timerOption != TIMER_OPTIONS.CANCEL) startTimer();

    notifyListeners();
  }

  startTimer() {
    if (durationTimer != null) durationTimer.cancel();
    durationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      Duration remaining = Duration(
          seconds: timerOption == TIMER_OPTIONS.ENDCHAPTER
              ? Duration(seconds: totalDuration.inSeconds - position.inSeconds)
                      .inSeconds
                      .abs() +
                  2
              : Duration(seconds: timerDuration.inSeconds.abs())
                      .inSeconds
                      .abs() -
                  1);
      if (remaining == Duration.zero) {
        timer.cancel();
        SystemNavigator.pop();
      } else {
        timerDuration = remaining;
        notifyListeners();
      }
    });
  }

  ///
  ///
  ///
  initAudio() {
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      totalDuration = updatedDuration;
      // print('onDurationChanged');
      notifyListeners();
    });

    audioPlayer.onDurationChanged.listen((updatedPosition) {
      position = updatedPosition;

      notifyListeners();
    });
    audioPlayer.onPlayerComplete.listen((event) {
      audioState = AudioPlayerState.Stopped;
      if (!_isSample) {
        updatePosition(position);
      }
    });

    audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.stopped)
        audioState = AudioPlayerState.Stopped;
      if (playerState == PlayerState.playing)
        audioState = AudioPlayerState.Playing;
      if (playerState == PlayerState.paused)
        audioState = AudioPlayerState.Paused;
      notifyListeners();
    });
  }

  ///
  ///
  ///
  playAudio(String url, {bool reset = false}) async {
    ///
    ///
    int minute = 0;
    if (!_isSample) {
      Timer.periodic(Duration(seconds: 1), (_timer) {
        // it was 10 seconds
        timer = _timer;
        if (position != null && position.inSeconds > 5)
          updatePosition(position);
      });

      isLoading = true;
      // notifyListeners();

      ///
      /// Load user position
      // print("loading position...");
      // var snapshot = await FirebaseFirestore.instance
      //     .collection('books')
      //     .doc(bookId)
      //     .collection('chapters')
      //     .doc(chapterId)
      //     .get();

      // print("loaded...");
      // if (snapshot.exists) {
      //   var book = snapshot.data();
      //   totalDuration = Duration(seconds: book['duration']);
      //   if (book['listened_by'] != null) {
      //     var uid = FirebaseAuth.instance.currentUser?.uid;
      //     print('listened_by');
      //     if (book['listened_by'][uid] != null) {
      //       print('listened_by');

      //       minute = book['listened_by'][uid];
      //       print(minute);
      //     }
      //   }
      // }
      if (chapterDetails != null) {
        totalDuration = Duration(seconds: chapterDetails.duration);
        // print('chapter found');
        // print(chapterDetails.toString());
        if (chapterDetails.listenedBy != null) {
          // print('listenedBy found');
          var uid = FirebaseAuth.instance.currentUser?.uid;
          // print('listened_by');
          if (chapterDetails.listenedBy[uid] != null) {
            // print('listened_by');

            minute = chapterDetails.listenedBy[uid];
            // print(minute);
          }
        }
      }

      if (!url.contains('firebase')) {
        try {
          String downloadUrl =
              await FirebaseStorage.instance.ref(url).getDownloadURL();
          url = downloadUrl;

          chapterDetails.url = url;
        } catch (error) {
          print(error);
        }
        // notifyListeners();
      }
    }

    isLoading = false;
    ///
    ///
    await audioPlayer.play(UrlSource(url),
        position: reset
            ? Duration.zero
            : minute > 0
                ? Duration(seconds: minute)
                : null);

    // print('played');
    // if (minute > 0) {
    //   print('seeked');
    //   print(minute);
    //   var duration = Duration(seconds: minute);

    //   if (duration.inSeconds <= totalDuration.inSeconds - 5)
    //     Timer(Duration(seconds: 1), () {
    //       print(duration.inSeconds);
    //       seekAudio(duration);
    //     });
    // }
  }

  ///
  ///
  ///
  pauseAudio() async {
    if (timer != null) timer.cancel();
    await audioPlayer.pause();
  }

  ///
  ///
  ///
  stopAudio() async {
    if (timer != null) timer.cancel();
    await audioPlayer.stop();
  }

  ///
  ///
  ///
  seekAudio(Duration durationToSeek) async {
    await audioPlayer.seek(durationToSeek);
  }

  ///
  ///
  ///
  seekAudioToPosition(Duration durationToSeek) async {
    await audioPlayer.seek(position + (durationToSeek));
    notifyListeners();
  }

  ///
  ///
  ///
  mute(bool isMuted) async {
    if (isMuted) {
      await audioPlayer.setVolume(1);
    } else {
      await audioPlayer.setVolume(0);
    }
  }

  ///
  ///
  ///
  Future<void> updatePosition(Duration currntPosition) async {
    if (currntPosition == null) return;
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
    if (chapterDetails != null) {
      if (chapterDetails.listenedBy == null) chapterDetails.listenedBy = {};
      chapterDetails.listenedBy[FirebaseAuth.instance.currentUser?.uid] =
          currntPosition.inSeconds;
    }
  }

  ///
  ///
  ///
  String get getDurationText {
    durationText =
        totalDuration != null ? totalDuration.toString().split('.').first : '';
    return durationText;
  }

  ///
  ///
  ///
  String get getPositionText {
    positionText = position != null ? position.toString().split('.').first : '';
    return positionText;
  }

  ///
  ///
  ///
  bool get isSample {
    return _isSample;
  }

  ///
  ///
  ///
  set isSample(bool isSampleAudio) {
    _isSample = isSampleAudio;
    // notifyListeners();
  }
}
