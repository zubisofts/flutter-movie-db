import 'package:MovieDB/bloc/auth_bloc/auth_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/movies_bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/movies_event.dart';
import 'package:MovieDB/bloc/movies_bloc/movies_state.dart';
import 'package:MovieDB/bloc/tv_bloc/tv_bloc.dart';
import 'package:MovieDB/pages/movie_list_page.dart';
import 'package:MovieDB/pages/tv_list_page.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/repository/tv_series_repository.dart';
import 'package:MovieDB/widgets/movie_item_horizontal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tv_item_horizontal.dart';
class TvListRow extends StatefulWidget {
  final String title;
  final TvCat type;
  final int id;
  final FirebaseUser user;

  TvListRow({Key key, this.title, this.type, this.id,this.user}) : super(key: key);

  @override
  _TvListRowState createState() => _TvListRowState();
}

class _TvListRowState extends State<TvListRow> {
  TvBloc _tvBloc = TvBloc();
  @override
  void initState() {
    _tvBloc.add(LoadTvEvent(
      type: widget.type,
      id: widget.id,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
      color: Theme.of(context).canvasColor,
      elevation: 4,
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        height: 300,
        // width: 200,
        // decoration: BoxDecoration(
        //   boxShadow: [
        //     BoxShadow(
        //       offset: Offset(0, 0),
        //       blurRadius: 2,
        //       spreadRadius: 1,
        //     )
        //   ]
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => TvListPage(
                            title: widget.title,
                            id: widget.id,
                            user:widget.user,
                            type: widget.type,
                          )));
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Center(
                        child: Text(
                          "View All",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Theme.of(context).accentColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (BuildContext context, state) {
                  if (state is AuthLoginState){
                    return buildMovieList();
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMovieList() {
    return BlocBuilder<TvBloc, TvState>(
      bloc: _tvBloc,
      builder: (BuildContext context, TvState state) {
        if (state is TvLoadingState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is AuthErrorState) {
          return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("An error occured!"),
                  RaisedButton(
                    child: Text("Retry"),
//                    onPressed: () =>
//                        _tvBloc.add(LoadMoviesEvent(id: widget.id, type: widget.type)),
                  )
                ],
              ));
        }

        if (state is TvLoadedState) {
          var tvList = state.tvs;
          var tvs = tvList.results;
          if (tvs != null) {
            if (tvs.length > 0) {
              if (tvs.length > 10) {
                tvs = tvs.sublist(0, 8);
              }
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: tvs.length,
                addAutomaticKeepAlives: true,
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  // print(movies[index].title);
                  // Movie movie=movies[index];
//                  return Text(tvs[index].name);
                  return TvItemHorizontal(tv: tvs[index],user: widget.user,);
                },
              );
            }
          } else {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Nothing was found!"),
                    RaisedButton(
                      child: Text("Retry"),
//                      onPressed: () =>
//                          _moviesBloc.add(LoadMoviesEvent(id: widget.id, type: widget.type)),
                    )
                  ],
                ));
          }
        }

        return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("An error occured!"),
                RaisedButton(
                  child: Text("Retry"),
//                  onPressed: () =>
//                      _tvBloc.add(LoadMoviesEvent(id: widget.id, type: widget.type)),
                )
              ],
            ));
      },
    );
  }
}
