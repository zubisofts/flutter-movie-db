import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/movies_bloc.dart';

import 'package:flutter_ui_challenge/model/movie.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/video_details.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';
import 'package:flutter_ui_challenge/widgets/list_row.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  MovieDetailPage({
    Key key,
    this.movie,
  }) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MoviesBloc _movieBloc = MoviesBloc();

  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    // _movieBloc.add(LoadMovieVideosEvent(id: widget.movie.id));
    _movieBloc.add(LoadMovieDetailsEvent(id: widget.movie.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
// print(movie.genries);
    return Scaffold(
      // backgroundColor: Colors.white,
      body: BlocBuilder(
        bloc: _movieBloc,
        builder: (BuildContext context, state) {
          if (state is LoadingState) {
            return Center(
                child: SpinKitHourGlass(
              color: Colors.greenAccent,
            ));
          }
          if (state is MovieDetailsReadyState) {
            MovieDetails movieDetails = state.movieDetails;
            VideoDetails videoDetails = state.videoDetails;

            var result = videoDetails.results[0];
            // print(state.similarMovies);
            _controller = YoutubePlayerController(
              initialVideoId: '${result.key}',
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
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.share),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border),
                    )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    // title: Text('Movie Details'),
                    // stretchModes: [StretchMode.blurBackground],
                    centerTitle: true,
                    collapseMode: CollapseMode.pin,
                    background: Stack(fit: StackFit.expand, children: [
                      Container(
                        height: screenSize.height * 0.4,
                        width: screenSize.width,
                        //  child: Image.network(movie.backdrop,fit: BoxFit.cover,),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                                image: NetworkImage(
                                  movieDetails.backdropPath,
                                ),
                                fit: BoxFit.cover)),
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
                                  tileMode: TileMode.repeated,
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
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 10),
                                child: Text(movieDetails.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(fontSize: 28)),
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
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: <Widget>[
                            //     Expanded(
                            //         flex: 5,
                            //         child: Text(movieDetails.title,
                            //             style: Theme.of(context)
                            //                 .textTheme
                            //                 .title
                            //                 .copyWith(fontSize: 28))),
                            //     Container(
                            //       padding: EdgeInsets.symmetric(
                            //           horizontal: 10, vertical: 3),
                            //       decoration: BoxDecoration(
                            //           border: Border.fromBorderSide(BorderSide(
                            //             color: Colors.white,
                            //           )),
                            //           borderRadius: BorderRadius.circular(10)),
                            //       child: Center(
                            //         child: Text("\$345.0"),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            SizedBox(
                              height: 8,
                            ),
                            // Wrap(
                            //   alignment: WrapAlignment.start,
                            //   runAlignment: WrapAlignment.start,
                            //   direction: Axis.vertical,
                            //   children: movieDetails.genres
                            //       .map((f) => InkWell(
                            //         onTap: (){},
                            //         radius: 10,
                            //         child: _buildGenry(f.name)))
                            //       .toList(),
                            // ),
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
                                Icon(Icons.star, color: Colors.orange),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('${movieDetails.voteAverage}'),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(Icons.date_range),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('${movieDetails.releaseDate}'),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "About Movie",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text('${movieDetails.overview}'),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Trailer: ${result.name}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
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

  Widget _buildGenry(String name) {
    return Container(
      margin: EdgeInsets.only(right: 3.0),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          border: Border.fromBorderSide(BorderSide(
            color: Theme.of(context).buttonColor,
          )),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(name),
      ),
    );
  }
}
