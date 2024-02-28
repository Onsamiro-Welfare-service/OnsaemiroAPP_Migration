import 'package:flutter/material.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("설문 페이지"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("설문지가 들어갈 자리입니다.")
          ],
        ),
      ),

    );
  }
}
