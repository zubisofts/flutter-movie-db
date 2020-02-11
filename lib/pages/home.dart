import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_challenge/bloc/app_bloc/app_bloc.dart';

import 'package:flutter_ui_challenge/respository/movie_respository.dart';
import 'package:flutter_ui_challenge/widgets/list_row.dart';
import 'package:flutter_ui_challenge/widgets/search_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;
  List<Widget> pages = [
    MainPage(),
    Container(
      child: Center(
        child: Text("Second Page"),
      ),
    ),
    Container(
      child: Center(
        child: Text("Third Page"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBarSection(),
          SizedBox(
            height: 10,
          ),
          pages[_currentPageIndex]
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.watch_later), title: Text("Watch List")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), title: Text("Profile"))
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListRow(title: "Now Playing", type: MovieCat.NowPlaying),
            ListRow(title: "Top Rated", type: MovieCat.TopRated),
            ListRow(title: "Popular", type: MovieCat.Popular),
            ListRow(title: "Upcoming", type: MovieCat.Upcoming),
          ],
        ),
      ),
    );
  }
}

class AppBarSection extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  buildShowModalBottomSheet(context);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text("Movie",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("DB",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                ],
              ),
               IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchWidget());
              },
            ),
            ],
          )
        ],
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (BuildContext context) {
          return ModalContent();
        },
        context: context);
  }
}

class ModalContent extends StatelessWidget {
  bool value = false;

  ModalContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _appBloc = BlocProvider.of<AppBloc>(context);
    // _appBloc.add(GetThemeValueEvent());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "App Settings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            BlocBuilder<AppBloc, AppState>(
              // bloc: _appBloc,
              builder: (BuildContext context, AppState state) {
                BlocProvider.of<AppBloc>(context).add(GetThemeValueEvent());

                if (state is ThemeChangedState) {
                  value = state.value;
                }

                if (state is GetThemeValueState) {
                  value = state.value;
                }

                return SwitchListTile(
                  title: Text("Dark Theme"),
                  value: value,
                  onChanged: (val) => BlocProvider.of<AppBloc>(context)
                      .add(ChangeThemeEvent(value: val)),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
