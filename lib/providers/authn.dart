import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authn with ChangeNotifier {
  String? _idToken, userId;
  DateTime? _expireDate;

  String? _tempidToken, tempuserId;
  DateTime? _tempexpireDate;

  void tempData() {
    _idToken = _tempidToken;
    userId = tempuserId;
    _expireDate = _tempexpireDate;
    notifyListeners();
  }
//coba wkwk

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
      notifyListeners();
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
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void logOut() {
    _idToken = null;
    userId = null;
    _expireDate = null;
    notifyListeners();
  }
}
