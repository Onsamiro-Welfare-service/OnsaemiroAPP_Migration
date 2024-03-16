import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../route.dart';

class SplashScreen extends StatefulWidget{

  @override
  _splash createState() => _splash();
}

class _splash extends State<SplashScreen>{

  @override
  void initState(){
    _loginCheck();
  }

  //로그인 여부확인 & 토큰 리프레시 진행
  Future<void> _loginCheck() async {
    final prefs = await SharedPreferences.getInstance();

    final refreshToken = prefs.getString('refreshToken'); //

    if (refreshToken != null){ // 한번이라도 로그인을 한 경우
      var url = Uri.parse(Routes.refresh);
      var body = json.encode({'refreshToken': refreshToken});

      var response = await http.post(url,
          headers: {'Content-Type' : 'application/json'},
          body: body
      );
      print('---------${response.statusCode}');
      Map<String, dynamic> tempTk = await jsonDecode(response.body);
      print(tempTk);
      print(tempTk['accessToken']);

      if (response.statusCode == 200){ // 토큰 리프레시 정상 작동
        if(tempTk['accessToken'] != null || tempTk['refreshToken'] != null){
          prefs.setString('accessToken', tempTk['accessToken']);
          prefs.setString('refreshToken', tempTk['refreshToken']);
          Navigator.of(context).pushReplacementNamed('/main');
        }else{
          prefs.clear();
          Navigator.of(context).pushReplacementNamed("/login");
        }

      }else{ // 토큰 리프레시 실패
        print(response.statusCode);
        prefs.clear();
        Navigator.of(context).pushReplacementNamed("/login");
      }
    }else{ // 초기 로그인
      prefs.clear();
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Image.asset("assets/logo.png")
      )
    );
  }
}
