import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_onsaemiro_0/route.dart';
import '../component/refreshToken.dart';

class SurveySplashScreen extends StatefulWidget {
  const SurveySplashScreen({Key? key}) : super(key:key);

  @override
  _SurveyRead createState() => _SurveyRead();
}

class _SurveyRead extends State<SurveySplashScreen>{

  bool check = false; // 답변을 완료했을 경우에는 답변 완료 페이지 띄우기
  var decodedCategoryList = [];
  @override //빌드와 함께 카테고리 정보를 불러오기 위함.
  void initState(){
    super.initState();
    _GetQuestions(context);
  }

  Future<void> _GetQuestions(context) async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');
    final lvl = prefs.getInt('level');
    final userId = prefs.getInt('userId');

    var url = Uri.parse(Routes.getSurvey+'/$userId');
    var response = await http.get(url,
        headers:{'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'}
    );

    if(response.statusCode == 200){
      var decoded = jsonDecode(utf8.decode(response.bodyBytes));
      var surveyData = utf8.decode(response.bodyBytes);
      var surveyNum = decoded["length"]; // 질문 갯수
      var userAnswer = List<String>.filled(surveyNum, ""); // 사용자 답변을 담을 리스트 선언

      print(surveyData);
      await prefs.setString("surveyData", surveyData); // 질문 전체 데이터 저장
      await prefs.setStringList("userAnswer", userAnswer); // 사용자 답변 저장
      await prefs.setInt("surveyNum", surveyNum-1); //질문의 총 갯수-1
      await prefs.setInt("surveyCount", 0); // 현재 질문 순서 저장

      if(lvl == 1){
        Navigator.of(context).pushNamed("/surveyWithAAC");
      }else if(lvl == 2){
        Navigator.of(context).pushNamed("/survey");
      }

    }else if (response.statusCode == 401) {
      RefreshToken(context, _GetQuestions(context));
    }
    else{
      print(response.statusCode);
    }

  }

  @override
  Widget build(BuildContext context) {
    if(check){
      return Scaffold(
          body: Container(
            color: Color(0xffe4f5f7),
            child: GridView.builder(
              itemCount: decodedCategoryList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index){
                return  Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {
                          _GetQuestions(decodedCategoryList[index]["id"]);
                        },
                        child: Column(
                            children: <Widget>[
                              Expanded(
                                  flex:3,
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Image.network(
                                        decodedCategoryList[index]["imageUrl"]+"0",
                                        fit: BoxFit.cover,)
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      decodedCategoryList[index]["name"].toString(),
                                      style: TextStyle(fontSize: 31))
                              )
                            ]
                        )
                    )
                );
              },
            ),
          )
      );
    }else{
      return Container();
    }

  }
}