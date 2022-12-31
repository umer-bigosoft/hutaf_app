import 'dart:io';

import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/models/books/chapter_model.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class BooksProvider with ChangeNotifier {
  BookModel _book = BookModel(
    name: '',
    description: '',
    category: {},
    categoryId: '',
    writerName: '',
    evaluation: 0,
    recordedBy: '',
    usersInvolved: 0,
    image: '',
    otherDetails: '',
    price: 0.0,
    publisher: '',
    purchasedBy: [],
    downloadedBy: [],
    duration: 0,
    help: '',
    narrator: '',
  );
  bool _isBookDetailsError = false;
  bool _isBookDetailsEmpty = false;
  ProductDetails _storeProduct;
  bool isBookAvailable = false;
  // String reachedChapter = '';
  ChapterModel reachedChapterDetails;

  bool isPayButtonLoading = false;

  ///
  ///
  ///
  Future getDetails(String bookId) async {
    _isBookDetailsEmpty = false;
    _isBookDetailsError = false;
    clearBookDetailsData();
    await getReachedChapter(bookId);
    await FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .get()
        .then((doc) async {
      if (doc.exists) {
        if (doc.data().isNotEmpty) {
          _book = BookModel.fromSnapshot(doc.id, doc.data());
          try {
            String url = Assets.getPublicMedia(doc.data()['image']);
            String sampleUrl = Assets.getPublicMedia(doc.data()['sample_url']);
            _book.image = url;
            _book.sampleUrl = sampleUrl;
          } catch (error) {
            // print(error.toString());
          }
          isPayButtonLoading = true;
          if (!_book.purchasedBy
              .contains(FirebaseAuth.instance.currentUser?.uid))
            loadStoreProduct(_book.productId);
          else {
            isPayButtonLoading = false;
            isBookAvailable = true;
          }
        } else {
          _isBookDetailsEmpty = true;
        }
      } else {
        _isBookDetailsEmpty = true;
      }
    }).catchError((error) {
      _isBookDetailsError = true;
    });
    notifyListeners();
  }

  ///
  ///  Get the chapter that the user reached last time
  ///
  Future getReachedChapter(String bookId) async {
    reachedChapterDetails = ChapterModel(
      duration: 0,
      title: '',
      id: '',
      url: '',
    );
    String reachedChapter = '';
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
        }
      }
      // print(reachedChapter);
      ///
      ///
    }).then((_) async {
      if (reachedChapter != '') {
        // print('Here');
        await FirebaseFirestore.instance
            .collection('books')
            .doc(bookId)
            .collection('chapters')
            .doc(reachedChapter)
            .get()
            .then((value) async {
          reachedChapterDetails =
              ChapterModel.fromSpanshot(value.id, value.data());
          try {
            String url = await FirebaseStorage.instance
                .ref(value.data()['url'])
                .getDownloadURL();
            reachedChapterDetails.url = url;
          } catch (error) {
            // print(error.toString());
          }
          // reachedChapterDetails.title = value.data()['title'];
          // reachedChapterDetails.id = value.id;
          // reachedChapterDetails.duration = value.data()['duration'];
        });
      }
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future<void> loadStoreProduct(String productId) async {
    // Set literals require Dart 2.2. Alternatively, use `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
    // print('StoreId');
    // print(productId);
    isBookAvailable = false;
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
    isBookAvailable = true;
    isPayButtonLoading = false;
    notifyListeners();
    _storeProduct = response.productDetails[0];
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
  void purchaseFree(String id, {Function onDone}) async {
    if (!_book.purchasedBy.contains(FirebaseAuth.instance.currentUser?.uid)) {
      _book.purchasedBy.add(FirebaseAuth.instance.currentUser?.uid);
      await FirebaseFirestore.instance
          .collection('books')
          .doc(id)
          .update({'purchased_by': _book.purchasedBy});
    }
  }

  void removeFreeBook(String id, List<dynamic> purchasedBy) async {
    if (purchasedBy.contains(FirebaseAuth.instance.currentUser?.uid)) {
      purchasedBy.remove(FirebaseAuth.instance.currentUser?.uid);
      await FirebaseFirestore.instance
          .collection('books')
          .doc(id)
          .update({'purchased_by': purchasedBy});
    }
  }

  ///
  ///
  ///
  Future<void> purchaseWithPoints(String id, {Function onDone}) async {
    isPayButtonLoading = true;
    notifyListeners();
    HttpsCallable _purchaseWithPoints =
        FirebaseFunctions.instance.httpsCallable('purchaseBookWithPoints');

    final results = await _purchaseWithPoints({'bookId': id});
    // print(results.data['data']);

    isPayButtonLoading = false;
    if (results.data['success']) {
      results.data['__type'] = 1;
      _book.purchasedBy.add(FirebaseAuth.instance.currentUser?.uid);
    }
    notifyListeners();
    if (onDone != null) onDone(results);
  }

  ///
  ///
  ///
  void clearBookDetailsData() {
    _book = BookModel(
      name: '',
      description: '',
      category: {},
      categoryId: '',
      writerName: '',
      evaluation: 0,
      recordedBy: '',
      usersInvolved: 0,
      image: '',
      otherDetails: '',
      price: 0.0,
      publisher: '',
      purchasedBy: [],
      downloadedBy: [],
      duration: 0,
      help: '',
      narrator: '',
    );
  }

  ///
  ///
  ///
  BookModel get book {
    return _book;
  }

  ///
  ///
  ///
  bool get isBookDetailsEmpty {
    return _isBookDetailsEmpty;
  }

  ///
  ///
  ///
  bool get isBookDetailsError {
    return _isBookDetailsError;
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
