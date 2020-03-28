import 'package:MovieDB/model/credit.dart';
import 'package:MovieDB/model/tv_season_details.dart';
import 'package:MovieDB/model/video_details.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:MovieDB/repository/movie_repository.dart';
import 'package:MovieDB/widgets/cast_list.dart';
import 'package:MovieDB/widgets/custom_path_clipper.dart';
import 'package:MovieDB/widgets/trailers_row_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EpisodeDetailsPage extends StatefulWidget {
  final Episode episode;
  final int seasonId;

  const EpisodeDetailsPage({Key key, this.episode, this.seasonId})
      : super(key: key);

  @override
  _EpisodeDetailsPageState createState() => _EpisodeDetailsPageState();
}

class _EpisodeDetailsPageState extends State<EpisodeDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gradient2 =
        LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
            // tileMode: TileMode.repeated,
            colors: <Color>[
          Theme.of(context).canvasColor,
          Theme.of(context).canvasColor.withOpacity(0.9),
          Theme.of(context).canvasColor.withOpacity(0.7),
          Theme.of(context).canvasColor.withOpacity(0.3),
          Colors.transparent
        ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Episode ${widget.episode.episodeNumber}'),
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: widget.episode.stillPath != null
                        ? "${IMAGE_URL + widget.episode.stillPath}"
                        : "assets/images/no-image.jpg",
                    fit: BoxFit.cover,
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
              Positioned(
                bottom: -1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(gradient: gradient2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.episode.name,
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: ClipPath(
                            child: InkWell(
                              onTap: () async {
//                              MovieDetails movieDetails =
//                              await new MovieRepository()
//                                  .getMovieDetails(movie.id);
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
                            clipper: CustomTagClipper()),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Overview',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  widget.episode.overview,
                  style: TextStyle(color: Colors.grey[400]),
                ),
                SizedBox(
                  height: 16,
                ),
                VideoWidget(
                  details: widget.episode,
                  id: widget.seasonId,
                ),
                SizedBox(
                  height: 16,
                ),
                CastWidgetRow(
                  details: widget.episode,
                  id: widget.seasonId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CastWidgetRow extends StatelessWidget {
  final Episode details;
  final int id;

  const CastWidgetRow({
    Key key,
    this.details,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FutureBuilder(
          future: new MovieRepository().getCredits(id,
              type: 2, sn: details.seasonNumber, epn: details.episodeNumber),
          builder: (BuildContext context, AsyncSnapshot<Credit> snapshot) {
            return snapshot.hasData
                ? CastList(
                    title: "Cast",
                    credit: snapshot.data,
                  )
                : Center(child: CircularProgressIndicator());
          },
        )
      ],
    );
  }
}

class VideoWidget extends StatefulWidget {
  final Episode details;
  final int id;

  const VideoWidget({Key key, this.details, this.id}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: new MovieRepository().getVideos(widget.id,
            sn: widget.details.seasonNumber,
            epn: widget.details.episodeNumber,
            type: 2),
        builder: (BuildContext context, AsyncSnapshot<VideoDetails> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.results.length == 0) {
              return Center(
                  child: Text(
                "No videos for this episode",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ));
            }
            return TrailersVideoRow(
              videos: snapshot.data.results,
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
