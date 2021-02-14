import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
          seconds: 5,
          navigateAfterSeconds: HomeScreen(),
          title: Text(
            "OCR app",
            style: TextStyle(
              color: Colors.indigo,
              fontSize: 20,
            ),
          ),
          image: Image.asset("assets/ocrsplash.jpg"),
          photoSize: 150,
          backgroundColor: Colors.white,
          loaderColor: Colors.indigo,
          loadingText: Text(
            "Convert Any Image to Text",
            style: TextStyle(
              color: Colors.indigo,
              fontSize: 10,
            ),
          ),
    );
  }
}
