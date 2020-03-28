import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:MovieDB/bloc/auth_bloc/bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/pages/movie_detail_page.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/repository/movie_repository.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(ListenToLoginEvent());
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
        elevation: 0,
      ),
      body: BlocBuilder(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (BuildContext context, state) {
          if (state is AuthLoginState) {
            return state.user != null
                ? FavouritesWidgetBuild(uid: state.user.uid)
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Please sign in to view Favourites",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        RaisedButton(
                          child: Text(
                            "Sign in",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {},
                        )
                      ],
                    ),
                  );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}

class FavouritesWidgetBuild extends StatefulWidget {
  final String uid;

  const FavouritesWidgetBuild({
    Key key,
    this.uid,
  }) : super(key: key);

  @override
  _FavouritesWidgetBuildState createState() => _FavouritesWidgetBuildState();
}

class _FavouritesWidgetBuildState extends State<FavouritesWidgetBuild> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MoviesBloc>(context)
        .add(LoadFavouriteMoviesEvent(uid: widget.uid));
    return BlocBuilder<MoviesBloc, MoviesState>(
      bloc: BlocProvider.of<MoviesBloc>(context),
      builder: (BuildContext context, state) {
        if (state is FavouriteMoviesLoaded) {
          return Column(
            children: <Widget>[
//              Container(
//                padding: EdgeInsets.symmetric(horizontal: 16.0),
//                color: Theme.of(context).accentColor.withOpacity(0.3),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  mainAxisSize: MainAxisSize.max,
//                  children: [
//                    Row(children: <Widget>[
//                      Text(
//                        "Favourites List",
//                        style: TextStyle(fontWeight: FontWeight.w600),
//                      ),
//                      SizedBox(
//                        width: 8,
//                      ),
//                      Icon(
//                        Icons.favorite,
//                        color: Colors.red,
//                      ),
//                    ]),
//                    FlatButton(
//                      onPressed: () {},
//                      child: Row(
//                        children: <Widget>[
//                          Text("Clear List"),
//                          Icon(
//                            Icons.delete,
//                            color: Colors.redAccent,
//                          )
//                        ],
//                      ),
//                    )
//                  ],
//                ),
//              ),
              Expanded(
                child: state.favourites.length > 0
                    ? ListView.builder(
                        itemCount: state.favourites.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MovieListTile(
                              movieDetails: state.favourites[index],
                              uid: widget.uid);
                        },
                      )
                    : Center(
                        child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              size: MediaQuery.of(context).size.width * 0.6,
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.5),
                            ),
                            Text(
                              "Your Favourites List is Empty",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        }
        return Center(
          child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.favorite,
                size: MediaQuery.of(context).size.width * 0.6,
                color: Theme.of(context).accentColor.withOpacity(0.5),
              ),
              Text(
                "Your Favourites List is Empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MovieListTile extends StatefulWidget {
  final MovieDetails movieDetails;
  final String uid;

  MovieListTile({Key key, this.movieDetails, this.uid}) : super(key: key);

  @override
  _MovieListTileState createState() => _MovieListTileState();
}

class _MovieListTileState extends State<MovieListTile> {
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: _slidableController,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MovieDetailPage(
                    id: widget.movieDetails.id,
                  )));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: "${IMAGE_URL + widget.movieDetails.posterPath}",
                    fit: BoxFit.cover,
                    width: 70,
                    height: 85,
                    placeholder: (context, url) => Center(
                        child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.movieDetails.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.movieDetails.overview,
                      style: TextStyle(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          FontAwesome.star,
                          size: 16,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("${widget.movieDetails.voteAverage}"),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () async => await MovieRepository.shareImage(
              "Share this movie with",
              "Hi from MovieDB, I would like you to checkout this movie\n${widget.movieDetails.title}\m${widget.movieDetails.homepage}",
              widget.movieDetails.posterPath),
        ),
        IconSlideAction(
          caption: 'Remove',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => BlocProvider.of<MoviesBloc>(context).add(
              DeleteFavouriteMovieItem(
                  movieId: widget.movieDetails.id, uid: widget.uid)),
        ),
      ],
    );
  }
}
