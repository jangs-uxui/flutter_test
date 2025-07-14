import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/app_colors.dart';
import 'package:flutter_project/auth_provider.dart';
import 'package:flutter_project/first_page.dart';
import 'package:flutter_project/join_page.dart';
import 'package:flutter_project/settings_page.dart';
import 'package:flutter_project/userinfo.dart';
import 'package:flutter_project/userlist_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      initialRoute: '/',
      routes: {
        "/": (context) => MyHomePage(),
        "/join": (context) => JoinPage(),
        "/first_page": (context) => FirstPage(),
        "/userlist": (context) => UserlistPage(),
        "/settings": (context) => SettingsPage(),
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          )
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: AppColors.textColor,
            fontSize: 18,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textColor,
          ),
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  // 로그인 요청
  Future<bool> loginRequest() async {
    AuthProvider provider = context.read<AuthProvider>(); // provider에서 정보 읽기(리렌더링X)

    final url = Uri.parse("http://10.0.2.2:8080/login");
    UserInfo user = UserInfo(username: username!, password: password!);
    final body = user.toJson();

    try {
      final response = await http.post(url, body: body) // header 생략
          .timeout(const Duration(seconds: 3)); // HTTP 요청 타임아웃
      if (response.statusCode == 200) { // 로그인 성공
        final token = response.headers['authorization']; // accessToken
        final refresh = response.headers['set-cookie']; // refreshToken
        provider.accessToken = token!; // provider에 저장 (쓰기접근자 호출)
        provider.refreshToken = refresh!;
        showSnackBar(context, "로그인 성공!");
        return true;
      } else if (response.statusCode == 401) { // 로그인 실패
        final message = jsonDecode(utf8.decode(response.bodyBytes)); // map으로 가져옴
        showSnackBar(context, message['error']);
      } else {
        showSnackBar(context, "Error: ${response.statusCode}");
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
      backgroundColor: AppColors.backgroundColor,
      body: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
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
                                      loginRequest().then((data) {
                                        if (data) { // true: 로그인 성공
                                          Navigator.pushNamed(context, '/first_page'); // arguments 데이터전달
                                        }
                                      });
                                    } else {
                                      showSnackBar(context, "올바른 계정정보를 입력하세요.");
                                    }
                                  },
                                  child: Text("로그인",
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
                                SizedBox(height: 8),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/join");
                                    },
                                    child: Text("회원가입",
                                      style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 15
                                      ),
                                    )
                                )
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
      ),
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