import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../route.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  _Survey createState() => _Survey();
}

class _Survey extends State<SurveyScreen> { // 질문 정보를 가져와서 출력해주는 클래스

  bool check = false;

  @override //빌드와 함께 카테고리 정보를 불러오기 위함.
  void initState(){
    super.initState();
    _getSurvey(context);
  }

  var surveyData = {};
  var answerData = [];
  int count = 0;

  Future<void> _getSurvey(BuildContext context) async{

    final prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 세팅

    final surveyEncoded = prefs.getString('surveyData');
    final surveyCount = prefs.getInt('surveyCount');
    final userAnswer = prefs.getStringList('userAnswer');
    count = surveyCount!; // 현재 질문의 카운트

    if (surveyEncoded != null && userAnswer != null){
      var surveyDecoded = jsonDecode(surveyEncoded);
      surveyData = surveyDecoded["surveyList"][surveyCount]; // 질문에 대한 데이터 추출
      answerData = surveyDecoded["surveyList"][surveyCount]["answerList"]; // 선택지 데이터 추출

      setState(() { // 질문 추출 후 렌더링을 위함.
        check = true;
      });
    }
    else if(surveyEncoded == null){
      print("survayWhole is null: $surveyEncoded");
      //후에 오류처리 해줄것
      //알림 띄우고 메인으로 내보내기
    }
    else{
      print("userAnswer is null: $userAnswer");
      //후에 오류처리 해줄것
      //알림 띄우고 메인으로 내보내기
    }
  }

  Future<void> _NextQuestion(AnsId) async{ // 다음 페이지로 넘어가는 함수
    final prefs = await SharedPreferences.getInstance();

    var userId = prefs.getInt("userId"); // 유저 id
    var categoryId = surveyData["categoryId"]; // 현재 카테고리의 id
    var answerId = AnsId; // 현재 선택한 id
    var questionId = surveyData["id"]; // 현재 질문의 id

    var fullCount = prefs.getInt("surveyNum"); // 모든 질문의 수 -1
    var userAnswer = prefs.getStringList("userAnswer");

    if (userId != null && categoryId != null && answerId != null && questionId != null){
      if(fullCount != null && count < fullCount){
        var temp = [{
          "surveyId": questionId,
          "categoryId": categoryId,
          "answerId":answerId,
          "userId": userId
        }];

        var answer = jsonEncode(temp);
        userAnswer?[count] = answer;
        print("--surveyScreen._NextQuestioin userAnswer: $userAnswer--");
        await prefs.setStringList("userAnswer", userAnswer!);
        await prefs.setInt("surveyCount",count+1);

        Navigator.of(context).pushNamed("/survey");
      }
      else if(fullCount != null && count == fullCount){
        var temp = [{ //질문 저장을 위한 템플릿
          "surveyId": questionId,
          "categoryId": categoryId,
          "answerId":answerId,
          "userId": userId
        }];

        var answer = jsonEncode(temp); // json 형태로 인코딩
        userAnswer?[count] = answer; //현재 질문 순서에 해당하는 칸에 답변 저장
        print("--surveyScreen _NextQuestioin userAnswer: $userAnswer--");
        // await prefs.setStringList("userAnswer", userAnswer!); 마지막 페이지라 저장하지 않음
        await prefs.setInt("surveyCount",0);
        for(int i=0; i <= count; i++){
          _submit(userAnswer?[i]);
        }
        Navigator.of(context).pushNamedAndRemoveUntil("/main", ModalRoute.withName("/survey"));
      }
      else{
      }
    }
    else if(userId == null){
      print("surveyScreen _NextQuestion userId is null: $userId");
    }
    else if(categoryId == null){
      print("surveyScreen _NextQuestion categoryId is null: $categoryId");
    }
    else if(answerId == null){
      print("surveyScreen _NextQuestion answerId is null: $answerId");
    }
    else if(questionId == null){
      print("surveyScreen _NextQuestion questionId is null: $questionId");
    }
    else{
      print("surveyScreen _NextQuestion error Occured");
    }
  }

  Future<void> _submit(answer) async {
    final prefs = await SharedPreferences.getInstance();
    var AccessTk = prefs.getString("accessToken");

    print(answer);

    var url = Uri.parse(Routes.sendAnswer);
    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $AccessTk',
          'Content-Type': 'application/json'
        },
        body: answer
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print("uploaded Success");
    }
    else {
      print("error occured - code: ${response.statusCode}");
      print(response.body);
    }
  }

    @override
    Widget build(BuildContext context) {
      if (check) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Expanded( //질문 카드
                  flex: 1,
                  child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            //질문 tts
                          },
                          child: Column(
                              children: <Widget>[
                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Image.network(
                                          surveyData["imageUrl"],
                                          fit: BoxFit.cover,)
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                        surveyData["question"].toString(),
                                        style: TextStyle(fontSize: 31))
                                )
                              ]
                          )
                      )
                  )
              ),
              Expanded( // 선택지 카드(GridView 형태로 나열)
                  flex: 1,
                  child: GridView.builder(
                      itemCount: answerData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (Context, index) {
                        return Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  _NextQuestion(answerData[index]["id"]);
                                },
                                child: Column(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Image.network(
                                                answerData[index]["imageUrl"],
                                                //해당 질문지의 선택지
                                                fit: BoxFit.cover,)
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                              answerData[index]["description"]
                                                  .toString(),
                                              style: TextStyle(fontSize: 31))
                                      )
                                    ]
                                )
                            )
                        );
                      }
                  )
              )
            ],
          ),
        );
      }
      else {
        return Container();
      }
    }

}