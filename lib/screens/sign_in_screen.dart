import 'package:flutter/material.dart';
import '../screens/day_list_screen.dart';
import 'package:gym/widgets/appbar.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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
                  height: 500,
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
                          "Welcome Back",
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
                          "Sign in to Iron Pulse",
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

                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 28, 28, 28),
                                      width: 3.0,
                                    ),
                                  ),

                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(190, 28, 28, 34),
                                  ),
                                  focusColor: Color.fromARGB(255, 237, 106, 90),
                                ),

                                validator: (value1) {
                                  if (value1 != null && value1.contains('@')) {
                                    return null;
                                  }
                                  return 'please enter vaild email';
                                },
                              ),
                            ),

                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                obscureText: currentvisibilityofPassWord,
                                decoration: InputDecoration(
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
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 28, 28, 28),
                                      width: 3.0,
                                    ),
                                  ),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontFamily: 'BebasNeue',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(190, 28, 28, 34),
                                  ),
                                ),
                                validator: (value) {
                                  if (value != null && value.length >= 6) {
                                    return null;
                                  }
                                  return 'please enter correct password';
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
                                    'Welcome Back Legend!',
                                    style: TextStyle(
                                      fontFamily: 'BebasNeue',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'Account sign-in successfully.',
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
                                              ScafoldWidget: DaysListScreen(),
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
                          "Sign in",
                          style: TextStyle(
                            color: Color.fromARGB(255, 28, 28, 28),
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
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

