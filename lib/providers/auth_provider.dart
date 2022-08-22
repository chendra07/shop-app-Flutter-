import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

//utils
import '../utils/services_auth.dart';

// ignore: camel_case_types
class Auth_provider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String get userId {
    if (_userId != null) {
      return _userId;
    }

    return null;
  }

  Future<void> signUp(String email, String password) {
    return ServicesAuth().postSignUp(body: {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }).then((resp) {
      //response:
      // {
      //   'headers': resp?.headers,
      //   'idToken': decodedData['idToken'],
      //   'refreshToken': decodedData['refreshToken'],
      //   'expiresIn': decodedData['expiresIn'],
      //   'localId': decodedData['localId'],
      //   'email': decodedData['email'],
      //   'statusCode': resp?.statusCode,
      // }

      _token = resp['idToken'];
      _userId = resp['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(resp['expiresIn'] as String),
        ),
      );
      notifyListeners();
    }).catchError((error) => throw error);
  }

  Future<void> signIn(String email, String password) async {
    final persistsData = await SharedPreferences.getInstance();
    return await ServicesAuth().postSignIn(body: {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }).then((resp) {
      // response:
      // {
      //   'headers': resp?.headers,
      //   'idToken': decodedData['idToken'],
      //   'refreshToken': decodedData['refreshToken'],
      //   'expiresIn': decodedData['expiresIn'],
      //   'displayName': decodedData['displayName'],
      //   'email': decodedData['email'],
      //   'localId': decodedData['localId'],
      //   'registered': decodedData['registered'],
      //   'statusCode': resp?.statusCode,
      // }

      _token = resp['idToken'];
      _userId = resp['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(resp['expiresIn'] as String),
        ),
      );
      _autoLogout();
      notifyListeners();
      final userData = jsonEncode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      });
      persistsData.setString('userData', userData);
    }).catchError((error) => throw error);
  }

  Future<bool> tryAutoLogin() async {
    final persistData = await SharedPreferences.getInstance();
    if (!persistData.containsKey("userData")) {
      return false;
    }

    final extractedUserData =
        json.decode(persistData.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    _authTimer?.cancel();
    notifyListeners();
    final persistData = await SharedPreferences.getInstance();
    persistData.remove('userData');
    // persistData.clear(); //caution: remove all data
  }

  void _autoLogout() {
    _authTimer?.cancel();
    final int timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () => logout());
  }

  void disposeAuthTimer() {
    _authTimer?.cancel();
  }
}
