import 'package:MovieDB/model/tv_details.dart';
import 'package:MovieDB/pages/tv_seasons_page.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TvLastEpisodeWidget extends StatelessWidget {
  const TvLastEpisodeWidget({
    Key key,
    @required this.tv,
    @required this.screenSize,
  }) : super(key: key);

  final TvDetails tv;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Last Episode",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TvSeasonsList(tvDetails:tv)));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16.0)),
                child: Center(
                  child: Text(
                    "View All",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Theme.of(context).accentColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Card(
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: <Widget>[
              Container(
                width: screenSize.width,
                height: screenSize.width * 0.5,
                child: CachedNetworkImage(
                  imageUrl: tv.posterPath != null
                      ? "${IMAGE_URL + tv.lastEpisodeToAir.stillPath}"
                      : "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.7),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${tv.lastEpisodeToAir.name}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Episode ${tv.lastEpisodeToAir.episodeNumber} Season ${tv.lastEpisodeToAir.seasonNumber}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
