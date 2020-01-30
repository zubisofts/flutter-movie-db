import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/pages/auth_page.dart';
import 'package:flutter_ui_challenge/pages/home.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        // textTheme: GoogleFonts.ral8ewayTextTheme(Theme.of(context).textTheme),
      ),
      home: Home(),
    );
  }
}