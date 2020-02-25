import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/bloc.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/movie_list.dart';
import 'package:flutter_ui_challenge/pages/movie_detail_page.dart';
import 'package:flutter_ui_challenge/repository/constants.dart';
import 'package:flutter_ui_challenge/repository/movie_repository.dart';
import 'package:flutter_ui_challenge/widgets/custom_path_clipper.dart';

class MovieItemHorizontal extends StatelessWidget {
  const MovieItemHorizontal({
    Key key,
    @required this.movie,
    this.user,
  }) : super(key: key);

  final Results movie;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    MoviesBloc _moviesBloc = MoviesBloc();
    _moviesBloc.add(GetWatchListItemEvent(id: movie.id, uid: user?.uid));
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 100,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MovieDetailPage(id: movie.id)));
        },
        child: Container(
//        margin: EdgeInsets.all(10.0),
          // height: 250,
//          width: 100,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: "${IMAGE_URL + movie.posterPath}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${movie.title}',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                              ),
                              Text('${movie.voteAverage}')
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
            user != null
                ? BlocBuilder<MoviesBloc, MoviesState>(
                    bloc: _moviesBloc,
                    builder: (BuildContext context, MoviesState state) {
                      if (state is WatchListItem) {
                        print("What");
                        return Container(
                          child: ClipPath(
                            
                              child: InkWell(
                                onTap: () async {
                                  if (state.watchListItem != null) {
                                    _moviesBloc.add(DeleteWatchListMovieItem(
                                        uid: user.uid, movieId: movie.id));
                                  } else {
                                    MovieDetails movieDetails =
                                        await new MovieRepository()
                                            .getMovieDetails(movie.id);
                                    _moviesBloc.add(AddWatchListEvent(
                                        movieDetails: movieDetails,
                                        uid: user.uid));
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: state.watchListItem != null
                                          ? Theme.of(context).accentColor
                                          : Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10))),
                                  child: Center(
                                    child: Icon(
                                      state.watchListItem != null
                                          ? Icons.check
                                          : Icons.add,
                                      color: state.watchListItem != null
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              clipper: CustomTagClipper()),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  )
                : SizedBox.shrink()
          ]),
        ),
      ),
    );
  }
}
