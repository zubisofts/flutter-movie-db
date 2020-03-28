import 'package:MovieDB/model/tv_details.dart';
import 'package:MovieDB/pages/tv_season_detail_page.dart';
import 'package:MovieDB/repository/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TvSeasonsList extends StatefulWidget {
  final TvDetails tvDetails;

  const TvSeasonsList({Key key, this.tvDetails}) : super(key: key);

  @override
  _TvSeasonsListState createState() => _TvSeasonsListState();
}

class _TvSeasonsListState extends State<TvSeasonsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tvDetails.name),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
//            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: widget.tvDetails.seasons.length,
            itemBuilder: (BuildContext context, int index) {
              Season season = widget.tvDetails.seasons[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.all(16),
                elevation: 8,
                color: Theme.of(context).canvasColor,
                child: Stack(children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              TvSeasonDetailsPage(
                                id: widget.tvDetails.id,
                                season: season,
                              )));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 16, right: 8, top: 16, bottom: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: season.posterPath != null
                                    ? "${IMAGE_URL + season.posterPath}"
                                    : "assets/images/no-image.jpg",
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
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
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
                                              padding: EdgeInsets.only(
                                                  top: 16,),
                                              child: Text(
                                                '${season.name} | ${season.episodeCount} Episodes',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                  season.overview,
                                  style: TextStyle(color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
