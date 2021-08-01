import 'package:MovieDB/widgets/movie_review_widget.dart';
import 'package:MovieDB/pages/loading_text_widget.dart';
import 'package:MovieDB/widgets/trailers_row_widget.dart';
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

import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/movies_bloc.dart';
import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/model/movie_images.dart';
import 'package:MovieDB/pages/image_slide_screen.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/widgets/movie_list_row.dart';
import 'package:MovieDB/widgets/cast_list.dart';


class MovieDetailPage extends StatefulWidget {
  final int id;
  final User user;
  MovieDetailPage({Key key, this.id, this.user}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MoviesBloc _movieBloc = MoviesBloc();

  int backdropindex = 0;
  String videoId = "iLnmTe5Q2Qw";

  @override
  void initState() {
    // _movieBloc.add(LoadMovieVideosEvent(id: widget.movie.id));
    _movieBloc.add(LoadMovieDetailsEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

// print(movie.genries);
    return Scaffold(
      // backgroundColor: Colors.white,
      body: BlocBuilder<MoviesBloc, MoviesState>(
        bloc: _movieBloc,
        builder: (BuildContext context, state) {
          if (state is MovieLoadingState) {
            return LoadingTextWidget(baseColor: Colors.red,highlightColor: Colors.yellow,text: "Loading...",);
          }
          if (state is MovieDetailsReadyState) {
            MovieDetails movieDetails = state.movieDetails;
            var videoDetails = state.videoDetails;
            Credit credit = state.credit;

            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: screenSize.height * 0.45,
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
                        bottom: -1,
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
                                          fontFamily: "Poppins-Bold"),
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

                                              children: movieDetails.genres
                                                  .map((f) => GestureDetector(
                                                      onTap: () {},
                                                      child: Chip(
//                                                        backgroundColor: Theme.of(context).accentColor.withOpacity(0.5),
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
                                           movieDetails.posterPath != null ? "${IMAGE_URL + movieDetails.posterPath}":IMAGE_TEMP_URL,
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
                                    "Overview",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),

                                  SizedBox(
                                    height: 8,
                                  ),
                                  // ReadMoreText('${movieDetails.overview}',expandingButtonColor: Theme.of(context).accentColor,),
                                  Text('${movieDetails.overview}',
                                      style: TextStyle(height: 1.5)),

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
                                "Movie Trailers",
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
                            MovieListRow(
                              title: "Similar Movies",
                              type: MovieCat.Similar,
                              id: movieDetails.id,
                            ),
                            MovieReviewWidget(
                              movieDetails: movieDetails,
                            )
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
    @required this.movieDetails,
  }) : super(key: key);

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (BuildContext context, state) {
        if (state is AuthLoginState) {
//          print("Auth State");
          User user = state.user;
          MovieDetails fav;
          MoviesBloc mBloc = MoviesBloc();
          mBloc.add(GetFavouriteEvent(
              uid: user?.uid, id: movieDetails.id, mediaType: MediaType.MOVIE));
          return BlocBuilder(
            bloc: mBloc,
            builder: (BuildContext context, state) {
              if (state is FavouriteItemState) {
                // print(state.favourite.title);
                fav = state.favourite;
                return IconButton(
                  onPressed: () {
                    if (user != null) {
                      if (state.favourite != null) {
                        mBloc.add(DeleteFavouriteMovieItem(
                            movieId: movieDetails.id,
                            uid: user.uid,
                            mediaType: MediaType.MOVIE));
                      } else {
                        mBloc.add(AddFavouritesEvent(
                            details: movieDetails,
                            uid: user.uid,
                            mediaType: MediaType.MOVIE));
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
                    mBloc.add(AddFavouritesEvent(
                        details: movieDetails,
                        uid: user.uid,
                        mediaType: MediaType.MOVIE));
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
  final MovieDetails movieDetails;
  const WatchListButton({
    Key key,
    this.movieDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    MoviesBloc _moviesBloc = BlocProvider.of<MoviesBloc>(context);
    BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (BuildContext context, AuthState state) {
        if (state is AuthLoginState) {
          var user = state.user;
          BlocProvider.of<MoviesBloc>(context).add(GetWatchListItemEvent(
              id: movieDetails.id, uid: user?.uid, mediaType: MediaType.MOVIE));
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
                            DeleteWatchListMovieItem(
                                movieId: movieDetails.id,
                                uid: user?.uid,
                                mediaType: MediaType.MOVIE));
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
                    BlocProvider.of<MoviesBloc>(context).add(AddWatchListEvent(
                        movieDetails: movieDetails,
                        uid: user?.uid,
                        mediaType: MediaType.MOVIE));
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
