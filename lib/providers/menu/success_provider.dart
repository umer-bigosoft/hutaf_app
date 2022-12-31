import 'package:Hutaf/models/success/success_modal.dart';
import 'package:Hutaf/utils/general_vars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SuccessProvider with ChangeNotifier {
  List<SuccessModal> _strategics = [];
  List<SuccessModal> _supportings = [];
  List<SuccessModal> _associates = [];
  bool _isSuccessError = false;

  ///
  ///
  ///
  Future getSuccessDetails() async {
    _isSuccessError = false;
    await FirebaseFirestore.instance
        .collection('success')
        .get()
        .then((documents) async {
      if (documents.docs.length == 0) {
        _strategics = [];
        _supportings = [];
        _associates = [];
      }
      _strategics.clear();
      _supportings.clear();
      _associates.clear();
      for (var doc in documents.docs) {
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            switch (doc.data()['type']) {
              case '0':
                _strategics.add(SuccessModal.fromSnapshot(doc.id, doc.data()));
                try {
                  String imageUrl = Assets.getPublicMedia(doc.data()['image']);

                  _strategics[_strategics.length - 1].image = imageUrl;
                } catch (error) {
                  // print(error.toString());
                }
                break;
              case '1':
                _supportings.add(SuccessModal.fromSnapshot(doc.id, doc.data()));
                try {
                  String imageUrl = Assets.getPublicMedia(doc.data()['image']);

                  _supportings[_supportings.length - 1].image = imageUrl;
                } catch (error) {
                  // print(error.toString());
                }
                break;
              case '2':
                _associates.add(SuccessModal.fromSnapshot(doc.id, doc.data()));
                try {
                  String imageUrl = Assets.getPublicMedia(doc.data()['image']);

                  _associates[_associates.length - 1].image = imageUrl;
                } catch (error) {
                  // print(error.toString());
                }
                break;
              default:
            }
          }
        }
      }
    }).catchError((error) {
      _isSuccessError = true;
    });
  }

  ///
  ///
  ///
  bool get isSuccessError {
    return _isSuccessError;
  }

  ///
  ///
  ///
  List<SuccessModal> get strategics {
    return [..._strategics];
  }

  ///
  ///
  ///
  List<SuccessModal> get supportings {
    return [..._supportings];
  }

  ///
  ///
  ///
  List<SuccessModal> get associates {
    return [..._associates];
  }
}
