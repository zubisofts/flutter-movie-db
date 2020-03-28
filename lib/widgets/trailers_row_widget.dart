import 'dart:ui';

import 'package:MovieDB/model/video_details.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailersVideoRow extends StatelessWidget {
  final List<Results> videos;

  TrailersVideoRow({
    Key key,
    this.videos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        String thumbnail =
            YoutubePlayer.getThumbnail(videoId: videos[index].key);
        // print("=" + thumbnail);
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              _showVideoDialog(context, videos[index]);
            },
            child: Container(
              width: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Stack(children: [
                      Image.network(
                        thumbnail,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration:
                              BoxDecoration(color: Colors.black.withOpacity(0.5)),
                          child: Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          videos[index].name,
                          maxLines: 2,
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showVideoDialog(BuildContext context, Results video) {
    showDialog(
        context: context,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: SimpleDialog(
            title: Text(
              video.name,
              style: TextStyle(color: Colors.white),
            ),
            children: <Widget>[
              Row(
                children: <Widget>[
                ],
              ),
              TrailerPlayer(
                video: video,
              ),
            ],
            backgroundColor: Colors.black,
          ),
        ));
  }
}

class TrailerPlayer extends StatefulWidget {
  final Results video;

  TrailerPlayer({
    Key key,
    this.video,
  }) : super(key: key);

  @override
  _TrailerPlayerState createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.key,
      flags: YoutubePlayerFlags(
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: YoutubePlayer(
        aspectRatio: 0.4,
        controller: _controller,
//        showVideoProgressIndicator: true,
        topActions: <Widget>[],
        onEnded: (c) {
//          _controller.reload();
        },
        onReady: () {
          // print('ready');

          _controller.addListener(() {});
        },
//        progressColors: ProgressBarColors(
//          playedColor: Colors.amber,
//          handleColor: Colors.amberAccent,
//        ),
      ),
    );
  }
}
