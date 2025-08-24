import 'package:flutter/material.dart';
import '../screens/day_list_screen.dart';
import 'package:gym/widgets/appbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _password = "";
  bool currentvisibilityofPassWord = true;
  bool currentvisibilityofConfirmedPassWord = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        toolbarHeight: MediaQuery.of(context).size.height * 0.035,
      ),
      backgroundColor: Color.fromARGB(255, 28, 28, 28),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Center(
                child: Container(
                  width: 340,
                  height: 600,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 21, 20, 20),
                        blurRadius: 50.0,
                        spreadRadius: 1.5,
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1C1018),
                        Color.fromARGB(255, 211, 78, 36),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "What a lucky day to join our community ! ",
                          style: TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //full name feild
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 116, 46, 37),
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 28, 28, 28),
                                      width: 3.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Full Name',
                                  labelStyle: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(190, 28, 28, 34),
                                  ),
                                  focusColor: Color.fromARGB(255, 237, 106, 90),
                                ),

                                validator: (value1) {
                                  if (value1 != null &&
                                      value1[0] == value1[0].toUpperCase()) {
                                    return null;
                                  }
                                  return 'First letter must be uppercase!';
                                },
                              ),
                            ),

                            SizedBox(height: 1),

                            //Email feild
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 28, 28, 28),
                                      width: 3.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 116, 46, 37),
                                      width: 2.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(190, 28, 28, 34),
                                  ),
                                  focusColor: Color.fromARGB(255, 237, 106, 90),
                                ),

                                validator: (value2) {
                                  if (value2 != null && value2.contains('@')) {
                                    return null;
                                  }
                                  return 'please enter vaild email';
                                },
                              ),
                            ),

                            SizedBox(height: 1),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                obscureText: currentvisibilityofPassWord,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 28, 28, 28),
                                      width: 3.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 116, 46, 37),
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        currentvisibilityofPassWord =
                                            !currentvisibilityofPassWord;
                                      });
                                    },
                                    icon: Icon(
                                      currentvisibilityofPassWord
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 30,
                                      color: Color.fromARGB(255, 59, 23, 19),
                                    ),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(190, 28, 28, 34),
                                  ),
                                ),
                                validator: (value3) {
                                  if (value3 != null && value3.length >= 6) {
                                    _password = value3;
                                    return null;
                                  }
                                  return 'please enter correct password';
                                },
                              ),
                            ),

                            SizedBox(height: 1),
                            //confirm password feild
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                obscureText:
                                    currentvisibilityofConfirmedPassWord,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 28, 28, 28),
                                      width: 3.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 116, 46, 37),
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        currentvisibilityofConfirmedPassWord =
                                            !currentvisibilityofConfirmedPassWord;
                                      });
                                    },
                                    icon: Icon(
                                      currentvisibilityofConfirmedPassWord
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 30,
                                      color: Color.fromARGB(255, 59, 23, 19),
                                    ),
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromARGB(190, 28, 28, 34),
                                  ),
                                  focusColor: Color.fromARGB(255, 237, 106, 90),
                                ),

                                validator: (value4) {
                                  if (value4 != null && value4 == _password) {
                                    return null;
                                  }
                                  return 'Must match password';
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          final isValid = _formKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Successful process!',
                                    style: TextStyle(
                                      fontFamily: 'BebasNeue',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'Account created successfully.',
                                    style: TextStyle(
                                      fontFamily: 'BebasNeue',
                                      fontSize: 17,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'Go to home screen',
                                        style: TextStyle(
                                          fontFamily: 'BebasNeue',
                                          color: Color.fromARGB(
                                            255,
                                            28,
                                            28,
                                            28,
                                          ),
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          PageRouteBuilder(
                                            transitionDuration: Duration(
                                              milliseconds: 800,
                                            ),
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) => AppbarWidget(
                                                  Title: "Iron Pulse",
                                                  ScafoldWidget:
                                                      DaysListScreen(),
                                                ),
                                            transitionsBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child,
                                                ) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Color.fromARGB(190, 28, 28, 34),
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
