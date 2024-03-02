import 'package:flutter/material.dart';
import 'package:test_onsaemiro_0/screens/categoryScreen.dart';
import 'package:test_onsaemiro_0/screens/surveyScreen.dart';
import 'package:test_onsaemiro_0/screens/requestScreen.dart';
import 'package:test_onsaemiro_0/screens/communityScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "11111",
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold
  );

  final List<Widget> _widgetOptions = <Widget>[
    CategoryScreen(),
    RequestScreen(),
    //CommunityScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_turned_in),
              label: '설문'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.announcement),
              label: '도움 요청'
          ),
          //BottomNavigationBarItem(
              //icon: Icon(Icons.group),
              //label: '커뮤니티'
          //)
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
    ),
    );
  }
}
