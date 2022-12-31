import 'dart:io';

import 'package:Hutaf/models/main/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:easy_localization/easy_localization.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> _notes = [];
  bool _isError = false;
  bool _isLoading = false;

  bool isAdding = false;

  ///
  ///
  ///
  Future getUserNotes(String uid, {bool notify = false}) async {
    _isLoading = true;
    if (notify) notifyListeners();
    _isError = false;
    _notes.clear();
    await FirebaseFirestore.instance
        .collection('notes')
        .where('user_id', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get()
        .then((documents) {
      // print(documents.docs.length);
      if (documents.docs.length == 0) {
        _notes = [];
      }
      _notes.clear();
      documents.docs.forEach((doc) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _notes.add(NoteModel.fromSpanshot(doc.id, doc.data()));
          }
        }
      });
    }).catchError((error) {
      _isError = true;
    });
    _isLoading = false;
    notifyListeners();
  }

  ///
  ///
  ///
  Future<void> deleteNote(String docId) async {
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(docId)
        .delete()
        .then((_) {
      _notes.removeWhere((element) => element.docId == docId);
      notifyListeners();
    });
  }

  ///
  ///
  ///
  Future<void> shareNote(String title, String text) async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    await FlutterShare.share(
      title: title,
      text: title + '\n' + text,
      chooserTitle: 'menu.my_notes'.tr(),
      linkUrl: Platform.isIOS
          ? remoteConfig.getString('app_store_link')
          : remoteConfig.getString('google_play_link'),
    );
  }

  ///
  ///
  ///
  Future<void> addNote(String title, String text, {Function onDone}) async {
    String uid = FirebaseAuth.instance.currentUser?.uid;

    isAdding = true;
    notifyListeners();

    await FirebaseFirestore.instance.collection('notes').doc().set(
      {
        'date': DateTime.now().millisecondsSinceEpoch,
        'title': title,
        'text': text,
        'user_id': uid,
      },
    );
    getUserNotes(
      uid,
      notify: true,
    );
    isAdding = false;
    notifyListeners();
    if (onDone != null) onDone();
  }

  ///
  ///
  ///
  Future<void> editNote(String title, String text, NoteModel note,
      {Function onDone}) async {
    String uid = FirebaseAuth.instance.currentUser?.uid;

    isAdding = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('notes').doc(note.docId).set(
        {
          'updated': DateTime.now().millisecondsSinceEpoch,
          'title': title,
          'text': text,
          'user_id': uid,
        },
        SetOptions(
          merge: true,
        ),
      );
      note.title = title;
      note.text = text;
    } catch (e) {}
    getUserNotes(
      uid,
      notify: true,
    );
    isAdding = false;
    notifyListeners();
    if (onDone != null) onDone();
  }

  ///
  ///
  ///
  List<NoteModel> get notes {
    return [..._notes];
  }

  ///
  ///
  ///
  bool get isError {
    return _isError;
  }

  ///
  ///
  ///
  bool get isLoading {
    return _isLoading;
  }
}
