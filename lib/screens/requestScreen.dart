import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("도움 요청 페이지"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("도움 요청기능이 들어갈 자리입니다.")
          ],
        ),
      ),

    );
  }
}