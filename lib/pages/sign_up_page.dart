import 'package:flutter/material.dart';

import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
            Text(
              "Create Account",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Endless Partying possible awaits you. Kindly fill in your details to join the parte",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Form(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(labelText: "Firstname",labelStyle: TextStyle(color: Colors.grey[700])),
                  ),
                   SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(labelText: "Lastname",labelStyle: TextStyle(color: Colors.grey[700])),
                  ),
                   SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(labelText: "Email",labelStyle: TextStyle(color: Colors.grey[700])),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Pasword",labelStyle: TextStyle(color: Colors.grey[700])),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Confirm Pasword",labelStyle: TextStyle(color: Colors.grey[700])),
                  ),
                  SizedBox(height: 50,),
                   InkWell(
                onTap: () {
                  },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
                ],
              ),
            ),
            SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context)=>SignInPage()));

                    },
                    child: Container(child: Text("Already have an acccount? Sign In",style: TextStyle(color:Colors.grey[700],fontWeight: FontWeight.w500),)))
                ],
              ),
              SizedBox(height: 100,),
              // Center(child: Text("Parte After Perte.",style: TextStyle(fontWeight: FontWeight.bold),))
              ],
            ),
          )
        ],
      ),
    );
  }
}
