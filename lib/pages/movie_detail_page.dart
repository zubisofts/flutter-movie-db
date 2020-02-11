import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ui_challenge/model/movie_images.dart';
import 'package:flutter_ui_challenge/pages/image_slide_screen.dart';
import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter_ui_challenge/bloc/movies_bloc/bloc.dart';
import 'package:flutter_ui_challenge/bloc/movies_bloc/movies_bloc.dart';
import 'package:flutter_ui_challenge/model/credit.dart';
import 'package:flutter_ui_challenge/model/movie_details.dart';
import 'package:flutter_ui_challenge/model/movie_list.dart';
// import 'package:flutter_ui_challenge/model/video_details.dart';
import 'package:flutter_ui_challenge/respository/constants.dart';
import 'package:flutter_ui_challenge/respository/movie_respository.dart';
import 'package:flutter_ui_challenge/widgets/list_row.dart';
import 'package:flutter_ui_challenge/widgets/movie_cast_list.dart';

class MovieDetailPage extends StatefulWidget {
  final Results movie;
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
    _movieBloc.add(LoadMovieDetailsEvent(id: widget.movie.id));
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
          if (state is LoadingState) {
            return Center(
                child: SpinKitHourGlass(
              color: Colors.greenAccent,
            ));
          }
          if (state is MovieDetailsReadyState) {
            MovieDetails movieDetails = state.movieDetails;
            var videoDetails = state.videoDetails;
            Credit credit = state.credit;

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
                  elevation: 8,
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
                                    "Trailer: ${result.name}",
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
      future: new MovieRespository().getMovieImages(id),
      builder: (BuildContext context, AsyncSnapshot<MovieImages> snapshot) {
        if (snapshot.data != null) {
          List<Backdrop> backdrops = snapshot.data.backdrops;
          if (backdrops.length > 0)
            return GFCarousel(
              items: backdrops
                  .map((backdrop) => _buildBackdropItem(backdrops, backdrop))
                  .toList(),
              autoPlay: false,
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
          imageUrl: "${IMAGE_URL + backdrop.filePath}",
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
