import 'package:Hutaf/models/books/chapter_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChaptersProvider with ChangeNotifier {
  List<ChapterModel> _chapters = [];
  bool _isChaptersError = false;
  bool _isChaptersEmpty = false;
  String reachedChapter = '';

  int time = -1;

  Future<List<ChapterModel>> getChaptersList(String bookId) async {
    final documents = await FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .collection('chapters')
        .orderBy('number', descending: false)
        .get();
    final chapters = <ChapterModel>[];
    for (var doc in documents.docs) {
      if (doc.exists) {
        if (doc.data().isNotEmpty) {
          chapters.add(ChapterModel.fromSpanshot(doc.id, doc.data()));
        }
      }
    }
    return chapters;
  }

  ///
  ///
  ///
  Future getChapters(String bookId) async {
    _isChaptersError = false;
    _isChaptersEmpty = false;
    _chapters.clear();
    await getReachedChapter(bookId);
    await FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .collection('chapters')
        .orderBy('number', descending: false)
        .get()
        .then((documents) async {
      // print(documents.docs.length);
      if (documents.docs.length == 0) {
        _isChaptersEmpty = true;
      }
      _chapters.clear();
      // documents.docs.forEach((doc) {
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _chapters.add(ChapterModel.fromSpanshot(doc.id, doc.data()));
          } else {
            _isChaptersEmpty = true;
          }
        } else {
          _isChaptersEmpty = true;
        }
      }
      // });
    }).catchError((error) {
      _isChaptersError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future getReachedChapter(String bookId) async {
    reachedChapter = '';
    await FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
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
          reachedChapter = doc.data()['listening_to_chapter'][uid];
          // print('Here========' + reachedChapter);
        }
      }

      ///
      ///
    });
  }

  ///
  ///
  ///
  Future rateTheBook(double rating, String bookId, String uid) async {
    await FirebaseFirestore.instance.collection('books').doc(bookId).update({
      'evaluated_by': FieldValue.arrayUnion([
        {
          'uid': uid,
          'rate': rating,
        }
      ]),
    });
  }

  ///
  ///
  ///
  Future<void> updateChapter(String bookId, String chapterId) async {
    await FirebaseFirestore.instance.collection('books').doc(bookId).set(
      {
        'listening_to_chapter': {
          FirebaseAuth.instance.currentUser?.uid: chapterId,
        },
      },
      SetOptions(merge: true),
    );
    reachedChapter = chapterId;
    notifyListeners();
  }

  ///
  ///
  ///
  List<ChapterModel> get chapters {
    return [..._chapters];
  }

  ///
  ///
  ///
  bool get isChaptersEmpty {
    return _isChaptersEmpty;
  }

  ///
  ///
  ///
  bool get isChaptersError {
    return _isChaptersError;
  }
}
