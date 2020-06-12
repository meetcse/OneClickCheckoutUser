// import 'dart:html';

import 'package:flutter/material.dart';
import 'HomePage.dart';
// import 'SignupandSignin/HomePage.dart';
import 'SignupandSignin/SigninPage.dart';
import 'SignupandSignin/SignupPage.dart';
import 'Screens/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.purple,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
        ),
        // bottomAppBarColor: Colors.deepPurple,
      ),
      home: HomePage(),
      title: 'One Click Checkout',
      routes: <String, WidgetBuilder>{
        "/SigninPage": (BuildContext context) => SigninPage(),
        "/SignupPage": (BuildContext context) => SignupPage(),
        "/HomePage": (BuildContext context) => HomePage(),
      },
    );
  }
}
