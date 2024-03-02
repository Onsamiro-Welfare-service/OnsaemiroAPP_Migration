import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../route.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _SendRequest();
}

class _SendRequest extends State<RequestScreen> { //요청을 보내는 로직

  var textData = "";
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future TakePhoto(ImageSource imageSource) async { //사진을 찍는 함수
    final XFile? photo = await picker.pickImage(source: imageSource);
    if (photo != null) {
      setState(() {
        _image = XFile(photo.path);
      });
    }
  }

  Future<void> _AddRequest(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance(); // 내부 저장소 선언

    final userID = prefs.getInt('userId');
    final AccTkn = prefs.getString('accessToken');

    if(userID != null && AccTkn != null){
      var url = Uri.parse(Routes.sendRequest);
      var data = jsonEncode({"description": textData, "userId": userID.toString()});
      var request = http.MultipartRequest('POST', url)
        ..headers['authorization']='Bearer $AccTkn'
        ..fields['request'] = data;
      if(_image == null) {
          request.files.add(await http.MultipartFile.fromBytes('images', List<int>.empty(), filename: 'empty_file'));
      }else{
        request.files.add(await http.MultipartFile.fromPath('images', _image!.path));
      }

      final response = await request.send();

      print('Response status: ${(await http.Response.fromStream(response)).body}');
      print(request.fields);

      if (response.statusCode == 403){
        print('error occured');
      }else if (response.statusCode == 200){
        print('Uploaded');
      }
    }else{
      print("userId: $userID & AccTkn: $AccTkn");
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              _buildPhotoArea(),
              SizedBox(height: 29),
              _buildButton(),
              _inputText(),
              SizedBox(height: 30), // 추가: 공간을 더 추가하여 오버플로 문제를 해결합니다.
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPhotoArea(){
    return _image != null
        ? Container(
      width: 300,
      height: 300,
      child: Image.file(File(_image!.path)),
    )
        : Container(
      width: 300,
        height: 300,
        color: Colors.grey,
    );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            TakePhoto(ImageSource.camera); // 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Text("카메라"),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            TakePhoto(ImageSource.gallery); // 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("갤러리"),
        ),
      ],
    );
  }

  Widget _inputText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
        onChanged: (value)
    {
      setState(() {
        textData = value;
      });
    }),
      ElevatedButton(
        onPressed: () => _AddRequest(context),
        child: Text('전송'),
      )
      ],
    );
  }

}


