import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_onsaemiro_0/route.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key:key);

  @override
  _CategoryRead createState() => _CategoryRead();
}

class _CategoryRead extends State<CategoryScreen>{

  bool check = false;

  @override //빌드와 함께 카테고리 정보를 불러오기 위함.
  void initState(){
    super.initState();
    _Category(context);
  }

  var decodedCategoryList = [];

  Future<void> _Category(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 세팅

    final accessToken = prefs.getString('AccessTk'); //토큰 조회
    var url = Uri.parse(Routes.getCategory);
    var response = await http.get(url,
        headers: {'Content-Type' : 'application/json',
        'Authorization': 'Bearer ${accessToken}'},
    );

    print('Response status: ${response.statusCode}'); // 요청에 대한 응답상태를 불러오기 위함
    print('Response body: ${response.body}'); // 받아온 요청 값

    if (response.statusCode == 403){
      print('Category Read error');
    }else if (response.statusCode == 200){

     var encodedCategoryList = response.body; // String 형식( SharedPreferences가 리스트<dynamic> 타입을 받지 못해서 )
     decodedCategoryList = jsonDecode(response.body)["categoryList"]; // List<dynamic> 형식 => 실제 사용을 위함.

     prefs.setString('categoryList', encodedCategoryList); //내부 저장소에 저장( json형태로 저장 )
     // final categoryList = prefs.getString('categoryList'); // 내부 저장소에서 조회( 사용시 decode 필수 )

      print('saved categoryList: $decodedCategoryList');

      setState(() {
        check = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    if(check){
      return Scaffold(
          body: GridView.builder(
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
                          _Category(context);
                        },
                        child: SizedBox(
                            width: 300,
                            height: 100,
                            child: Text(decodedCategoryList[index]["name"].toString())
                        )
                    )
                );
              },
          )
      );
    }else{
      return Container();
    }

  }
}

