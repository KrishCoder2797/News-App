import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pnews/view/home.dart';

import 'database_connection.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;

  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 1400), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          // return FutureBuilder(
          //     future: isUserLoggedIn(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const SizedBox();
          //       } else {
          //         bool userLoggedIn = snapshot.data ?? false;
          //         if (userLoggedIn) {
          //           return const Home();
          //         } else {
          //           return const Login();
          //         }
          //       }
          //     });
          return widget.isLoggedIn ? const Home() : const Home();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/icon/icon2.png",
              height: 130,
            ),
            const Text(
              "PNews",
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
                fontSize: 45,
                color: Color.fromARGB(255, 31, 175, 253),
              ),
            ),
            const Text(
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
