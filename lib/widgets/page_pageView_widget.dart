import 'package:flutter/material.dart';
import '../screens/sign_in_screen.dart';
import '../screens/sign_up_screen.dart';

class PageInPageView extends StatelessWidget {
  final String title;
  final String body;
  final String image;
  final int index;
  final int totalPages;

  const PageInPageView({
    super.key,
    required this.title,
    required this.body,
    required this.image,
    required this.index,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = index == totalPages - 1;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 22, 22, 22),
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: isLastPage
          ? Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.bold,
                      fontSize: 45.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    body,
                    style: const TextStyle(
                      fontFamily: 'Suwannaphum',
                      fontSize: 23,
                      color: Color.fromARGB(255, 211, 78, 36),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.asset(image, height: 350),
                      ),
                      // SizedBox(width: 7),
                      Column(
                        children: [
                          SizedBox(height: 80),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  transitionDuration: Duration(
                                    milliseconds: 400,
                                  ),
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => SigninScreen(),
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
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 28, 28, 34),
                                fontFamily: 'Suwannaphum',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "Already a member ?",
                            style: const TextStyle(
                              fontFamily: 'Suwannaphum',
                              fontSize: 14,
                              color: Color.fromARGB(199, 252, 112, 70),
                            ),
                          ),
                          SizedBox(height: 80),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  transitionDuration: Duration(
                                    milliseconds: 400,
                                  ),
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => SignUpScreen(),
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
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 28, 28, 34),
                                fontFamily: 'Suwannaphum',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "Come join us !",
                            style: const TextStyle(
                              fontFamily: 'Suwannaphum',
                              fontSize: 14,
                              color: Color.fromARGB(199, 252, 112, 70),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'BebasNeue',
                      fontWeight: FontWeight.bold,
                      fontSize: 45.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    body,
                    style: const TextStyle(
                      fontFamily: 'Suwannaphum',
                      fontSize: 23,
                      color: Color.fromARGB(255, 211, 78, 36),
                    ),
                  ),
                ),
                const SizedBox(height: 240),
                Expanded(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.asset(image, height: 247),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
