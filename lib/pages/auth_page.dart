import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/pages/sign_in_page.dart';

import 'sign_up_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Text("V 1.32.1", style: TextStyle(color: Colors.blue)),
              ),
              SizedBox(
                height: 10,
              ),
              Text("What's New?",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 32)),
              SizedBox(
                height: 40,
              ),
              ListItem(
                title: "Connect To Multiple Speakers",
                subTitle:
                    "You can now connect to multiple bluetooth speakers at a time.",
                icon: Icons.bluetooth_connected,
                iconColor: Colors.deepPurpleAccent,
              ),
              SizedBox(
                height: 32,
              ),
              ListItem(
                title: "Broadcast Party Value",
                subTitle: "Notify friends nearby of an ongoing party.",
                icon: Icons.settings_input_antenna,
                iconColor: Colors.orangeAccent,
              ),
              SizedBox(
                height: 32,
              ),
              ListItem(
                title: "Flutter Interactive",
                subTitle:
                    "Run a codelab from your mobile phone and with the world.",
                icon: Icons.insert_emoticon,
                iconColor: Colors.green,
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context)=>SignInPage()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context)=>SignUpPage()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.blue, width: 1))),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}

class ListItem extends StatelessWidget {
  String title;
  String subTitle;
  Color iconColor;
  IconData icon;
  ListItem({
    Key key,
    this.title,
    this.subTitle,
    this.iconColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, color: iconColor),
               
              ],
            )),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 3,
                  softWrap: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  subTitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
