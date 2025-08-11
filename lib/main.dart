import 'package:flutter/material.dart';
// import 'widgets/add_day_button.dart';
import '../screens/day_list_screen.dart';
import 'package:gym/widgets/appbar.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppbarWidget(Title: "Iron Pulse", ScafoldWidget: DaysListScreen()),
    ),
  );
}
