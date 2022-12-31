import 'package:Hutaf/models/courses/session_model.dart';
import 'package:Hutaf/providers/main/sessions_provider.dart';
import 'package:Hutaf/ui/widgets/app_bar/app_bar_with_leading.dart';
import 'package:Hutaf/ui/widgets/loading/session_details_loading.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class SessionDetails extends StatefulWidget {
  final SessionModel session;
  final String courseId;
  SessionDetails(this.session, {Key key, this.courseId}) : super(key: key);

  @override
  _SessionDetailsState createState() => _SessionDetailsState();
}

class _SessionDetailsState extends State<SessionDetails> {
  /// : start changes ///
  FlickManager flickManager;
  int counter = 0;
  int _seekTo = 0;
  bool _isInit = true;
  bool _isLoading = true;
  bool _isPlayed = false;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      try {
        // String url = await FirebaseStorage.instance
        //     .ref(session.url)
        //     .getDownloadURL();
        String path = 'courses/${widget.courseId}/lessons/${widget.session.id}';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool refresh = true;
        if (prefs.containsKey('time_$path')) {
          if (prefs.getInt('time_$path') >
              DateTime.now().millisecondsSinceEpoch) refresh = false;
        }
        String url = '';
        if (refresh) {
          HttpsCallable getDownloadUrl =
              FirebaseFunctions.instance.httpsCallable('getDownloadUrl');
          final results = await getDownloadUrl({'path': path});
          // print(path);
          url = results.data['url'] as String;
          prefs.setInt(
              'time_$path',
              DateTime.now()
                  .add(
                    Duration(days: 6),
                  )
                  .millisecondsSinceEpoch); // expires after 6 days
          prefs.setString('url_$path', url);
        } else
          url = prefs.getString('url_$path');

        widget.session.url = url;
      } catch (error) {
        // print(error.toString());
      }
    }
    setState(() {
      _isLoading = false;
    });
    _isInit = false;
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  /// : end changes ///

  @override
  Widget build(BuildContext context) {
    final Size layoutSize = MediaQuery.of(context).size;

    if (!_isLoading) {
      flickManager = FlickManager(
        autoPlay: false,
        videoPlayerController:
            VideoPlayerController.network(widget.session.url),
        onVideoEnd: () {
          /// : start changes ///
          // print('ended');
          if (_isPlayed) {
            Provider.of<SessionsProvider>(context, listen: false)
                .updatePosition(
              Duration(seconds: widget.session.duration),
              widget.courseId,
              widget.session.id,
            );
            if (widget.session.listenedBy == null) {
              widget.session.listenedBy = {};
            }
            widget.session.listenedBy[FirebaseAuth.instance.currentUser?.uid] =
                widget.session.duration;
            _isPlayed = false;
          }

          /// : end changes ///
        },
      );

      /// : start changes ///
      flickManager.flickVideoManager.addListener(() {
        if (flickManager.flickVideoManager.isVideoInitialized) {
          if (_seekTo != 0) {
            _seekTo = 0;
            flickManager.flickControlManager.seekTo(
              Duration(
                seconds: widget
                    .session.listenedBy[FirebaseAuth.instance.currentUser?.uid],
              ),
            );
            flickManager.flickControlManager.togglePlay();
            flickManager.flickControlManager.togglePlay();
          }
        }

        if (flickManager.flickVideoManager.isPlaying) {
          _isPlayed = true;
          int current = flickManager
              .flickVideoManager.videoPlayerValue.position.inSeconds;
          // print(current);
          if (current > counter) {
            counter = current;
            Provider.of<SessionsProvider>(context, listen: false)
                .updatePosition(
              flickManager.flickVideoManager.videoPlayerValue.position,
              widget.courseId,
              widget.session.id,
            );
            if (widget.session.listenedBy == null) {
              widget.session.listenedBy = {};
            }
            widget.session.listenedBy[FirebaseAuth.instance.currentUser?.uid] =
                flickManager
                    .flickVideoManager.videoPlayerValue.position.inSeconds;
          }
        }
      });
      var uid = FirebaseAuth.instance.currentUser?.uid;
      if (widget.session.listenedBy != null) {
        if (widget.session.listenedBy[uid] != null) {
          if (widget.session.listenedBy[uid] <= widget.session.duration - 5)
            _seekTo = widget.session.listenedBy[uid];
          // print('_seekTo');
          // print(uid);
          // print(_seekTo);
        }
      }
    }

    /// : end changes ///

    return Scaffold(
        appBar: AppBarWithLeading(
          title: widget.session.title,
          handler: () {
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: !_isLoading
              ? ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: layoutSize.height * 0.035),
                    if (widget.session.url != '' && widget.session.url != null)
                      // Container(
                      //   // height: layoutSize.height * 0.3,
                      //   // margin: EdgeInsets.only(
                      //   //   right: layoutSize.width * 0.035,
                      //   //   left: layoutSize.width * 0.035,
                      //   // ),
                      // child:
                      FlickVideoPlayer(
                        flickManager: flickManager,
                      ),
                    // ),
                    SizedBox(height: layoutSize.height * 0.04),
                    Container(
                      margin: EdgeInsets.only(
                        right: layoutSize.width * 0.035,
                        left: layoutSize.width * 0.035,
                      ),
                      child: Text(
                        widget.session.objectives,
                        textScaleFactor: 1,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline2
                            .copyWith(
                              fontSize: layoutSize.width * 0.04,
                            ),
                      ),
                    ),
                    SizedBox(height: layoutSize.height * 0.045),
                  ],
                )
              : SessionDetailsLoading(),
        ));
  }
}
