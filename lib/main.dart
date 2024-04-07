import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_onsaemiro_0/screens/loginScreen.dart';
import 'package:test_onsaemiro_0/screens/mainScreen.dart';
import 'package:test_onsaemiro_0/screens/categoryScreen.dart';
import 'package:test_onsaemiro_0/screens/splachScreen.dart';
import 'package:test_onsaemiro_0/screens/surveySplashScreen.dart';
import 'package:test_onsaemiro_0/screens/surveyScreen.dart';
import 'package:test_onsaemiro_0/screens/requestScreen.dart';
import 'package:test_onsaemiro_0/screens/communityScreen.dart';

void main() => runApp(
    MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => SplashScreen(),
          'splash': (_) => SplashScreen(),
          '/main': (_) => MainScreen(),
          '/login': (_) => LoginPage(),
          '/category': (_) => CategoryScreen(),
          '/surveySplash': (_) => SurveySplashScreen(),
          '/survey': (_) => SurveyScreen(),
          '/request': (_) => RequestScreen(),
          '/community': (_) => CommunityScreen(),
        }
    )
);

