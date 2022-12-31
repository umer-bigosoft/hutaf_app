import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/models/courses/course_model.dart';
import 'package:Hutaf/models/main/home_advertisement_model.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeProvider with ChangeNotifier {
  List<CourseModel> _homeCourses = [];
  List<CourseModel> _homeCoursesByInterests = [];
  List<CourseModel> searchCourses = [];
  Map<String, List<CourseModel>> _categoryCourses = {};
  List<HomeAdvertisementModel> _bookAdsImages = [];
  List<HomeAdvertisementModel> _courseAdsImages = [];
  List<BookModel> _homeBooks = [];
  List<BookModel> _freeBooks = [];
  List<BookModel> _categoryBooks = [];
  List<BookModel> _homeBooksByInterests = [];
  List<BookModel> searchBooks = [];
  bool _isHomeCoursesError = false;
  bool _isHomeBooksError = false;
  bool _isAdvertisementsError = false;
  bool _isHomeBooksByInterestsError = false;
  bool _isHomeCoursesByInterestsError = false;
  bool _isCategotyBooksError = false;

  Future getCourses() async {
    _homeCourses.clear();
    _isHomeCoursesError = false;
    await FirebaseFirestore.instance
        .collection('courses')
        .orderBy('created_at', descending: true)
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _homeCourses = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _homeCourses.add(CourseModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _homeCourses[_homeCourses.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      print('========' + error.toString());
      _isHomeCoursesError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future bookSearch(String searchKeyword) async {
    searchBooks.clear();
    _homeBooks.forEach((book) {
      if (book.name.contains(searchKeyword)) {
        searchBooks.add(book);
      }
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future courseSearch(String searchKeyword) async {
    searchCourses.clear();
    _homeCourses.forEach((course) {
      if (course.name.contains(searchKeyword)) {
        searchCourses.add(course);
      }
    });
    notifyListeners();
  }

  Future getCourseAdvertisements() async {
    _courseAdsImages.clear();
    _isAdvertisementsError = false;
    await FirebaseFirestore.instance
        .collection('advertisements')
        .where('type', isEqualTo: 'course')
        .orderBy('date')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _courseAdsImages = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _courseAdsImages
                .add(HomeAdvertisementModel.fromSpanshot(doc.id, doc.data()));
            try {
              String imageUrl = Assets.getPublicMedia(doc.data()['image']);
              _courseAdsImages[_courseAdsImages.length - 1].image = imageUrl;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      _isAdvertisementsError = true;
    });
    notifyListeners();
  }

  Future getBookAdvertisements() async {
    _bookAdsImages.clear();
    _isAdvertisementsError = false;
    await FirebaseFirestore.instance
        .collection('advertisements')
        .where('type', isEqualTo: 'book')
        .orderBy('date')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _bookAdsImages = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _bookAdsImages
                .add(HomeAdvertisementModel.fromSpanshot(doc.id, doc.data()));
            try {
              String imageUrl = Assets.getPublicMedia(doc.data()['image']);
              _bookAdsImages[_bookAdsImages.length - 1].image = imageUrl;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      _isAdvertisementsError = true;
    });
    notifyListeners();
  }

  Future getFreeBooks() async {
    _freeBooks.clear();
    await FirebaseFirestore.instance
        .collection('books')
        .where('isFree', isEqualTo: true)
        .orderBy('created_at', descending: true)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.length == 0) {
        _freeBooks = [];
      }
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            final book = BookModel.fromSnapshot(doc.id, doc.data());
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              book.image = url;
              _freeBooks.add(book);
            } catch (error) {
              print(error);
            }
          }
        }
      }
    }).catchError((error) {
      print(error);
    });
    notifyListeners();
  }

  Future getBooks() async {
    _homeBooks.clear();
    _isHomeBooksError = false;
    await FirebaseFirestore.instance
        .collection('books')
        .orderBy('created_at', descending: true)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.length == 0) {
        _homeBooks = [];
      }
      for (var doc in snapshot.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _homeBooks.add(BookModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _homeBooks[_homeBooks.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      _isHomeBooksError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future getBooksByInterests(String uid) async {
    _homeBooksByInterests.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) async {
      List userInterests = snapshot.data()['interests'];
      try {
        await FirebaseFirestore.instance
            .collection('books')
            .where('categories',
                arrayContainsAny: userInterests.length < 10
                    ? userInterests
                    : userInterests.sublist(0, 10))
            .get()
            .then((snapshot) async {
          for (var doc in snapshot.docs) {
            if (doc.exists) {
              if (doc.data().isNotEmpty) {
                _homeBooksByInterests
                    .add(BookModel.fromSnapshot(doc.id, doc.data()));
                try {
                  String url = Assets.getPublicMedia(doc.data()['image']);
                  _homeBooksByInterests[_homeBooksByInterests.length - 1]
                      .image = url;
                } catch (error) {}
              }
            }
          }
        });
      } catch (error) {
        print(error);
        _isHomeBooksByInterestsError = true;
      }

      notifyListeners();
    });
  }

  ///
  ///
  ///
  Future getCoursesByInterests(String uid) async {
    _homeCoursesByInterests.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) async {
      List userInterests = snapshot.data()['interests'];

      try {
        await FirebaseFirestore.instance
            .collection('courses')
            .where('categories',
                arrayContainsAny: userInterests.length < 10
                    ? userInterests
                    : userInterests.sublist(0, 10))
            .get()
            .then((documents) async {
          for (var doc in documents.docs) {
            if (doc.exists) {
              if (doc.data().isNotEmpty) {
                _homeCoursesByInterests
                    .add(CourseModel.fromSnapshot(doc.id, doc.data()));
                try {
                  String url = Assets.getPublicMedia(doc.data()['image']);
                  _homeCoursesByInterests[_homeCoursesByInterests.length - 1]
                      .image = url;
                } catch (error) {
                  // print(error.toString());
                }
              }
            }
          }
        });
      } catch (error) {
        _isHomeCoursesByInterestsError = true;
      }

      notifyListeners();
    });
  }

  Future getCategoryBooks(String categoryId) async {
    _categoryBooks.clear();
    _isCategotyBooksError = false;
    await FirebaseFirestore.instance
        .collection('books')
        .where('categories', arrayContains: categoryId)
        .orderBy('price')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _categoryBooks = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _categoryBooks.add(BookModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _categoryBooks[_categoryBooks.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      // print('Hereeee' + error.toString());
      _isCategotyBooksError = true;
    });
    notifyListeners();
  }

  Future getCategoryCourses(String categoryId) async {
    _categoryCourses[categoryId] = [];
    await FirebaseFirestore.instance
        .collection('courses')
        .where('categories', arrayContains: categoryId)
        .orderBy('price')
        .get()
        .then((documents) async {
      final List<CourseModel> courses = _categoryCourses[categoryId];
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            courses.add(CourseModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              courses[courses.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
      notifyListeners();
    }).catchError((error) {});
  }

  ///
  ///
  ///
  List<CourseModel> get homeCourses {
    return [..._homeCourses];
  }

  ///
  ///
  ///
  List<HomeAdvertisementModel> get bookAdsImages {
    return [..._bookAdsImages];
  }

  List<HomeAdvertisementModel> get courseAdsImages {
    return [..._courseAdsImages];
  }

  ///
  ///
  ///
  List<BookModel> get homeBooks {
    return [..._homeBooks];
  }

  ///
  ///
  ///
  List<BookModel> get homeBooksByInterests {
    return [..._homeBooksByInterests];
  }

  List<BookModel> get freeBooks {
    return [..._freeBooks];
  }

  List<BookModel> get categoryBooks {
    return [..._categoryBooks];
  }

  ///
  ///
  ///
  List<CourseModel> get homeCoursesByInterests {
    return [..._homeCoursesByInterests];
  }

  List<CourseModel> categoryCourses(String categoryId) {
    return [..._categoryCourses[categoryId] ?? []];
  }

  ///
  ///
  ///
  set homeCoursesByInterests(List<CourseModel> homeCoursesByInterests) {
    _homeCoursesByInterests = _homeCoursesByInterests;
    notifyListeners();
  }

  ///
  ///
  ///
  set homeBooksByInterests(List<BookModel> homeBooksByInterests) {
    _homeBooksByInterests = homeBooksByInterests;
    notifyListeners();
  }

  ///
  ///
  ///
  bool get isHomeCoursesError {
    return _isHomeCoursesError;
  }

  ///
  ///
  ///
  bool get isHomeBooksError {
    return _isHomeBooksError;
  }

  ///
  ///
  ///
  bool get isHomeBooksByInterestsError {
    return _isHomeBooksByInterestsError;
  }

  ///
  ///
  ///
  bool get isHomeCoursesByInterestsError {
    return _isHomeCoursesByInterestsError;
  }

  ///
  ///
  ///
  bool get isAdvertisementsError {
    return _isAdvertisementsError;
  }

  bool get isCategotyBooksError {
    return _isCategotyBooksError;
  }
}
