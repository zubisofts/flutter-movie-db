import 'package:MovieDB/model/movie_list.dart';
import 'package:MovieDB/pages/loading_text_widget.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/widgets/movie_item_horizontal.dart';
import 'package:MovieDB/widgets/movie_item_vertical.dart';

class DiscoverListFragment extends StatefulWidget {
  final int id;
  final String sortQuery;
  final List<int> genres;
  final String year;
  final MediaType mediaType;
  final FirebaseUser user;

  DiscoverListFragment({
    Key key,
    this.id,
    this.mediaType,
    this.sortQuery,
    this.genres,
    this.year,
    this.user
  }) : super(key: key);

  @override
  _DiscoverListFragmentState createState() => _DiscoverListFragmentState();
}

class _DiscoverListFragmentState extends State<DiscoverListFragment> {
  bool isVertical = false;

  @override
  Widget build(BuildContext context) {
  //  if(widget.user!=null){
  //     // BlocProvider.of<MoviesBloc>(context).add(LoadWatchListMoviesEvent(uid: widget.user.uid));
  //  }
    return Container(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
          future: new MovieRepository().discover(widget.sortQuery, widget.genres, widget.year, widget.mediaType,1),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.data == null) {
        return Center(
          child: LoadingTextWidget(baseColor: Colors.red,highlightColor: Colors.yellow,text: "Loading...",),
        );
      }
      MovieList movieList=snapshot.data;
      print('Snapshot:${movieList.results.length}');
      return DiscoverListLayout(
        mediaType: widget.mediaType,
        user: widget.user,
        item: snapshot.data,
        sortQuery: widget.sortQuery,
        genres: widget.genres,
        isVertical: isVertical,
      );
          },
        ),
    ); 
  }
}

class DiscoverListLayout extends StatefulWidget {
  final dynamic item;
  final MediaType mediaType;
   final String sortQuery;
    final List<int> genres;
    final String year;
  final bool isVertical;
  final FirebaseUser user;

  DiscoverListLayout(
      {Key key, this.item, this.mediaType,this.isVertical,this.genres,this.sortQuery,this.year, this.user})
      : super(key: key);

  @override
  _DiscoverListLayoutState createState() => _DiscoverListLayoutState();
}

class _DiscoverListLayoutState extends State<DiscoverListLayout> {
  ScrollController scrollController = ScrollController();

  var movies=[];

  int currentPage = 1;
  int totalPage;
  bool isLoading = false;

  void loadMoreMovies() async {
    var mMovies = await new MovieRepository()
        .discover(widget.sortQuery,widget.genres,widget.year,widget.mediaType, currentPage + 1);
    if (mMovies != null) {
      currentPage = mMovies.page;
      // print('$currentPage/$totalPage');
      mMovies.results.add(null);
      if (mounted)
        setState(() {
          isLoading = false;
          movies.addAll(mMovies.results);
        });
    }
  }

  bool onNotificatin(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        // print("Ended:");
        // _appBloc.add(ListScrollEvent(load: true));
        if (!isLoading) {
          if (currentPage < totalPage) loadMoreMovies();
          isLoading = true;
        }
      }
    }
    return true;
  }

  @override
  void initState() {
    movies = widget.item.results;
    totalPage = widget.item.totalPages;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                if (index == movies.length - 1) {
                  movies.removeLast();
                  return Center(
                      child: SpinKitThreeBounce(
                    color: Colors.greenAccent,
                  ));
                }
                // if(movies[index]==null)
                //  return SizedBox.shrink();
                if (movies[index] != null) {
//                  print(movies[index].title);
                  return MovieItemVertical(
                    movie: movies[index],
                    user: widget.user,
                  );
                }
                return SizedBox.shrink();
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
                if (index == movies.length - 1) {
                  movies.removeLast();
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MovieItemHorizontal(
                  movie: movies[index],
                  user: widget.user,
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.5, crossAxisCount: 3),
            ),
          );
  }
}
