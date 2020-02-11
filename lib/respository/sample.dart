import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ui_challenge/bloc/app_bloc/app_bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/movies_bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/movies_event.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/movies_state.dart';
import 'package:flutter_ui_challenge/model/movie.dart';
import 'package:flutter_ui_challenge/model/movie_list.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';
import 'package:flutter_ui_challenge/widgets/movie_item_horizontal.dart';
import 'package:flutter_ui_challenge/widgets/movie_item_vertical.dart';

class MoviesListPage extends StatefulWidget {
  final int id;
  final String title;
  final MovieCat type;
  bool isVertical;

  MoviesListPage({
    Key key,
    this.id,
    this.title,
    this.type,
    this.isVertical = false,
  }) : super(key: key);

  @override
  _MoviesListPageState createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {
  int currentPageindex = 1;

  final AppBloc _appBloc = AppBloc();

  final MoviesBloc _moviesBloc = MoviesBloc();

  ScrollController scrollController = ScrollController();

  List<Results> movies;

  @override
  void initState() {
    movies=[];
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
}

  bool onNotificatin(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        print("Ended");
        // _appBloc.add(ListScrollEvent(load: true));
        loadMoreMovies();
      }
    }
    return true;
  }

  void loadMoreMovies() async {
    MovieRespository respository = MovieRespository();
    var dMovies =
        await respository.getMovies(widget.type, widget.id, currentPageindex+1);
    if (dMovies != null) {
      if (dMovies.results.length > 0) {
        setState(() {
          currentPageindex = dMovies.page;
          // movies.addAll(dMovies.results);
          print(dMovies.page);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _moviesBloc.add(LoadMoviesEvent(
        id: widget.id, type: widget.type, currentPageIndex: currentPageindex));
    // scrollController.addListener(() {
    //   if (scrollController.position.maxScrollExtent ==
    //       scrollController.position.pixels) {
    //     _appBloc.add(ListScrollEvent(index:currentPageindex));
    //   }
    // });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          BlocBuilder<AppBloc, AppState>(
            bloc: _appBloc,
            builder: (BuildContext context, state) {
              if (state is ListToggleState) {
                // print("responding");
                widget.isVertical = state.isVertical;
                _moviesBloc.add(LoadMoviesEvent(
                    id: widget.id,
                    type: widget.type,
                    currentPageIndex: currentPageindex));
                return IconButton(
                  onPressed: () {
                    _appBloc
                        .add(ListToggleEvent(isVertical: !widget.isVertical));
                  },
                  icon: Icon(widget.isVertical ? Icons.grid_on : Icons.list),
                );
              }

              if (state is ListScrollState) {
                // print("Max scroll reached");
                _moviesBloc.add(LoadMoreMoviesEvent(
                    id: widget.id,
                    type: widget.type,
                    currentPageIndex: currentPageindex + 1));
              }

              return IconButton(
                onPressed: () {
                  // print(isVertical);
                  _appBloc.add(ListToggleEvent(isVertical: !widget.isVertical));
                },
                icon: Icon(Icons.grid_on),
              );
            },
          ),
        ],
        title: Text(widget.title,
            style: TextStyle(
                // color: Theme.of(context).accentColor,
                // fontSize: ,
                // fontWeight: FontWeight.bold
                )),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: BlocBuilder<MoviesBloc, MoviesState>(
              bloc: _moviesBloc,
              builder: (BuildContext context, MoviesState state) {
                if (state is LoadingState) {
                  return Center(child: CircularProgressIndicator());
                }

                // if (state is MoreMoviesLoadedState) {
                //   print("More loaded");
                //   // print(currentPageindex);
                //   currentPageindex += state.movies.page;
                //   movies.addAll(state.movies.results);
                // }

                if (state is MoviesLoadedState) {
                  // print(currentPageindex);
                  var _movies = state.movies.results;
                  movies.addAll(_movies);
                  if (_movies != null) {
                    if (_movies.length > 0) {
                      // currentPageindex += state.movies.page;
                      // print(currentPageindex);
                      return widget.isVertical
                          ? NotificationListener(
                              onNotification: onNotificatin,
                              child: ListView.builder(
                                controller: scrollController,
                                physics: BouncingScrollPhysics(),
                                itemCount: movies.length,
                                // shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(movies[index].title);
                                  // Movie movie=movies[index];
                                  // if(index>movies.length){
                                  //   return Center(child: CircularProgressIndicator(),);
                                  // }
                                  return MovieItemVertical(
                                      movie: movies[index]);
                                },
                              ),
                            )
                          : NotificationListener(
                              onNotification: onNotificatin,
                              child: GridView.builder(
                                controller: scrollController,
                                itemCount: movies.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  //  if(index==movies.length-1){
                                  //   return Center(child: CircularProgressIndicator(),);
                                  // }
                                  return MovieItemHorizontal(
                                    movie: movies[index],
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 0.5,
                                        crossAxisCount: 2),
                              ),
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
                          onPressed: () => _moviesBloc.add(LoadMoviesEvent(
                              id: widget.id, type: widget.type)),
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
                      onPressed: () => _moviesBloc.add(
                          LoadMoviesEvent(id: widget.id, type: widget.type)),
                    )
                  ],
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ToggleIcon extends StatefulWidget {
  bool isVertical = true;

  @override
  _ToggleIconState createState() => _ToggleIconState();
}

class _ToggleIconState extends State<ToggleIcon> {
  AppBloc _appBloc = AppBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      bloc: _appBloc,
      builder: (BuildContext context, state) {
        if (state is ListToggleState) {
          widget.isVertical = state.isVertical;
          return IconButton(
            onPressed: () {
              _appBloc.add(ListToggleEvent(isVertical: !widget.isVertical));
            },
            icon: Icon(widget.isVertical ? Icons.grid_on : Icons.list),
          );
        }

        return IconButton(
          onPressed: () {
            _appBloc.add(ListToggleEvent(isVertical: !widget.isVertical));
          },
          icon: Icon(Icons.grid_on),
        );
      },
    );
  }
}
