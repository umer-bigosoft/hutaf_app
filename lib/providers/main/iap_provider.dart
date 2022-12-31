import 'dart:async';
import 'package:Hutaf/models/main/hutaf_subscription_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_provider.dart';

class IAPProvider with ChangeNotifier {
  final InAppPurchase _connection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  String _purchasingId = '';
  bool _isPurchasing = false;
  PurchaseStatus _purchaseStatus = PurchaseStatus.pending;
  String _error = '';
  Function _onSuccess;
  Function _onError;
  List<PurchaseDetails> _purchases = [];
  List<HutafSubscription> subscriptions = [];

  HttpsCallable _verifyPurchase =
      FirebaseFunctions.instance.httpsCallable('verifyPurchase');

  ///
  ///
  ///
  Future<void> listen() async {
    final Stream purchaseUpdates = _connection.purchaseStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _listenToPurchaseUpdated(purchases);
    });
    await _connection.isAvailable();
    //load();
    loadSubscriptions();
  }

  ///
  ///
  ///
  Future cancel() {
    return _subscription.cancel();
  }

  ///
  ///
  ///
  Future<void> purchase({
    ProductDetails product,
    String type,
    String doc,
    Function onSuccess,
    Function onError,
  }) async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    _shared.setBool(product.id, true);
    _shared.setString('${product.id}.type', type);
    _shared.setString('${product.id}.doc', doc);
    _isPurchasing = true;
    _onSuccess = onSuccess;
    _onError = onError;
    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      if (product.id.contains('subscription'))
        _connection.buyNonConsumable(purchaseParam: purchaseParam);
      else
        _connection.buyConsumable(purchaseParam: purchaseParam);
    } catch (error) {
      print(error);
      onError();
    }

    notifyListeners();
  }

  ///
  ///
  ///
  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchases) async {
    // print('New Purchases!');
    // print(purchases.length);
    purchases.forEach((PurchaseDetails purchase) async {
      // print(purchase.toString());
      if (purchase.productID == _purchasingId) {
        _purchaseStatus = purchase.status;
        _isPurchasing = purchase.status == PurchaseStatus.pending;
      }

      if (purchase.status == PurchaseStatus.error) {
        _error = purchase.error.code;
        try {
          if (purchase.pendingCompletePurchase)
            await _connection.completePurchase(purchase);
        } catch (e) {
          print(e);
        }
        print('here 1');
        _onError();
      } else if (purchase.status == PurchaseStatus.purchased) {
        SharedPreferences _shared = await SharedPreferences.getInstance();
        
        final results = await _verifyPurchase({
          'source': purchase.verificationData.source,
          'verificationData': purchase.verificationData.serverVerificationData,
          'productId': purchase.productID,
          'docId': _shared.containsKey('${purchase.productID}.doc')
              ? _shared.getString('${purchase.productID}.doc')
              : '',
          'productType': _shared.containsKey('${purchase.productID}.type')
              ? _shared.getString('${purchase.productID}.type')
              : '',
          'type': purchase.productID.contains('subscription') ? 'SUBSCRIPTION' : 'NON_SUBSCRIPTION',
        });

        bool valid = results.data as bool;

        if (!valid) {
          _purchaseStatus = PurchaseStatus.error;
          _error = 'invalid_purchase';
          notifyListeners();
          _onError();
          return;
        }
        _shared.remove('${purchase.productID}.type');
        _shared.remove('${purchase.productID}.doc');
        _shared.remove('${purchase.productID}');
        _onSuccess();
      }
      if (purchase.pendingCompletePurchase) {
        await _connection.completePurchase(purchase);
      }
      notifyListeners();
    });
  }

  // Future<void> load() async {
  //   print('Loading purchases...');
  //   final QueryPurchaseDetailsResponse response =
  //       await _connection.queryPastPurchases();
  //   if (response.error != null) {
  //     print('Load ERROR...');
  //     print(response.error.message);
  //     // Handle the error.
  //   }
  //   if (response.pastPurchases.length == 0) {
  //     print('No purchases...');
  //   }
  //   for (PurchaseDetails purchase in response.pastPurchases) {
  //     print('Purchase:');
  //     print(purchase.productID);
  //     // _verifyPurchase(
  //     //     purchase);
  //     // if (purchase.pendingCompletePurchase) {
  //     //   await _connection.completePurchase(purchase);
  //     // }
  //   }
  //   _purchases = response.pastPurchases;
  // }
  ///
  ///
  ///
  Future<void> loadSubscriptions() async {
    // print('subscriptions');
    await FirebaseFirestore.instance
        .collection('subscriptions')
        .get()
        .then((snapshot) {
      // print(snapshot.docs.length);
      subscriptions.clear();
      for (var x = 0; x < snapshot.docs.length; x++) {
        var doc = snapshot.docs[x];
        if (doc.exists) {
          if (doc.data().isNotEmpty) {
            subscriptions.add(HutafSubscription.fromSnapshot(doc.data()));
          }
        }
      }
    }).catchError((error) {
      // print(error.toString());
    });
  }

  ///
  ///
  ///
  HutafSubscription get subscription {
    for (var purchase in _purchases) {
      if (purchase.productID.startsWith('test_sub_'))
        return subscriptions
            .where((element) => purchase.productID == element.productId)
            .toList()[0];
    }
    return null;
  }

  // bool isPurchased(String productId) {
  //   for (var purchase in _purchases) {
  //     if (purchase.productID == productId) return true;
  //   }
  //   return hasSubscription;
  // }
  ///
  ///
  ///
  Future<void> verify(product) async {}

  ///
  ///
  ///
  set purchasingId(purchasingId) {
    _purchasingId = purchasingId;
  }

  ///
  ///
  ///
  String get purchasingId {
    return _purchasingId;
  }

  ///
  ///
  ///
  PurchaseStatus get purchasingStatus {
    return _purchaseStatus;
  }

  ///
  ///
  ///
  String get purchaseError {
    return _error;
  }

  ///
  ///
  ///
  bool get isPurchasing {
    return _isPurchasing;
  }

  // bool get hasSubscription {
  //   for (var purchase in _purchases) {
  //     if (purchase.productID.startsWith('test_sub_')) return true;
  //   }
  //   return false;
  // }

}
