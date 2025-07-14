import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/auth_provider.dart';
import 'package:flutter_project/userinfo.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'app_colors.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? username = null;
  String? password = null;

  bool tryValidation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  // 회원가입 요청
  Future<bool> joinRequest() async {
    // AuthProvider provider = context.read<AuthProvider>();

    final url = Uri.parse("http://10.0.2.2:8080/join");
    UserInfo user = UserInfo(username: username!, password: password!);
    final body = user.toJson();

    try {
      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
      ).timeout(const Duration(seconds: 3));
      if (response.statusCode == 201) { // 회원가입 성공
        showSnackBar(context, "회원가입 성공");
        return true;
      } else if (response.statusCode == 409) { // 아이디 중복
        showSnackBar(context, "이미 존재하는 아이디 입니다.");
      } else { // 회원가입 실패
        showSnackBar(context, "회원가입 실패: ${response.statusCode}");
      }
    } catch (e) {
      showSnackBar(context, "서버에 연결할 수 없습니다.");
      print("error: ${e}");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: ValueKey(1),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "input username.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    username = value!;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: AppColors.subTextColor,
                    ),
                    hintText: "Username",
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  key: ValueKey(2),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "input password.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColors.subTextColor,
                    ),
                    hintText: "Password",
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (tryValidation()) {
                      joinRequest().then((data) {
                        if (data) { // true: 로그인 성공
                          Navigator.pushNamed(context, '/');
                        }
                      });
                    } else {
                      showSnackBar(context, "올바른 계정정보를 입력하세요.");
                    }
                  },
                  child: Text("회원가입",
                    style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 1.2,
                        color: AppColors.textColor
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                      padding: EdgeInsets.fromLTRB(30, 12, 30, 12)
                  ),
                ),
              ],
            )
        ),
      )
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17,
              color: Color(0xffffffff)
          ),
        ),
        backgroundColor: AppColors.errorColor,
        duration: Duration(seconds: 2),
      )
  );
}