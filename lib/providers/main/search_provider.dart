import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/models/courses/course_model.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  List<CourseModel> _courses = [];
  List<BookModel> _books = [];

  ///
  ///
  ///
  Future getBooks(String searchKeyword) async {
    _books.clear();
    await FirebaseFirestore.instance
        .collection('books')
        .orderBy('price')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _books = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty &&
              doc.data()['book_name'].contains(searchKeyword)) {
            _books.add(BookModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _books[_books.length - 1].image = url;
            } catch (error) {
              // print('eeeee');
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      // print('Hereeee1' + error.toString());
      _books = [];
    });
  }

  ///
  ///
  ///
  Future getCourses(String searchKeyword) async {
    _courses.clear();
    await FirebaseFirestore.instance
        .collection('courses')
        .orderBy('price')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _courses = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty &&
              doc.data()['course_name'].contains(searchKeyword)) {
            _courses.add(CourseModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _courses[_courses.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      // print('Hereeee2' + error.toString());
      _courses = [];
    });
  }

  ///
  ///
  ///
  Future search(String searchKeyword) async {
    await getBooks(searchKeyword).then((_) async {
      await getCourses(searchKeyword);
    });
    notifyListeners();
  }

  ///
  ///
  ///
  void clearData() {
    _courses = [];
    _books = [];
    notifyListeners();
  }

  ///
  ///
  ///
  List<CourseModel> get courses {
    return [..._courses];
  }

  ///
  ///
  ///
  List<BookModel> get books {
    return [..._books];
  }
}
