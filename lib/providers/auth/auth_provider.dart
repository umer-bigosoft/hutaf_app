import 'package:Hutaf/models/auth/new_user_model.dart';
import 'package:Hutaf/models/auth/subscribtion_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _userName = '';
  String _firstRegistration = '';
  String _profilePhoto = '';
  int _gender = -1;
  User _user;
  bool _isLoggedIn = false;
  NewUserModel _newUser;
  UserSubscription _subscription = UserSubscription(
    active: false,
  );
  List<String> _interests = [];
  String _info = '';
  String _phone = '';

  String _phoneCode;
  String _countryCode;

  get newUser => _newUser;

  bool isSubscribed = false;

  String get phoneNumber {
    return user.phoneNumber != null ? user.phoneNumber : _phone;
  }

  String get phoneCode => _phoneCode;
  String get countryCode => _countryCode;

  void querySubscriptionStatus() {
    FirebaseFirestore.instance
        .collection('_purchases')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('type', isEqualTo: "SUBSCRIPTION")
        .where('status', isEqualTo: 'ACTIVE')
        .get()
        .then((value) {
      isSubscribed = value.size > 0;
      notifyListeners();
    });
  }

  ///
  /// To check the auth status in [splash] screen
  ///
  void watchAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user != null) {
        _userName = user.displayName != null && user.displayName != ''
            ? user.displayName
            : '';
        _profilePhoto = '';
        try {
          String url = await FirebaseStorage.instance
              .ref('profiles/' + user.uid)
              .getDownloadURL();
          _profilePhoto = url;
        } catch (error) {
          // print(error.toString());
        }

        _firstRegistration =
            DateFormat('yyyy/MM/dd').format(user.metadata.creationTime);
        _user = user;
        loadUserData();
        _isLoggedIn = true;
      } else
        _isLoggedIn = false;
      notifyListeners();
    });
  }

  ///
  /// To check if the phone number that the user want to register with it is already registered or not
  ///
  Future<int> checkIfUserPhoneNumberExist(String phone) async =>
      await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get()
          .then((documents) {
        print(documents.docs.length);
        if (documents.docs.length == 0) {
          return 0;
        } else {
          return 1;
        }
      }).catchError(
        (onError) {
          print(onError.toString());
          return -1;
        },
      );

  ///
  /// Registration function
  ///
  Future register(NewUserModel user, Function codeSent,
      {Function onError, int resendToken}) async {
    _newUser = user;
    _userName = user.name;
    notifyListeners();

    try {
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      _user = response.user;
      await _user.updateDisplayName(user.name);
      _userName = _newUser.name;
      _gender = _newUser.gender;
      _profilePhoto =
          _user.photoURL != null && _user.photoURL != '' ? _user.photoURL : '';
      _firstRegistration =
          DateFormat('yyyy/MM/dd').format(_user.metadata.creationTime);
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).set(
        {
          'gender': _newUser.gender,
          'phone': _newUser.phone,
          'country_code': _newUser.code,
          'country_code_iso': _newUser.countryCode,
          'info': '',
          'interests': [],
        },
      );
    } catch (error) {
      if (onError != null) onError(error.code);
      return Future.error(error);
    }

    _phone = user.phone;
    _phoneCode = user.code;
    _countryCode = user.countryCode;

    return sendVerificationCode(user.phone, codeSent, onError: onError);
  }

  ///
  /// Send the verification code in registration proccess
  ///
  Future sendVerificationCode(String phone, Function codeSent,
      {Function onError, int resendToken}) {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (onError != null) onError(e.message);
      },
      codeSent: (String verificationId, int resendToken) {
        if (_newUser == null) _newUser = NewUserModel();
        _newUser.verificationId = verificationId;
        _newUser.resendToken = resendToken;
        codeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: resendToken,
    );
  }

  ///
  /// Resend the verfication code
  ///
  Future resendToken(Function codeSent, {Function onError}) {
    return sendVerificationCode(_phone, codeSent,
        resendToken: _newUser.resendToken, onError: onError);
  }

  ///
  /// Verify code
  ///
  Future verify(String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _newUser.verificationId, smsCode: code);
    try {
      var response = await FirebaseAuth.instance.currentUser
          .linkWithCredential(credential);
      _user = response.user;

      await _user.reload();

      _user = FirebaseAuth.instance.currentUser;
      _newUser = null;
    } catch (error) {
      // print(error.toString());
      notifyListeners();
      return Future.error(error.code);
    }
    notifyListeners();
    return Future.value("done");
  }

  ///
  /// Update user's interests
  ///
  Future updateInterests(List<String> interests) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .update(
        {
          'interests': interests,
        },
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  ///
  /// Get user's data
  ///
  Future loadUserData() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get()
        .then((snap) {
      if (!snap.exists) return;
      _gender = snap.data()['gender'];
      _phone = snap.data()['phone'] != null ? snap.data()['phone'] : '';
      _phoneCode = snap.data()['country_code'] != null
          ? snap.data()['country_code']
          : '968';
      _countryCode = snap.data()['country_code_iso'] != null
          ? snap.data()['country_code_iso']
          : 'OM';
      print(snap.data()['subscription']);
      querySubscriptionStatus();
      if (snap.data().containsKey('subscription')) {
        _subscription =
            UserSubscription.fromSnapshot(snap.data()['subscription']);
        // TODO: tmp until edit cloud functions, remove next line only
        if (_subscription.balance == 0) _subscription.active = false;
      }
      snap
          .data()['interests']
          .forEach((item) => _interests.add(item.toString()));
      _info = snap.data()['info'];
    });
  }

  ///
  /// Update eamil
  ///
  Future updateEmail(String newEmail) {
    return _user.updateEmail(newEmail).then(
          (value) => _user.reload().then(
            (value) {
              _user = FirebaseAuth.instance.currentUser;
              notifyListeners();
            },
          ),
        );
  }

  ///
  /// Update profile
  ///
  Future updateProfile(String name, String info, String phone, String code,
      String countryCode) async {
    _phone = phone;
    _phoneCode = code;
    _countryCode = countryCode;
    await FirebaseFirestore.instance.collection('users').doc(_user.uid).update({
      'info': info,
      'phone': phone,
      'country_code': code,
      'country_code_iso': countryCode,
    });

    return _user
        .updateDisplayName(name)
        .then((value) => _user.reload())
        .then((value) {
      _userName = name;
      _info = info;
      notifyListeners();
    });
  }

  ///
  /// Update password
  ///
  Future<String> updatePassword(String oldPassword, String newPassword) async {
    bool isOldPasswordCorrect = await verifyPassword(oldPassword);
    if (!isOldPasswordCorrect) return 'invalid';
    try {
      await _user.updatePassword(newPassword);
      return null;
    } catch (error) {
      return 'failed';
    }
  }

  ///
  /// Verify password to update
  ///
  Future<bool> verifyPassword(String password) async {
    String email = _user.email;

    try {
      var result = await _user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
      if (result.user == null) return false;
    } catch (error) {
      return false;
    }

    return true;
  }

  String get userName {
    return _userName;
  }

  String get firstRegistration {
    return _firstRegistration;
  }

  String get profilePhoto {
    return _profilePhoto;
  }

  int get gender {
    return _gender;
  }

  User get user {
    return _user;
  }

  bool get isLoggedIn {
    return _isLoggedIn;
  }

  String get info {
    return _info;
  }

  UserSubscription get subscription {
    return _subscription;
  }

  List<String> get interests {
    return _interests;
  }

  set userName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  set firstRegistration(String firstRegistration) {
    _firstRegistration = firstRegistration;
    notifyListeners();
  }

  void setProfilePhoto(String profilePhoto) async {
    _profilePhoto = await FirebaseStorage.instance
        .ref('profiles/' + profilePhoto)
        .getDownloadURL();
    notifyListeners();
  }

  set gender(int gender) {
    _gender = gender;
    notifyListeners();
  }

  set user(User user) {
    _isLoggedIn = true;
    _user = user;
    notifyListeners();
  }

  set isLoggedIn(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  set subscription(UserSubscription subscription) {
    _subscription = subscription;
    notifyListeners();
  }

  // bool isPurchased({BookModel book, CourseModel course}) {
  //   if (book != null)
  //     return hasSubscription || book.purchasedBy.contains(_user.uid);
  //   if (course != null)
  //     return hasSubscription || course.purchasedBy.contains(_user.uid);
  //   return false;
  // }

  get hasSubscription => _subscription.active;

  void notify() {
    notifyListeners();
  }
}
