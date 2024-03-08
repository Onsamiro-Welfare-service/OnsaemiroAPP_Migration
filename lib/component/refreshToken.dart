import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../route.dart';

Future<void> RefreshToken(BuildContext context, Future future) async {
  print("token refresh start===");
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString("refreshToken"); // 유저 refresh Token

  var url = Uri.parse(Routes.refresh);
  var body = json.encode({'refreshToken': refreshToken});

  var response = await http.post(url,
      headers: {'Content-Type' : 'application/json'},
      body: body
  );

  if (response.statusCode == 200){
    print("token refresh success");
    Map<String, dynamic> tempTk = jsonDecode(response.body);
    print(tempTk);
    prefs.setString("accessToken", tempTk['accessToken']);
    prefs.setString("refreshToken", tempTk['refreshToken']);
    return future;
  }
  else{
    print(response.statusCode);
    prefs.clear();
    Navigator.of(context).pushReplacementNamed("/login");
  }
}