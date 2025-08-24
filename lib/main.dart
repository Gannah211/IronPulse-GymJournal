import 'package:flutter/material.dart';
// import 'widgets/add_day_button.dart';
// import '../screens/day_list_screen.dart';
// import 'package:gym/widgets/appbar.dart';
import './screens/welcom_Screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:WelcomScreen(),
    ),
  );
}

// AppbarWidget(Title: "Iron Pulse", ScafoldWidget: DaysListScreen())