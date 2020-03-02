import 'package:MovieDB/bloc/tv_bloc/tv_bloc.dart';
import 'package:MovieDB/model/tv_list_model.dart';
import 'package:MovieDB/pages/tv_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/widgets/custom_path_clipper.dart';

class TvItemHorizontal extends StatelessWidget {
  const TvItemHorizontal({
    Key key,
    @required this.tv,
    this.user,
  }) : super(key: key);

  final Result tv;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    TvBloc _tvBloc = TvBloc();
    print("${tv.id}");
//    _moviesBloc.add(GetWatchListItemEvent(id: movie.id, uid: user?.uid));
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 100,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  TvDetailPage(id: tv.id)));
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
                        imageUrl:tv.posterPath!=null? "${IMAGE_URL + tv.posterPath}":"",
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
                            '${tv.name}',
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
                              Text('${tv.voteAverage}')
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
            user != null
                ? BlocBuilder<TvBloc, TvState>(
                    bloc: _tvBloc,
                    builder: (BuildContext context, TvState state) {
                      if (state is WatchListItem) {
                        return buildWatchListTag(state, _tvBloc, context);
                      }
                      return ClipPath(
                          child: InkWell(
                            onTap: () async {
//                              MovieDetails movieDetails =
//                                  await new MovieRepository()
//                                      .getMovieDetails(tv.id);
//                              _moviesBloc.add(AddWatchListEvent(
//                                  movieDetails: movieDetails, uid: user.uid));
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
      WatchListItem state, TvBloc tvBloc, BuildContext context) {
    return Container(
      child: ClipPath(
          child: InkWell(
            onTap: () async {
              if (state.watchListItem != null) {
//                _moviesBloc.add(
//                    DeleteWatchListMovieItem(uid: user.uid, movieId: movie.id));
              } else {
//                MovieDetails movieDetails =
//                    await new MovieRepository().getMovieDetails(movie.id);
//                _moviesBloc.add(AddWatchListEvent(
//                    movieDetails: movieDetails, uid: user.uid));
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
