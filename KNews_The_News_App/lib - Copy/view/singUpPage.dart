import "dart:convert";
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import "login_page.dart";

class NewAccount extends StatefulWidget {
  const NewAccount({super.key});

  @override
  State createState() => _NewAccountState();
}

class _NewAccountState extends State {
  bool accountCreated = false;
  int usernameError = 0;
  int passwordError = 0;
  int contactNoError = 0;
  String username = "";
  String password = "";
  String contact = "";
  bool userNamehaveoneletter = false;
  bool passwordhaveoneletter = false;
  bool contacthaveoneletter = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();

  bool isSubmitPressed = false;

  Future<void> singUp() async {
    username = usernameController.text;
    password = passwordController.text;
    contact = contactNoController.text;

    String url = 'http://Prasad25.pythonanywhere.com//singUp';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, String> body = {
      'username': usernameController.text,
      'password': passwordController.text,
      'contact': contactNoController.text,
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        print('added  successful');
        accountCreated = true;
      } else {
        print('already presnt: ${response.reasonPhrase}');
        usernameError = 2;
      }
      setState(() {});
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return (accountCreated == false)
        ? Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 0,
                      ),
                      Stack(alignment: Alignment.center, children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(
                                60.0), // Adjust the value as needed
                            child: Image.asset(
                              'assets/images/login4.png',
                              height: 160, // Adjust height as needed
                              fit: BoxFit.cover, // Adjust the fit as needed
                            )),
                        const Positioned(
                            child: Column(children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            SizedBox(
                              width: 200,
                            ),
                            SizedBox(
                              height: 150,
                              width: 150,
                              // child: Image.asset("assets/images/food3.png"),
                            )
                          ])
                        ]))
                      ]),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Create new account",
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 300,
                          child: TextField(
                            //maxLength: 40,
                            onChanged: (value) {
                              username = usernameController.text;
                              userNamehaveoneletter = true;
                              usernameError = 0;

                              setState(() {});
                            },
                            controller: usernameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              // hintText: "Username",
                              labelText: "Username",
                              labelStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(0, 0, 0, 0.6)),
                              errorText: (usernameController.text.isEmpty &&
                                      isSubmitPressed)
                                  ? "username should not empty"
                                  : (usernameError == 2)
                                      ? "username already exits"
                                      : null,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 22, 20, 20))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade800)),
                              contentPadding: const EdgeInsets.only(left: 25),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 236, 236, 236),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 300,
                          child: TextField(
                            //maxLength: 40,
                            //maxLength: 40,

                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.key),

                              labelStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
                              //hintText: "Password",
                              errorText: (passwordController.text.length < 4 &&
                                      isSubmitPressed)
                                  ? "password should have atlest 4 letters"
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 0, 0, 0))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 24, 10, 9))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade800)),
                              contentPadding: const EdgeInsets.only(left: 25),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 300,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            //maxLength: 40,
                            controller: contactNoController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Phone No.",
                              prefixIcon: const Icon(Icons.phone_android),
                              labelStyle: const TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 0.5)),
                              errorText: ((contactNoController.text.length !=
                                              10 &&
                                          isSubmitPressed) ||
                                      (!isnumberContainIntegerOnly(
                                              contactNoController.text) &&
                                          contactNoController.text.isNotEmpty))
                                  ? "please enter valid mobile number"
                                  : null,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.black)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      BorderSide(color: Colors.red.shade800)),
                              contentPadding: const EdgeInsets.only(left: 25),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 3,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                          width: 300,
                          height: 43,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 14,
                                offset: const Offset(2, 8))
                          ]),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 31, 175, 253),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              isSubmitPressed = true;
                              userNamehaveoneletter = true;
                              passwordhaveoneletter = true;
                              setState(() {});
                              if (cheachuserNamehaveoneletterIsFilled()) {
                                singUp();
                              }
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          )),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              " already have an accounts?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 400),
                                    pageBuilder: (context, animation, _) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: const Login(),
                                      );
                                    },
                                  ),
                                );
                              },
                              style: const ButtonStyle(),
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 31, 175, 253),
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ]),
                    ]),
              ),
            ))
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 139, 254, 126),
                        child: Icon(
                          Icons.check,
                          grade: 400,
                          // weight: 200,
                          size: 45,
                        ),
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Your account has been \n   succesfully created",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 242, 219, 184),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 14,
                          offset: const Offset(2, 8),
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome to PNews!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Hello ${usernameController.text},',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Welcome to PNews! Stay updated with the latest news and explore various categories tailored to your interests. Customize your feed, save articles, and share with friends.',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12.0),
                          const Text(
                            'Enjoy your reading!\n\nBest Regards,\nThe PNews Team',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(2, 4),
                      )
                    ]),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 45),
                        backgroundColor:
                            const Color.fromARGB(255, 139, 254, 126),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 100),
                            pageBuilder: (context, animation, _) {
                              return FadeTransition(
                                opacity: animation,
                                child: const Login(),
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  bool isnumberContainIntegerOnly(String contact) {
    try {
      int.parse(contact);
    } catch (e) {
      return false;
    }
    return true;
  }

  bool cheachuserNamehaveoneletterIsFilled() {
    username = usernameController.text;
    password = passwordController.text;
    contact = contactNoController.text;

    if (username == '') {
      usernameError = 1;
    } else {
      usernameError = 0;
    }
    if (password == '' || password.length < 4) {
      passwordError = 1;
    } else {
      passwordError = 0;
    }
    if (contact == '' || contact.length != 10) {
      contactNoError = 1;
    } else {
      contactNoError = 0;

      try {
        // ignore: unused_local_variable
        int number = int.parse(contact);
        contactNoError = 0;
      } catch (e) {
        contactNoError = 1;
      }
    }

    setState(() {});
    if (usernameError == 0 && passwordError == 0 && contactNoError == 0) {
      return true;
    } else {
      return false;
    }
  }
}
