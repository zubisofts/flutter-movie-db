import 'package:MovieDB/model/tv_list_model.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/repository/tv_series_repository.dart';
import 'package:MovieDB/widgets/tv_item_horizontal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:MovieDB/bloc/movies_bloc/bloc.dart';

import 'package:MovieDB/pages/watchlist_page.dart';

import 'loading_text_widget.dart';

class TvListPage extends StatefulWidget {
  final int id;
  final String title;
  final TvCat type;
  final User user;

  TvListPage({
    Key key,
    this.id,
    this.title,
    this.type,
    this.user,
  }) : super(key: key);

  @override
  _TvListPageState createState() => _TvListPageState();
}

class _TvListPageState extends State<TvListPage> {
  bool isVertical = false;

  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      BlocProvider.of<MoviesBloc>(context).add(LoadWatchListMoviesEvent(
          uid: widget.user.uid, mediaType: MediaType.TV));
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: isVertical
                  ? Icon(Icons.grid_on)
                  : Icon(Icons.list_alt_outlined),
              onPressed: () {
                setState(() {
                  isVertical = !isVertical;
                });
              },
            )
          ],
          title: Text(widget.title,
              style: TextStyle(
                  // color: Theme.of(context).accentColor,
                  // fontSize: ,
                  // fontWeight: FontWeight.bold
                  )),
        ),
        body: FutureBuilder(
          future: new TVRepository().getTvShows(widget.type, widget.id, 1),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: LoadingTextWidget(
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow,
                  text: "Loading...",
                ),
              );
            }
            return TvListLayout(
              type: widget.type,
              id: widget.id,
              user: widget.user,
              tvList: snapshot.data,
              isVertical: isVertical,
            );
          },
        ),
        floatingActionButton: widget.user != null
            ? BlocBuilder<MoviesBloc, MoviesState>(
                bloc: BlocProvider.of<MoviesBloc>(context),
                builder: (BuildContext context, MoviesState state) {
                  if (state is WatchListMoviesLoaded) {
                    return FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).accentColor,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => WatchListPage(
                                  user: widget.user,
                                )));
                      },
                      icon: Icon(Icons.watch_later),
                      label: Text('${state.watchList.length} ' +
                          '${state.watchList.length > 1 ? 'items' : 'item'}'),
                    );
                  }
                  return SizedBox.shrink();
                },
              )
            : SizedBox.shrink());
  }
}

class TvListLayout extends StatefulWidget {
  final Tv tvList;
  final TvCat type;
  final int id;
  final bool isVertical;
  final User user;

  TvListLayout(
      {Key key, this.tvList, this.type, this.id, this.isVertical, this.user})
      : super(key: key);

  @override
  _TvListLayoutState createState() => _TvListLayoutState();
}

class _TvListLayoutState extends State<TvListLayout> {
  ScrollController scrollController = ScrollController();

  List<Result> tvs;

  int currentPage = 1;
  int totalPage;
  bool isLoading = false;

  void loadMoreMovies() async {
    var mTvs = await new TVRepository()
        .getTvShows(widget.type, widget.id, currentPage + 1);
    if (mTvs != null) {
      currentPage = mTvs.page;
      // print('$currentPage/$totalPage');
      mTvs.results.add(null);
      if (mounted)
        setState(() {
          isLoading = false;
          tvs.addAll(mTvs.results);
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
    tvs = widget.tvList.results;
    totalPage = widget.tvList.totalPages;
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
              itemCount: tvs.length,
              // shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                // print(movies[index].title);
                // Movie movie=movies[index];
                if (index == tvs.length - 1) {
                  tvs.removeLast();
                  return Center(
                      child: SpinKitThreeBounce(
                    color: Colors.greenAccent,
                  ));
                }
                // if(movies[index]==null)
                //  return SizedBox.shrink();
                if (tvs[index] != null) {
//                  print(movies[index].title);
                  return TvItemHorizontal(
                    tv: tvs[index],
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
              itemCount: tvs.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index == tvs.length - 1) {
                  tvs.removeLast();
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return TvItemHorizontal(
                  tv: tvs[index],
                  user: widget.user,
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.5, crossAxisCount: 3),
            ),
          );
  }
}
