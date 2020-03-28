import 'package:MovieDB/repository/tv_series_repository.dart';
import 'package:MovieDB/widgets/tv_list_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:MovieDB/bloc/auth_bloc/auth_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_state.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/widgets/movie_list_row.dart';

class TvCategory extends StatelessWidget {
  const TvCategory({
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
            FirebaseUser user = state.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TvListRow(
                  title: "On The Air",
                  type: TvCat.OnTheAir,
                  user: user,
                ),
                TvListRow(
                  title: "Airing Today",
                  type: TvCat.AiringToday,
                  user: user,
                ),
//                TvListRow(
//                  title: "Latest",
//                  type: TvCat.Latest,
//                  user: user,
//                ),
                TvListRow(
                  title: "Popular",
                  type: TvCat.Popular,
                  user: user,
                ),
                TvListRow(
                  title: "Top Rated",
                  type: TvCat.TopRated,
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
