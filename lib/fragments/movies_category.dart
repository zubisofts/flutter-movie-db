import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:MovieDB/bloc/app_bloc/app_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_state.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/widgets/movie_list_row.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (BuildContext context, AuthState state) {
          if (state is AuthLoginState) {
            User user=state.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                MovieListRow(
                  title: "Now Playing",
                  type: MovieCat.NowPlaying,
                  user: user,
                ),
                MovieListRow(
                  title: "Top Rated",
                  type: MovieCat.TopRated,
                  user: user,
                ),
                MovieListRow(
                  title: "Popular",
                  type: MovieCat.Popular,
                  user: user,
                ),
                MovieListRow(
                  title: "Upcoming",
                  type: MovieCat.Upcoming,
                  user: user,
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class ModalContent extends StatefulWidget {
  ModalContent({
    Key key,
  }) : super(key: key);

  @override
  _ModalContentState createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    // final _appBloc = BlocProvider.of<AppBloc>(context);
    // _appBloc.add(GetThemeValueEvent());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        height: 200,
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
            ),
          ],
        ),
      ),
    );
  }
}
