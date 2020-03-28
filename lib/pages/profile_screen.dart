import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_event.dart';
import 'package:MovieDB/fragments/movies_category.dart';

import 'package:MovieDB/pages/favourites_page.dart';
import 'package:MovieDB/pages/watchlist_page.dart';
import 'package:getflutter/getflutter.dart';

class ProfileScreen extends StatefulWidget {
  final FirebaseUser user;
  ProfileScreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Account"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Center(
            child: GFAvatar(
              shape: GFAvatarShape.circle,
              radius: 45,
              backgroundImage: NetworkImage(widget.user.photoUrl),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
              child: Text('${widget.user.displayName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          SizedBox(
            height: 8,
          ),
          Center(
              child: Text(
            '${widget.user.email}',
            style: TextStyle(fontSize: 16),
          )),
          SizedBox(height: 32.0),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            title: Text("Watch List"),
            leading: Icon(Icons.watch_later),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => WatchListPage(
                      user: widget.user,
                    ))),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            title: Text("Favourites"),
            leading: Icon(Icons.favorite),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => FavouritesPage())),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            title: Text("Logout"),
            leading: Icon(FontAwesome.sign_out),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              Navigator.pop(context);
            },
          ),
          Divider(),
          ModalContent()
        ],
      ),
    );
  }
}
