import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_onsaemiro_0/route.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String usercode = '';

  Future<void> _login(BuildContext context) async {

    var url = Uri.parse(Routes.login);
    var body = json.encode({'loginCode': usercode});

    var response = await http.post(url,
        headers: {'Content-Type' : 'application/json'},
        body: body
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 403){
      print('login error');
    }else if (response.statusCode == 200){
      Map<String, dynamic> tempTk = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();

      prefs.setInt('userId', tempTk['data']['id']);
      prefs.setInt('level', tempTk['data']['level']);
      prefs.setString('accessToken', tempTk['data']['accessToken']);
      prefs.setString('refreshToken', tempTk['data']['refreshToken']);

      final i = prefs.getInt('userId');
      final l = prefs.getInt('level');
      final a = prefs.getString('accessToken');
      final b = prefs.getString('refreshToken');

      print('saved ID: $i');
      print('saved LVL: $l');
      print('saved AT: $a');
      print('saved RT: $b');

      Navigator.of(context).pushReplacementNamed('/main');

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/logo.png"),
              TextField(
                onChanged: (value) {
                  setState(() {
                    usercode = value;
                  });
                },
                decoration: InputDecoration(labelText: '로그인 코드'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text('로그인'),
              ),
            ],
          ),
        ),
      )
    );
  }
}

