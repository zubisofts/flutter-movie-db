import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome to home page",style:TextStyle(fontSize: 24,fontWeight:FontWeight.bold)),
      ),
    );
  }
}