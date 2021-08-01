import 'package:MovieDB/fragments/tv_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/bloc.dart';
import 'package:MovieDB/fragments/discover_page.dart';
import 'package:MovieDB/fragments/movies_category.dart';
import 'package:MovieDB/fragments/news_page.dart';
import 'package:MovieDB/pages/profile_screen.dart';
import 'package:MovieDB/widgets/auth_modal_form.dart';

import 'package:MovieDB/widgets/search_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;
  PageController _pageController;
  List<Widget> pages = [
    MainPage(),
    TvCategory(),
    DiscoverPage(),
    NewsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());
    return Scaffold(
      // backgroundColor: Colors.white,
      // key: homeScaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        textTheme: Theme.of(context).textTheme,
//        leading: IconButton(
//          icon: Icon(
//            Icons.menu,
//            color: Theme.of(context).iconTheme.color,
//          ),
//          onPressed: () {
//            buildShowModalBottomSheet(context);
//          },
//        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("[",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Bold")),
            Text("Movie",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,fontFamily: "Poppins-Bold")),
            Text("DB",
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Bold")),
            Text("]",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins-Bold")),
          ],
        ),
//        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Theme.of(context).iconTheme.color,
            onPressed: () {
              showSearch(context: context, delegate: SearchWidget());
            },
          ),
          BlocBuilder(
            bloc: BlocProvider.of<AuthBloc>(context),
            builder: (BuildContext context, state) {
              if (state is AuthLoginState) {
                User user = state.user;
                // print("object ${user.email}");

                return IconButton(
                  onPressed: () {
                    user != null
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext ctx) =>
                                ProfileScreen(user: user)))
                        :
                        // widget.user == null?
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (BuildContext ctx) => SignInPage()))
                        showDialog(
                            useRootNavigator: true,
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: AuthModalForm(),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                              );
                            });
                  },
                  icon: Icon(
                    FontAwesome.user_circle_o,
                    color: Theme.of(context).iconTheme.color,
                  ),
                );
              }

              return SizedBox.shrink();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // AppBarSection(),
          // SizedBox(
          //   height: 10,
          // ),
          Expanded(
            child: PageView(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: pages),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.animateToPage(_currentPageIndex,
                curve: Curves.easeInOutQuint, duration: Duration(seconds: 1));
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(
              icon: Icon(Icons.live_tv), label: "TV Series"),
          BottomNavigationBarItem(
              icon: Icon(MaterialIcons.open_in_browser),
              label: "Discover"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesome.newspaper_o), label: "News")
        ],
      ),
      // floatingActionButton: _currentPageIndex == 3
      //     ? FloatingActionButton.extended(
      //         label: Icon(Icons.share),
      //         icon: Text("Share watch List"),
      //         onPressed: () {
      //         homeScaffoldKey.currentState.showSnackBar(SnackBar(content:Text("dhgdhnk")));
      //         },
      //       )
      //     : SizedBox.shrink(),
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
