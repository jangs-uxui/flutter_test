import 'package:flutter/material.dart';

class UserInfo {
  final String username;
  final String password;

  // 생성자 (축약형)
  UserInfo({required this.username, required this.password});

  factory UserInfo.fromJson(Map<String, dynamic> json) { // factory : 클래스 인스턴스(객체)를 리턴
    return UserInfo(
        username: json['username'],
        password: json['password']
    );
  }

  Map<String, dynamic> toJson() {
    return { // Map형식
      "username": this.username,
      "password": this.password
    };
  }

}