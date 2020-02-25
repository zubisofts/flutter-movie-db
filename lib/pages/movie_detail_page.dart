import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ui_challenge/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter_ui_challenge/bloc/auth_bloc/bloc.dart';
import 'package:flutter_ui_challenge/pages/sign_in_page.dart';
import 'package:flutter_ui_challenge/widgets/auth_modal_form.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter_ui_challenge/bloc/movies_bloc/bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/movies_bloc.dart';
import 'package:flutter_ui_challenge/model/credit.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/movie_images.dart';
import 'package:flutter_ui_challenge/pages/image_slide_screen.dart';
import 'package:flutter_ui_challenge/repository/constants.dart';
import 'package:flutter_ui_challenge/repository/movie_repository.dart';
import 'package:flutter_ui_challenge/widgets/list_row.dart';
import 'package:flutter_ui_challenge/widgets/movie_cast_list.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;
  final FirebaseUser user;
  MovieDetailPage({
    Key key,
    this.id,
    this.user
  }) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MoviesBloc _movieBloc = MoviesBloc();

  YoutubePlayerController _controller;
  int backdropindex = 0;

  @override
  void initState() {
    // _controller = YoutubePlayerController(
    //   initialVideoId: 'iLnmTe5Q2Qw',
    //   flags: YoutubePlayerFlags(
    //     autoPlay: false,
    //     mute: false,
    //   ),
    // );
    // _movieBloc.add(LoadMovieVideosEvent(id: widget.movie.id));
    _movieBloc.add(LoadMovieDetailsEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());
    Size screenSize = MediaQuery.of(context).size;
// print(movie.genries);
    return Scaffold(
      // backgroundColor: Colors.white,
      body: BlocBuilder<MoviesBloc, MoviesState>(
        bloc: _movieBloc,
        builder: (BuildContext context, state) {
          if (state is MovieLoadingState) {
            return Center(
                child: SpinKitHourGlass(
              color: Colors.greenAccent,
            ));
          }
          if (state is MovieDetailsReadyState) {
            MovieDetails movieDetails = state.movieDetails;
            var videoDetails = state.videoDetails;
            Credit credit = state.credit;

            BlocProvider.of<MoviesBloc>(context)
                .add(GetFavouriteEvent(id: movieDetails.id));
            var result = videoDetails.results.length > 0
                ? videoDetails.results[0]
                : null;
            // print(state.similarMovies);
            _controller = YoutubePlayerController(
              initialVideoId: '${result != null ? result.key : ""}',
              flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );

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
                              'Hi, from MovieDB,\n I would like you to check this movie out => ${movieDetails.title}\n${movieDetails.homepage}',
                              movieDetails.posterPath);
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
                      child: FavouriteWidget(movieDetails: movieDetails),
                    )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.pin,
                    background: Stack(fit: StackFit.expand, children: [
                      Container(
                        height: screenSize.height,
                        width: screenSize.width,
                        child: Center(
                            child: _buildBackdropCarousel(movieDetails.id)),
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
                                  movieDetails.title,
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
                                  const EdgeInsets.symmetric(horizontal: 32.0),
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

                                              children: movieDetails.genres
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
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    '${movieDetails.voteAverage}'),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(Icons.date_range),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    '${movieDetails.releaseDate}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      CachedNetworkImage(
                                        imageUrl:
                                            "${IMAGE_URL + movieDetails.posterPath}",
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 130,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  WatchListButton(
                                    movieDetails: movieDetails,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  Text(
                                    "About Movie",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),

                                  SizedBox(
                                    height: 8,
                                  ),
                                  // ReadMoreText('${movieDetails.overview}',expandingButtonColor: Theme.of(context).accentColor,),
                                  Text('${movieDetails.overview}'),

                                  SizedBox(
                                    height: 30,
                                  ),

                                  Text(
                                    "Trailer: ${result != null ? result.name : "Trailer Unavailable"}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(bottom: 20.0),

                                    // height: 200,

                                    // width: screenSize.width,

                                    child: YoutubePlayer(
                                      controller: _controller,
                                      showVideoProgressIndicator: true,
                                      onReady: () {
                                        // print('ready');

                                        _controller.addListener(() {});
                                      },
                                      progressColors: ProgressBarColors(
                                        playedColor: Colors.amber,
                                        handleColor: Colors.amberAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MovieCastList(
                              title: "Cast",
                              credit: credit,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListRow(
                              title: "Similar Movies",
                              type: MovieCat.Similar,
                              id: movieDetails.id,
                            ),
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
      builder: (BuildContext context, AsyncSnapshot<MovieImages> snapshot) {
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
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ImageSlideScreen(backdrops: backdrops, index: backdropindex))),
      child: Hero(
        tag: "backdrop",
        child: CachedNetworkImage(
          imageUrl: backdrop.filePath != null
              ? "${IMAGE_URL + backdrop.filePath}"
              : "assets/images/no-image.jpg",
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
    @required this.movieDetails,
  }) : super(key: key);

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, state) {
        if (state is AuthLoginState) {
          print("Auth State");
          FirebaseUser user = state.user;
          BlocProvider.of<MoviesBloc>(context).add(GetFavouriteEvent(uid: user?.uid,id: movieDetails.id));
          return BlocBuilder(
            bloc: BlocProvider.of<MoviesBloc>(context),
            builder: (BuildContext context, state) {
              if (state is FavouriteItemState) {
                return (state.favourite != null)
                    ? IconButton(
                        onPressed: () {
                          if (user != null) {
                            BlocProvider.of<MoviesBloc>(context).add(
                                AddFavouritesEvent(
                                    movieDetails: movieDetails, uid: user.uid));
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
                          color: user != null ? Colors.red : Colors.white,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          if (user != null) {
                            BlocProvider.of<MoviesBloc>(context).add(
                                AddFavouritesEvent(
                                    movieDetails: movieDetails, uid: user.uid));
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
              }

              return IconButton(
                onPressed: () {
                  if (user != null) {
                    BlocProvider.of<MoviesBloc>(context).add(AddFavouritesEvent(
                        movieDetails: movieDetails, uid: user.uid));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SignInPage()));
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
  final MovieDetails movieDetails;
  const WatchListButton({
    Key key,
    this.movieDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    MoviesBloc _moviesBloc = BlocProvider.of<MoviesBloc>(context);
//    BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (BuildContext context, AuthState state) {
        if (state is AuthLoginState) {
          var user = state.user;
          BlocProvider.of<MoviesBloc>(context).add(GetWatchListItemEvent(id: movieDetails.id,uid: user?.uid));
          return BlocBuilder(
            bloc: BlocProvider.of<MoviesBloc>(context),
            builder: (BuildContext context, state) {
              if (state is WatchListItem) {
                if (state.watchListItem != null) {
                  return MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    textColor: Theme.of(context).canvasColor,
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                       if (user != null) {
                         BlocProvider.of<MoviesBloc>(context).add(
                          DeleteWatchListMovieItem(movieId: movieDetails.id,uid: user.uid));
                           Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "${movieDetails.title} has been removed from watch list"),
                      ));
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
                        Icon(Icons.delete),
                        SizedBox(
                          width: 16,
                        ),
                        Center(child: Text("Remove from Watch List")),
                      ],
                    ),
                  );
                }
              }

              return MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textColor: Theme.of(context).canvasColor,
                color: Theme.of(context).accentColor,
                onPressed: () {
                   if (user != null) {
                     BlocProvider.of<MoviesBloc>(context)
                      .add(AddWatchListEvent(movieDetails: movieDetails,uid: user.uid));
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
                    Icon(Icons.add),
                    SizedBox(
                      width: 16,
                    ),
                    Center(child: Text("Add to Watch List")),
                  ],
                ),
              );
            },
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
