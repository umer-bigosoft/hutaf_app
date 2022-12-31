import 'package:Hutaf/models/books/book_model.dart';
import 'package:Hutaf/models/main/category_model.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LibraryProvider with ChangeNotifier {
  bool _isLibraryBooksError = false;
  bool _isCategotyBooksError = false;
  bool _isLibraryCategoriesError = false;
  List<BookModel> _libraryBooks = [];
  List<CategoryModel> _categoriesList = [];
  List<BookModel> _categoryBooks = [];
  List<BookModel> searchCategoryBooks = [];

  ///
  ///
  ///
  Future getBooks() async {
    _libraryBooks.clear();
    _isLibraryBooksError = false;
    await FirebaseFirestore.instance
        .collection('books')
        .orderBy('price')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _libraryBooks = [];
      }
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            _libraryBooks.add(BookModel.fromSnapshot(doc.id, doc.data()));
            try {
              String url = Assets.getPublicMedia(doc.data()['image']);
              _libraryBooks[_libraryBooks.length - 1].image = url;
            } catch (error) {
              // print(error.toString());
            }
          }
        }
      }
    }).catchError((error) {
      // print('Hereeee' + error.toString());
      _isLibraryBooksError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future getCatergoryBooks(String categoryId) async {
    _categoryBooks.clear();
    _isLibraryBooksError = false;
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

  ///
  ///
  ///
  Future getBooksCategories() async {
    _categoriesList.clear();
    _isLibraryCategoriesError = false;
    await FirebaseFirestore.instance
        .collection('categories')
        .where('type', isEqualTo: 'book')
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
      _isLibraryCategoriesError = true;
    });
    notifyListeners();
  }

  ///
  ///
  ///
  Future bookSearch(String searchKeyword) async {
    searchCategoryBooks.clear();
    _categoryBooks.forEach((book) {
      if (book.name.contains(searchKeyword)) {
        searchCategoryBooks.add(book);
      }
    });
    notifyListeners();
  }

  ///
  ///
  ///
  List<BookModel> get libraryBooks {
    return [..._libraryBooks];
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
  List<BookModel> get categoryBooks {
    return [..._categoryBooks];
  }

  ///
  ///
  ///
  bool get isLibraryBooksError {
    return _isLibraryBooksError;
  }

  ///
  ///
  ///
  bool get isLibraryCategoriesError {
    return _isLibraryCategoriesError;
  }

  ///
  ///
  ///
  bool get isCategotyBooksError {
    return _isCategotyBooksError;
  }
}
