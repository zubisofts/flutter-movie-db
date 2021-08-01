import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:MovieDB/bloc/movies_bloc/bloc.dart';

import 'package:MovieDB/model/movie_list.dart';
import 'package:MovieDB/pages/movie_detail_page.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/widgets/auth_modal_form.dart';

class MovieItemVertical extends StatelessWidget {
  final Results movie;
  final User user;

  MovieItemVertical({Key key, this.movie, this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoviesBloc _mBloc = MoviesBloc();
    _mBloc.add(GetWatchListItemEvent(uid: user?.uid, id: movie.id));
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(16),
      elevation: 5,
      color: Theme.of(context).canvasColor,
      child: Stack(children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    MovieDetailPage(id: movie.id)));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  margin:
                      EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterPath != null
                          ? "${IMAGE_URL + movie.posterPath}"
                          : IMAGE_TEMP_URL,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 85,
                      placeholder: (context, url) => Center(
                          child: SizedBox(
                              width: 24,
                              height: 24,
                              child: Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1,
                              )))),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 16, right: 32),
                                    child: Text(
                                      movie.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        movie.overview,
                        style: TextStyle(color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                        Text("${movie.voteAverage}"),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<MoviesBloc, MoviesState>(
          bloc: _mBloc,
          builder: (BuildContext context, MoviesState state) {
            if (state is WatchListItem) {
              return Positioned(
                right: -40,
                child: InkWell(
                  onTap: () async {
                    if (user != null) {
                      if (state.watchListItem != null) {
                        _mBloc.add(DeleteWatchListMovieItem(
                            movieId: movie.id, uid: user.uid));
                      } else {

                        var movieDetails = await new MovieRepository()
                            .getMovieDetails(movie.id);

                        _mBloc.add(AddWatchListEvent(
                            movieDetails: movieDetails, uid: user.uid));
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
                  child: Transform.rotate(
                    angle: 0.78,
                    child: Container(
                      width: 100,
                      height: 40,
                      child: Transform.rotate(
                          angle: -0.78,
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: state.watchListItem != null
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                              )
                            ],
                          )),
                      color: state.watchListItem != null
                          ? Theme.of(context).accentColor.withOpacity(0.5)
                          : Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ]),
    );
  }
}
