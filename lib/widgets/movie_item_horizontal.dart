import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MovieDB/bloc/movies_bloc/bloc.dart';
import 'package:MovieDB/model/movie_details.dart';
import 'package:MovieDB/model/movie_list.dart';
import 'package:MovieDB/pages/movie_detail_page.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/widgets/custom_path_clipper.dart';
import 'package:shimmer/shimmer.dart';

class MovieItemHorizontal extends StatelessWidget {
  const MovieItemHorizontal({
    Key key,
    @required this.movie,
    this.user,
  }) : super(key: key);

  final Results movie;
  final User user;

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
              builder: (BuildContext context) =>
                  MovieDetailPage(id: movie.id)));
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
                    flex: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: movie.posterPath != null
                            ? "${IMAGE_URL + movie.posterPath}"
                            : IMAGE_TEMP_URL,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                            child: Shimmer.fromColors(
                          baseColor: Colors.grey[700],
                          highlightColor: Colors.grey[600],
                          child: Container(
                            color: Colors.grey,
                            width: 100,
                            height: MediaQuery.of(context).size.height,
                          ),
                        )),
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
                        return buildWatchListTag(state, _moviesBloc, context);
                      }
                      return ClipPath(
                          child: InkWell(
                            onTap: () async {
                              MovieDetails movieDetails =
                                  await new MovieRepository()
                                      .getMovieDetails(movie.id);
                              _moviesBloc.add(AddWatchListEvent(
                                  movieDetails: movieDetails,
                                  uid: user.uid,
                                  mediaType: MediaType.MOVIE));
                            },
                            child: Container(
                              height: 50,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10))),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          clipper: CustomTagClipper());
                    },
                  )
                : SizedBox.shrink()
          ]),
        ),
      ),
    );
  }

  Widget buildWatchListTag(
      WatchListItem state, MoviesBloc _moviesBloc, BuildContext context) {
    return Container(
      child: ClipPath(
          child: InkWell(
            onTap: () async {
              if (state.watchListItem != null) {
                _moviesBloc.add(DeleteWatchListMovieItem(
                    uid: user.uid,
                    movieId: movie.id,
                    mediaType: MediaType.MOVIE));
              } else {
                MovieDetails movieDetails =
                    await new MovieRepository().getMovieDetails(movie.id);
                _moviesBloc.add(AddWatchListEvent(
                    movieDetails: movieDetails,
                    uid: user.uid,
                    mediaType: MediaType.MOVIE));
              }
            },
            child: Container(
              height: 50,
              width: 40,
              decoration: BoxDecoration(
                  color: state.watchListItem != null
                      ? Theme.of(context).accentColor
                      : Colors.black.withOpacity(0.8),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(10))),
              child: Center(
                child: Icon(
                  state.watchListItem != null ? Icons.check : Icons.add,
                  color:
                      state.watchListItem != null ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          clipper: CustomTagClipper()),
    );
  }
}
