// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryTokenTime;
  String? _userId;

  bool get isAuth {
    print('I am In auth');
    return token != null;
  }

  String? get token {
    if (_expiryTokenTime != null &&
        _expiryTokenTime!.isAfter(DateTime.now()) &&
        _token!.isNotEmpty) {
      print('I am In Token & $_token');

      return _token;
    }
    return null;
  }

  String? get userId {
    if (_userId != null) {
      print('I am In UserId  $_userId');
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
}
