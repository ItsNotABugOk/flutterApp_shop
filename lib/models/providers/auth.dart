import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryTokenTime;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryTokenTime != null &&
        _expiryTokenTime!.isAfter(DateTime.now()) &&
        _token!.isNotEmpty) {
      return _token;
    }
    return null;
  }

  String? get userId {
    if (_userId != null) {
      return _userId!;
    }
    return null;
  }

  Future<void> _authentication(
      String email, String password, String urlSegment) async {
    final Uri _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyARrJQiuyJaWAm1zrvgvIk04nOhutJV3pQ');
    try {
      final response = await http.post(
        _url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final _reponseData = json.decode(response.body);
      if (_reponseData['error'] != null) {
        throw HttpException(_reponseData['error']['message']);
      }
      _token = _reponseData['idToken'];
      _userId = _reponseData['localId'];
      _expiryTokenTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            _reponseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
      autoLogout();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryTokenTime': _expiryTokenTime!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryTokenTime = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryTokenTime!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final prefresData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(prefresData['expiryTokenTime']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = prefresData['token'];

    _userId = prefresData['userId'];

    _expiryTokenTime = expiryDate;

    notifyListeners();
    autoLogout();

    return true;
  }
}
