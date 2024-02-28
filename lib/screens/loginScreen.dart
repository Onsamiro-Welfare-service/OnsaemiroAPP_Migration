
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

      prefs.setInt('Id', tempTk['data']['id']);
      prefs.setInt('Lvl', tempTk['data']['level']);
      prefs.setString('AccessTk', tempTk['data']['accessToken']);
      prefs.setString('RefreshTk', tempTk['data']['refreshToken']);

      final i = prefs.getInt('Id');
      final l = prefs.getInt('Lvl');
      final a = prefs.getString('AccessTk');
      final b = prefs.getString('RefreshTk');

      print('saved ID: $i');
      print('saved LVL: $l');
      print('saved AT: $a');
      print('saved RT: $b');

      Navigator.pushNamed(context, '/main');

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
    );
  }
}
