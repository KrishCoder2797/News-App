// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pnews/controller/session_login.dart';
import 'Information.dart';
import 'home.dart';
import 'singUpPage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State createState() => _LoginState();
}

class _LoginState extends State {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObsequre = true;
  bool _isUsernameValid = true;
  bool _isPasswordValid = true;

  Future<bool> loginInfoIsCorrect() async {
    //String ipAdress = await IpAddress()._getIpAddress();

    setState(() {
      _validateUsername(usernameController.text);
      _validatePassword(passwordController.text);
    });
    if (_isUsernameValid && _isPasswordValid) {
      log("here here");
      String url = 'http://Prasad25.pythonanywhere.com//login';
      Map<String, String> headers = {'Content-Type': 'application/json'};
      Map<String, String> body = {
        'username': usernameController.text,
        'password': passwordController.text,
        'ipAdress': "ipAdress",
      };

      try {
        final response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          await SessionLogin().saveUserCredentials(
              "${usernameController.text}${passwordController.text}");
          // await UserInfo.getObject().insertCurrentUser(
          //     usernameController.text, passwordController.text);
          Information.getDataObject().setInfo(
              username: usernameController.text,
              password: passwordController.text);
          log('Login successful');

          setState(() {});
          return true;
          // Navigate to next screen or perform necessary actions
        } else {
          log("here");
          log('Login failed: ${response.reasonPhrase}');
          showErrorSnakBar(errorMassege: "User name or password is wrong");
          setState(() {});

          return false;
        }
      } catch (error) {
        log('Error: $error');
        showErrorSnakBar(errorMassege: "Newtwork connection error!!!");
      }
    }
    return false;
  }

  Future<void> login() async {
    log("prasad zadokar");
    if (await loginInfoIsCorrect()) {
   
      Information.getDataObject().setInfo(
          username: usernameController.text, password: passwordController.text);

      // ignore: duplicate_ignore
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            (routs) => false;
            return const Home();
          },
        ),
      );
    }
  }

  void showErrorSnakBar({required String errorMassege}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      animation: kAlwaysCompleteAnimation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width - 48,
            child: Text(
              errorMassege,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.5,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 255, 133, 124),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 60.0,
                ),
                Image.asset(
                  "assets/images/login0.png",
                  height: 130,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SF UI Text",
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 75,
                        child: TextFormField(
                          onChanged: _validateUsername,
                          //       validator: (value) {
                          //         if (value == null || value.isEmpty) {
                          //           return 'Please enter username ';
                          //         } /*else if (!EmailValidator.validate(value)) {
                          //   return 'Please enter proper mail';
                          // }*/
                          //         return null;
                          //       },
                          controller: usernameController,
                          decoration: InputDecoration(
                            errorText: _isUsernameValid
                                ? null
                                : 'Please enter your username',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 10.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 42, 42, 42),
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Colors.black12, width: 0.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 47, 47),
                                  width: 0.7),
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              //color: Colors.orange,
                            ),
                            labelText: 'Username',
                            labelStyle: const TextStyle(
                              fontSize: 17,
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                            ),
                            fillColor: const Color.fromARGB(255, 231, 233, 238),
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      SizedBox(
                        child: TextFormField(
                          onChanged: _validatePassword,
                          //       validator: (value) {
                          //         if (value == null || value.isEmpty) {
                          //           return 'Please enter password ';
                          //         } /*else if (!EmailValidator.validate(value)) {
                          //   return 'Please enter proper mail';
                          // }*/
                          //   return null;
                          // },
                          controller: passwordController,
                          obscureText: isObsequre,
                          decoration: InputDecoration(
                            errorText: _isPasswordValid
                                ? null
                                : 'Please enter your password',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 18, 18, 18),
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 80, 78, 78),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.red.shade800,
                                width: 0.5,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                isObsequre = !isObsequre;
                                setState(() {});
                              },
                              child: (isObsequre)
                                  ? const Icon(
                                      Icons.visibility,
                                      color: Color.fromARGB(255, 111, 111, 111),
                                    )
                                  : const Icon(
                                      Icons.visibility_off,
                                      color: Color.fromARGB(255, 111, 111, 111),
                                    ),
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontSize: 17,
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                            ),
                            fillColor: const Color.fromARGB(255, 231, 233, 238),
                            filled: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: const ButtonStyle(),
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          letterSpacing: (0.5),
                          color: Color.fromARGB(221, 27, 27, 27),
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: 300,
                  height: 43,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 14,
                        offset: const Offset(2, 8),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 31, 175, 253),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff000000),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: createNewAccount,
                      style: const ButtonStyle(),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 31, 175, 253),
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateUsername(String value) {
    setState(() {
      _isUsernameValid = value.isNotEmpty;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.isNotEmpty;
    });
  }

  void createNewAccount() {
    usernameController.clear();
    passwordController.clear();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: const NewAccount(),
          );
        },
      ),
    );
  }
}

class IpAddress {
  String _ipAddress = 'Unknown';

  Future<String> _getIpAddress() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // Get the IP address of the mobile network
      var ipAddress = await _getMobileIpAddress();

      _ipAddress = ipAddress ?? 'Unknown';
      return _ipAddress;
    } else {
      _ipAddress = 'Not connected to a mobile network';
      return "emulator";
    }
  }

  Future<String?> _getMobileIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.address.isNotEmpty && !addr.address.startsWith('127.')) {
          return addr.address;
        }
      }
    }
    return null;
  }
}
