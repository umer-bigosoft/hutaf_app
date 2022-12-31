import 'dart:io';

import 'package:Hutaf/models/courses/course_model.dart';
import 'package:Hutaf/models/main/category_model.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class CoursesProvider with ChangeNotifier {
  CourseModel _course = CourseModel(
    id: '',
    name: '',
    description: '',
    downloadedBy: [],
    evaluatedBy: [],
    evaluation: 0,
    duration: 0,
    image: '',
    price: 0.0,
    totalOfUsersInvolved: 0,
    trainerId: '',
    trainerName: '',
  );
  bool _isCourseDetailsError = false;
  bool _isCourseDetailsEmpty = false;
  List<CourseModel> _allCourses = [];
  List<CategoryModel> _categoriesList = [];
  bool _isCoursesError = false;
  bool _isCategotyCoursesError = false;
  List<CourseModel> _categoryCourses = [];
  List<CourseModel> searchCourses = [];
  bool _isCategotyGetCoursesError = false;

  bool isCourseAvailable = false;

  bool isPayButtonLoading = false;
  ProductDetails _storeProduct;

  ///
  ///
  ///
  Future getCourses() async {
    _allCourses.clear();
    _isCoursesError = false;
    await FirebaseFirestore.instance
        .collection('courses')
        .orderBy('price')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _allCourses = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _allCourses.add(CourseModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _allCourses[_allCourses.length - 1].image = url;
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
  Future getCoursesCategories() async {
    _categoriesList.clear();
    _isCategotyCoursesError = false;
    await FirebaseFirestore.instance
        .collection('categories')
        .where('type', isEqualTo: 'course')
        .get()
        .then((documents) {
      if (documents.docs.length == 0) {
        _categoriesList = [];
      }
      documents.docs.forEach((doc) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _categoriesList.add(CategoryModel.fromSnapshot(doc.id, doc.data()));
          }
        }
      });
    }).catchError((error) {
      // print('Hereeee' + error.toString());
      _isCategotyCoursesError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future<void> shareBook(String title, String text) async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    await FlutterShare.share(
      title: title,
      text: title + '\n' + text,
      chooserTitle: title,
      linkUrl: Platform.isIOS
          ? remoteConfig.getString('app_store_link')
          : remoteConfig.getString('google_play_link'),
    );
  }

  ///
  ///
  ///
  Future getCatergoryCourses(String categoryId) async {
    _categoryCourses.clear();
    _isCategotyGetCoursesError = false;
    await FirebaseFirestore.instance
        .collection('courses')
        .where('categories', arrayContains: categoryId)
        .orderBy('price')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _categoryCourses = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _categoryCourses.add(CourseModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _categoryCourses[_categoryCourses.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      _isCategotyGetCoursesError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future getDetails(String courseId) async {
    _isCourseDetailsEmpty = false;
    _isCourseDetailsError = false;
    clearCourseDetailsData();
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .get()
        .then((doc) async {
      if (doc.exists) {
        if (doc.data().isNotEmpty) {
          _course = CourseModel.fromSnapshot(doc.id, doc.data());
          try {
            String url = Assets.getPublicMedia(doc.data()['image']);
            _course.image = url;
          } catch (error) {
            // print(error.toString());
          }
          isPayButtonLoading = true;
          if (!_course.purchasedBy
              .contains(FirebaseAuth.instance.currentUser?.uid))
            loadStoreProduct(_course.productId);
          else {
            isPayButtonLoading = false;
            isCourseAvailable = true;
          }
        } else {
          _isCourseDetailsEmpty = true;
        }
      } else {
        _isCourseDetailsEmpty = true;
      }
    }).catchError((error) {
      _isCourseDetailsError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future<void> loadStoreProduct(String productId) async {
    // Set literals require Dart 2.2. Alternatively, use `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
    isCourseAvailable = false;
    // print('StoreId');
    // print(productId);
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      // print('StoreId');
      // print('Not available');
      isPayButtonLoading = false;
      notifyListeners();
      return;
    } else {
      // print('StoreId');
      // print('Available');
    }
    Set<String> _kIds = {productId};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
      // print('StoreId');
      // print('Not Found');
      isPayButtonLoading = false;
      notifyListeners();
      return;
    }
    isCourseAvailable = true;
    _storeProduct = response.productDetails[0];
    isPayButtonLoading = false;
    notifyListeners();
  }

  ///
  ///
  ///
  Future<void> shareCourse(String title, String text) async {
    await FlutterShare.share(
      title: title,
      text: text,
      chooserTitle: title,
      // linkUrl: '',
    );
  }

  ///
  ///
  ///
  Future rateTheCourse(double rating, String courseId, String uid) async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .update({
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
  Future<void> puchaseFree(String id, {Function onDone}) async {
    isPayButtonLoading = true;
    notifyListeners();
    HttpsCallable _purchaseFree =
        FirebaseFunctions.instance.httpsCallable('purchaseFreeCourse');

    final results = await _purchaseFree({'courseId': id});
    if (results.data['success'])
      _course.purchasedBy.add(FirebaseAuth.instance.currentUser?.uid);
    isPayButtonLoading = false;
    notifyListeners();
    if (onDone != null) onDone(results);
  }

  ///
  ///
  ///
  Future courseSearch(String searchKeyword) async {
    searchCourses.clear();
    _categoryCourses.forEach((course) {
      if (course.name.contains(searchKeyword)) {
        searchCourses.add(course);
      }
    });
    notifyListeners();
  }

  ///
  ///
  ///
  void clearCourseDetailsData() {
    _course = CourseModel(
      id: '',
      name: '',
      description: '',
      downloadedBy: [],
      evaluatedBy: [],
      evaluation: 0,
      duration: 0,
      image: '',
      price: 0.0,
      totalOfUsersInvolved: 0,
      trainerId: '',
      trainerName: '',
    );
  }

  ///
  ///
  ///
  CourseModel get course {
    return _course;
  }

  ///
  ///
  ///
  List<CourseModel> get allCourses {
    return [..._allCourses];
  }

  ///
  ///
  ///
  List<CourseModel> get categoryCourses {
    return [..._categoryCourses];
  }

  ///
  ///
  ///
  List<CategoryModel> get categoriesList {
    return [..._categoriesList];
  }

  ///
  ///
  ///
  bool get isCourseDetailsEmpty {
    return _isCourseDetailsEmpty;
  }

  ///
  ///
  ///
  bool get isCourseDetailsError {
    return _isCourseDetailsError;
  }

  ///
  ///
  ///
  bool get isCoursesError {
    return _isCoursesError;
  }

  ///
  ///
  ///
  bool get isCategotyCoursesError {
    return _isCategotyCoursesError;
  }

  ///
  ///
  ///
  bool get isCategotyGetCoursesError {
    return _isCategotyGetCoursesError;
  }

  ///
  ///
  ///
  ProductDetails get storeProduct {
    return _storeProduct;
  }

  ///
  ///
  ///
  void notify() {
    notifyListeners();
  }
}
