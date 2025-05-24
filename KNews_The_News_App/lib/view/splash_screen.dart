import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pnews/view/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1400), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return const Home();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "PNews",
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
                fontSize: 45,
                color: Color.fromARGB(255, 31, 175, 253),
              ),
            ),
            Text(
              "Business & Startup News",
              style: TextStyle(
                letterSpacing: 2.5,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            // const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
