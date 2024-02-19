import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authn with ChangeNotifier {
  Timer? _autoTimer;
  String? _idToken, userId;
  DateTime? _expireDate;

  String? _tempidToken, tempuserId;
  DateTime? _tempexpireDate;

  Future<void> tempData() async {
    _idToken = _tempidToken;
    userId = tempuserId;
    _expireDate = _tempexpireDate;

    final sharedPref = await SharedPreferences.getInstance();
    final myMapPref = json.encode({
      'token': _idToken,
      'uId': userId,
      'expired': _expireDate!.toIso8601String()
    });
    sharedPref.setString('authData', myMapPref);
    _autoLogout();
    notifyListeners();
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_idToken != null &&
        _expireDate != null &&
        _expireDate!.isAfter(DateTime.now())) {
      return _idToken;
    } else {
      return null;
    }
  }

  Future<void> signUpUser(String email, String password) async {
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCfYRqy5Sfjpgo8AYddeFOPTV06x5GQHq0');

    try {
      var hasilRes = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      var responStat = json.decode(hasilRes.body);
      if (responStat['error'] != null) {
        throw responStat['error']['message'];
      }

      _tempidToken = responStat['idToken'];
      tempuserId = responStat['localId'];
      _tempexpireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responStat['expiresIn'])));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInUser(String email, String password) async {
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCfYRqy5Sfjpgo8AYddeFOPTV06x5GQHq0');

    try {
      var hasilRes = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      var responStat = json.decode(hasilRes.body);

      if (responStat['error'] != null) {
        throw responStat['error']['message'];
      }
      _tempidToken = responStat['idToken'];
      tempuserId = responStat['localId'];
      _tempexpireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responStat['expiresIn'])));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    _idToken = null;
    userId = null;
    _expireDate = null;
    if (_autoTimer != null) {
      _autoTimer!.cancel();
      _autoTimer = null;
    }
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_autoTimer != null) {
      _autoTimer!.cancel();
    }
    final timeToExpire = _tempexpireDate!.difference(DateTime.now()).inSeconds;
    print(timeToExpire);
    _autoTimer = Timer(Duration(seconds: timeToExpire), () {
      logOut();
    });
  }

  Future<bool> autoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('authData')) {
      return false;
    }
    final String? authData = pref.getString('authData');
    if (authData == null) {
      return false; // Tangani kasus null dengan tepat
    }
    final myData = json.decode(authData) as Map<String, dynamic>;
    final myExpireDate = DateTime.parse(myData['expired']);
    if (myExpireDate.isBefore(DateTime.now())) {
      return false;
    }
    _idToken = myData['token'];
    userId = myData['uId'];
    _expireDate = myExpireDate;

    notifyListeners();
    return true;
  }
}
