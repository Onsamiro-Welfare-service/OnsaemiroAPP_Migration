import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_onsaemiro_0/route.dart';
import '../component/refreshToken.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key:key);

  @override
  _CategoryRead createState() => _CategoryRead();
}

class _CategoryRead extends State<CategoryScreen>{

  bool check = false;
  var decodedCategoryList = [];
  @override //빌드와 함께 카테고리 정보를 불러오기 위함.
  void initState(){
    super.initState();
    _Category(context);
  }
  Future<void> _Category(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 세팅

    final accessToken = prefs.getString('accessToken'); //토큰 조회
    var url = Uri.parse(Routes.getCategory);
    var response = await http.get(url,
        headers: {'Content-Type' : 'application/json',
        'Authorization': 'Bearer ${accessToken}'},
    );

    print('Response status(Category): ${response.statusCode}'); // 요청에 대한 응답상태를 불러오기 위함
    print('Response body: ${response.body}'); // 받아온 요청 값

    if (response.statusCode == 403){
      print('Category Read error');
    }else if (response.statusCode == 401) {
      print("Category token refresh");
      RefreshToken(context, _Category(context));
    }else if (response.statusCode == 200) {
      var encodedCategoryList = response
          .body; // String 형식( SharedPreferences가 리스트<dynamic> 타입을 받지 못해서 )
      decodedCategoryList = jsonDecode(utf8.decode(response
          .bodyBytes))["categoryList"]; // List<dynamic> 형식 => 실제 사용을 위함.

      prefs.setString(
          'categoryList', encodedCategoryList); //내부 저장소에 저장( json형태로 저장 )
      // final categoryList = prefs.getString('categoryList'); // 내부 저장소에서 조회( 사용시 decode 필수 )

      print('saved categoryList: $decodedCategoryList');

      setState(() {
        check = true;
      });
    }

  }

  Future<void> _GetQuestions(id) async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');
    final lvl = prefs.getInt('level');

    var url = Uri.parse(Routes.getsurvey+'/$id/level/$lvl');
    var response = await http.get(url,
        headers:{'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'}
    );

    if(response.statusCode == 200){
      var decoded = jsonDecode(utf8.decode(response.bodyBytes));
      var surveyData = utf8.decode(response.bodyBytes);
      var surveyNum = decoded["length"]; // 질문 갯수
      var userAnswer = List<String>.filled(surveyNum, ""); // 사용자 답변을 담을 리스트 선언

      await prefs.setString("surveyData", surveyData); // 질문 전체 데이터 저장
      await prefs.setStringList("userAnswer", userAnswer); // 사용자 답변 저장
      await prefs.setInt("surveyNum", surveyNum-1); //질문의 총 갯수-1
      await prefs.setInt("surveyCount", 0); // 현재 질문 순서 저장

      Navigator.of(context).pushNamed("/survey");
    }else if (response.statusCode == 401) {
      RefreshToken(context, _GetQuestions(id));
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

