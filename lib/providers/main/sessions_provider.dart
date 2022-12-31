import 'package:Hutaf/models/courses/session_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SessionsProvider with ChangeNotifier {
  List<SessionModel> _sessions = [];
  bool _isSessionsError = false;
  bool _isSessionsEmpty = false;
  String reachedSession = '';

  // HttpsCallable _updatePosition =
  //     FirebaseFunctions.instance.httpsCallable('updatePosition');
  ///
  ///
  ///
  Future getSessions(String courseId) async {
    _isSessionsError = false;
    _isSessionsEmpty = false;
    _sessions.clear();
    getReachedSession(courseId);
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('lessons')
        .orderBy('number', descending: false)
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _isSessionsEmpty = true;
      }
      _sessions.clear();
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _sessions.add(SessionModel.fromSpanshot(doc.id, doc.data()));
          } else {
            _isSessionsEmpty = true;
          }
        } else {
          _isSessionsEmpty = true;
        }
      }
    }).catchError((error) {
      _isSessionsError = true;
      // print(error);
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future getReachedSession(String courseId) async {
    reachedSession = '';
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .get()
        .then((doc) {
      ///
      /// To get the reached chapter
      ///
      if (doc.data()['listening_to_chapter'] != null) {
        var uid = FirebaseAuth.instance.currentUser?.uid;
        // print('listened_to_chapter');
        if (doc.data()['listening_to_chapter'][uid] != null) {
          // print('listened_to_chapter2');
          // print(doc.data()['listening_to_chapter'][uid]);
          reachedSession = doc.data()['listening_to_chapter'][uid];
          // print('Here========' + reachedSession);
        }
      }
    });
  }

  ///
  ///
  ///
  Future<void> updateSession(String courseId, String sessionId) async {
    await FirebaseFirestore.instance.collection('courses').doc(courseId).set(
      {
        'listening_to_chapter': {
          FirebaseAuth.instance.currentUser?.uid: sessionId,
        },
      },
      SetOptions(merge: true),
    );
    reachedSession = sessionId;
    notifyListeners();
  }

  ///
  ///
  ///
  Future<void> updatePosition(
      Duration position, String courseId, String sessionId) async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('lessons')
        .doc(sessionId)
        .set(
      {
        'listened_by': {
          FirebaseAuth.instance.currentUser?.uid: position.inSeconds,
        }
      },
      SetOptions(merge: true),
    );
    // final result =
    // await _updatePosition({
    //   'id': courseId, // book or course id
    //   'type': 'COURSE', // BOOK, COURSE
    //   'position': position.inSeconds, // current position in seconds
    //   'chapter': sessionId, // chapter id
    // });
  }

  ///
  ///
  ///
  List<SessionModel> get sessions {
    return [..._sessions];
  }

  ///
  ///
  ///
  bool get isSessionsEmpty {
    return _isSessionsEmpty;
  }

  ///
  ///
  ///
  bool get isSessionsError {
    return _isSessionsError;
  }
}
