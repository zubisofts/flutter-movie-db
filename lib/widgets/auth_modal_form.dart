import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_event.dart';

class AuthModalForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16,),
            Text(
              "Use one of the following sign in options to enjoy the full previledge of MovieDB",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Theme.of(context).accentColor,
              height: 2.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton.icon(
              color: Colors.blueAccent,
              icon: Icon(
                FontAwesome.google,
                color: Colors.white,
              ),
              label: Text("SIGN IN WITH GOOGLE"),
              onPressed: () {
               new AuthBloc().add(GoogleLoginEvent());
               Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton.icon(
              icon: Icon(
                FontAwesome.facebook,
                color: Colors.white,
              ),
              label: Text("SIGN IN WITH FACEBOOK"),
              color: Colors.blue,
              onPressed: () {
                new AuthBloc().add(FacebookLoginEvent());
                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}
