import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/survey');
            break;
          case 1:
            Navigator.pushNamed(context, '/request');
            break;
          case 2:
            Navigator.pushNamed(context, '/community');
            break;
          default:
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: '설문'),
        BottomNavigationBarItem(icon: Icon(Icons.announcement), label: '도움 요청'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: '커뮤니티')
      ],
    );
  }
}