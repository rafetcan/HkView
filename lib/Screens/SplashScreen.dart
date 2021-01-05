import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hkview/Screens/Home.dart';
import 'package:hkview/data.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    Timer(Duration(seconds: splashTimer), buildSplashScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/splash.png'),
          )),
        ),
      ),
    );
  }

  buildSplashScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WebViewExample()));
  }
}
