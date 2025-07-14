import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken = null;
  String? _refreshToken = null;

  // 읽기접근자 getter
  String get accessToken => _accessToken!;
  String get refreshToken => _refreshToken!;

  // 쓰기접근자 setter
  set accessToken(String value) {
    _accessToken = value;
  }
  set refreshToken(String value) {
    _refreshToken = value;
  }
}