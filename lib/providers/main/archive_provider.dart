import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/models/courses/course_model.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchiveProvider with ChangeNotifier {
  List<CourseModel> _userCourses = [];
  List<BookModel> _userBooks = [];
  bool _isBooksError = false;
  bool _isCoursesError = false;

  void removeUserBook(String bookId) {
    final index = _userBooks.indexWhere((element) => element.id == bookId);
    if (index != -1) _userBooks.removeAt(index);
    notifyListeners();
  }

  ///
  /// Get user's purchased books
  ///
  Future getUserBooks(String uid) async {
    _userBooks.clear();
    _isBooksError = false;
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('watched') ?? [];
    await FirebaseFirestore.instance
        .collection('books')
        .where('purchased_by', arrayContains: uid)
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _userBooks = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            final index = list.indexOf(doc.id);
            final book = BookModel.fromSnapshot(doc.id, doc.data());
            if (index != -1 && index < _userBooks.length) {
              _userBooks.insert(index, book);
              try {
                String url = Assets.getPublicMedia(doc.data()['image']);
                _userBooks[index].image = url;
              } catch (error) {
                print(error);
              }
            } else {
              _userBooks.add(book);
              try {
                String url = Assets.getPublicMedia(doc.data()['image']);
                _userBooks[_userBooks.length - 1].image = url;
              } catch (error) {
                print(error);
              }
            }
          }
        }
      }
    }).catchError((error) {
      print(error);
      // print('Hereeee' + error.toString());
      _isBooksError = true;
    });
    notifyListeners();
  }

  ///
  /// Get user's purchased courses
  ///
  Future getUserCourses(String uid) async {
    _userCourses.clear();
    _isCoursesError = false;
    await FirebaseFirestore.instance
        .collection('courses')
        .where('purchased_by', arrayContains: uid)
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _userCourses = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _userCourses.add(CourseModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _userCourses[_userCourses.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      // print('Hereeee' + error.toString());
      _isCoursesError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  List<BookModel> get userBooks {
    return [..._userBooks];
  }

  ///
  ///
  ///
  List<CourseModel> get userCourses {
    return [..._userCourses];
  }

  ///
  ///
  ///
  bool get isBooksError {
    return _isBooksError;
  }

  ///
  ///
  ///
  bool get isCoursesError {
    return _isCoursesError;
  }
}
