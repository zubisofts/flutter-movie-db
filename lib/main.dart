import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/pages/auth_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // textTheme: GoogleFonts.ral8ewayTextTheme(Theme.of(context).textTheme),
      ),
      home: AuthPage(),
    );
  }
}