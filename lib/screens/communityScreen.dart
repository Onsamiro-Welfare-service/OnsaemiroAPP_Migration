import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("커뮤니티 페이지"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("커뮤니티 기능이 들어갈 자리입니다.")
          ],
        ),
      ),

    );
  }
}