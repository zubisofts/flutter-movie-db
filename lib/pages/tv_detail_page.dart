import 'package:MovieDB/bloc/movies_bloc/movies_bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/movies_event.dart';
import 'package:MovieDB/bloc/movies_bloc/movies_state.dart';
import 'package:MovieDB/bloc/tv_bloc/tv_bloc.dart';
import 'package:MovieDB/pages/loading_text_widget.dart';
import 'package:MovieDB/widgets/tv_last_episode_widget.dart';
import 'package:MovieDB/model/tv_details.dart';
import 'package:MovieDB/repository/tv_series_repository.dart';
import 'package:MovieDB/widgets/trailers_row_widget.dart';
import 'package:MovieDB/widgets/tv_list_row.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/auth_bloc.dart';
import 'package:MovieDB/bloc/auth_bloc/bloc.dart';
import 'package:MovieDB/widgets/auth_modal_form.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shimmer/shimmer.dart';

import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/model/movie_images.dart';
import 'package:MovieDB/pages/image_slide_screen.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/widgets/cast_list.dart';

class TvDetailPage extends StatefulWidget {
  final int id;
  final User user;

  TvDetailPage({Key key, this.id, this.user}) : super(key: key);

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  TvBloc _tvBloc = TvBloc();
  MoviesBloc mBloc = MoviesBloc();

  int backdropindex = 0;

  @override
  void initState() {
    // _movieBloc.add(LoadMovieVideosEvent(id: widget.movie.id));
//    print("ID:${widget.id}");
    _tvBloc.add(LoadTvDetailsEvent(id: widget.id));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

// print(movie.genries);
    return Scaffold(
      // backgroundColor: Colors.white,
      body: BlocBuilder<TvBloc, TvState>(
        bloc: _tvBloc,
        builder: (BuildContext context, state) {
          if (state is TvLoadingState) {
            return Center(
                child: LoadingTextWidget(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              text: "Loading...",
            ));
          }
          if (state is TvDetailsReadyState) {
            TvDetails tv = state.tvDetails;
            var videoDetails = state.videoDetails;
            Credit credit = state.credit;

//            BlocProvider.of<MoviesBloc>(context)
//                .add(GetFavouriteEvent(id: tv.id, mediaType: MediaType.TV));
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: screenSize.height * 0.4,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  elevation: 8,
                  actions: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () {
                          MovieRepository.shareImage(
                              'Share this movie',
                              'Hi, from MovieDB,\n I would like you to check this movie out => ${tv.name}\n${tv.homepage}',
                              tv.posterPath);
                          // Share.text('Share this movie', 'Hi, from MovieDB,\n I would like you to check this movie out => ${movieDetails.title}\n${movieDetails.homepage}', "text/*");
                        },
                        icon: Icon(Icons.share),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle),
                      child: FavouriteWidget(tvDetails: tv),
                    )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.pin,
                    background: Stack(fit: StackFit.expand, children: [
                      Container(
                        height: screenSize.height,
                        width: screenSize.width,
                        child: Center(child: _buildBackdropCarousel(tv.id)),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          // height: 100,
                          padding: EdgeInsets.only(
                              top: 20.0, left: 16.0, right: 16.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // tileMode: TileMode.repeated,
                                  colors: <Color>[
                                Theme.of(context).canvasColor,
                                Theme.of(context).canvasColor.withOpacity(0.9),
                                Theme.of(context).canvasColor.withOpacity(0.7),
                                Theme.of(context).canvasColor.withOpacity(0.3),
                                Colors.transparent
                              ])),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 16, bottom: 10),
                                child: Text(
                                  tv.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                        fontSize: 28,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Wrap(
                                              runAlignment: WrapAlignment.start,

                                              direction: Axis.horizontal,

                                              // runSpacing: 0,

                                              spacing: 5,

                                              children: tv.genres
                                                  .map((f) => GestureDetector(
                                                      onTap: () {},
                                                      child: Chip(
                                                        label: Text(f.name),
                                                      )))
                                                  .toList(),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.star,
                                                    color: Colors.orange),
//                                                SizedBox(
//                                                  width: 5,
//                                                ),
                                                Text('${tv.voteAverage}'),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(Icons.date_range),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      '${tv.firstAirDate.day}-${tv.firstAirDate.month}-${tv.firstAirDate.year}'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      CachedNetworkImage(
                                        imageUrl:
                                           tv.posterPath != null ? "${IMAGE_URL + tv.posterPath}":IMAGE_TEMP_URL,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 130,
                                        placeholder: (context, url) => Center(
                                            child: Shimmer.fromColors(
                                                child: Container(
                                                  width: 100,
                                                  height: 130,
                                                ),
                                                baseColor: Colors.grey[600],
                                                highlightColor:
                                                    Colors.grey[700])),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  WatchListButton(
                                    details: tv,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  Text(
                                    "Overview",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 8,
                                  ),
                                  // ReadMoreText('${movieDetails.overview}',expandingButtonColor: Theme.of(context).accentColor,),
                                  Text(
                                    '${tv.overview}',
                                    style: TextStyle(height: 1.5),
                                  ),

                                  SizedBox(
                                    height: 30,
                                  ),

                                  TvLastEpisodeWidget(
                                      tv: tv, screenSize: screenSize),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Trailer Videos",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Container(
                              height: 200,
                              // width: 350,
                              margin: EdgeInsets.only(bottom: 20.0),
                              child: TrailersVideoRow(
                                  videos: videoDetails.results),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CastList(
                              title: "Cast",
                              credit: credit,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            TvListRow(
                              title: "Similar Shows",
                              type: TvCat.Similar,
                              id: tv.id,
                            ),
//                            MovieReviewWidget(movieDetails: movieDetails,)
                          ],
                        ),
                      ),
                    ),
                  ]),
                )
              ],
            );
          }

          return Center(child: Text("Nothing was found!"));
        },
      ),
    );
  }

  Widget _buildBackdropCarousel(int id) {
    return FutureBuilder(
      future: new MovieRepository().getMovieImages(id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data != null) {
          List<Backdrop> backdrops = snapshot.data.backdrops;
          if (backdrops.length > 0)
            return GFCarousel(
              items: backdrops
                  .map((backdrop) => _buildBackdropItem(backdrops, backdrop))
                  .toList(),
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (i) {
                backdropindex = i;
              },
              height: MediaQuery.of(context).size.height,
              // aspectRatio: 1.0,
              // scrollPhysics: BouncingScrollPhysics(),
              viewportFraction: 1.0,
              // pagination: true,
              // pagerSize: 0,
              // activeIndicator: Colors.orange,
              // passiveIndicator: Theme.of(context).accentColor,
            );
        }
        return Center(
          child: Icon(Icons.error_outline),
        );
      },
    );
  }

  Widget _buildBackdropItem(List<Backdrop> backdrops, Backdrop backdrop) {
    //  print("=" + backdrop.filePath);
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ImageSlideScreen(backdrops: backdrops, index: backdropindex))),
      child: Hero(
        tag: "backdrop",
        child: CachedNetworkImage(
          imageUrl: backdrop.filePath != null
              ? "${IMAGE_URL + backdrop.filePath}"
              : IMAGE_TEMP_URL,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}

class FavouriteWidget extends StatelessWidget {
  const FavouriteWidget({
    Key key,
    @required this.tvDetails,
  }) : super(key: key);

  final TvDetails tvDetails;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (BuildContext context, state) {
        if (state is AuthLoginState) {
          print("Auth State");
          User user = state.user;
          MoviesBloc mBloc = MoviesBloc();
          mBloc.add(GetFavouriteEvent(
              uid: user != null ? user.uid : 'empty',
              id: tvDetails.id,
              mediaType: MediaType.TV));
          return BlocBuilder<MoviesBloc, MoviesState>(
            bloc: mBloc,
            builder: (BuildContext context, state) {
              if (state is FavouriteItemState) {
                // print(state.favourite.title);
                print("dfhchkvbknl/n;m:");

                return IconButton(
                  onPressed: () {
                    if (user != null) {
                      if (state.favourite != null) {
                        print("Calling delete");
                        mBloc.add(DeleteFavouriteMovieItem(
                            movieId: tvDetails.id,
                            uid: user.uid,
                            mediaType: MediaType.TV));
                      } else {
                        print("Calling Add");
                        mBloc.add(AddFavouritesEvent(
                            details: tvDetails,
                            uid: user.uid,
                            mediaType: MediaType.TV));
                      }
                    } else {
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
                    }
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: state.favourite != null ? Colors.red : Colors.white,
                  ),
                );
              }

              // return SizedBox.shrink();

              return IconButton(
                onPressed: () {
                  if (user != null) {
                    print("Calling Adding 2");
                    mBloc.add(AddFavouritesEvent(
                        details: tvDetails,
                        uid: user.uid,
                        mediaType: MediaType.TV));
                  } else {
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
                  }
                },
                icon: Icon(Icons.favorite),
              );
            },
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}

class WatchListButton extends StatelessWidget {
  final details;

  const WatchListButton({
    Key key,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoviesBloc _moviesBloc = BlocProvider.of<MoviesBloc>(context);
    BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (BuildContext context, AuthState state) {
        if (state is AuthLoginState) {
          var user = state.user;
          _moviesBloc.add(GetWatchListItemEvent(
              id: details.id, uid: user?.uid, mediaType: MediaType.TV));
          return BlocBuilder(
            bloc: _moviesBloc,
            builder: (BuildContext context, state) {
              if (state is WatchListItem) {
                print("Watchlist yielded");
                return MaterialButton(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textColor: Theme.of(context).canvasColor,
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    if (user != null) {
                      if (state.watchListItem != null) {
                        _moviesBloc.add(DeleteWatchListMovieItem(
                            movieId: details.id,
                            uid: user.uid,
                            mediaType: MediaType.TV));
                      } else {
                        _moviesBloc.add(AddWatchListEvent(
                            movieDetails: details,
                            uid: user.uid,
                            mediaType: MediaType.TV));
                      }
                    } else {
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
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(state.watchListItem != null
                          ? Icons.delete
                          : Icons.add),
                      SizedBox(
                        width: 16,
                      ),
                      Center(
                          child: state.watchListItem == null
                              ? Text("Add to Watch List")
                              : Text("Remove from Watch List")),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
